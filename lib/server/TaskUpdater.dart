import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/service/task_service.dart';

import '../model/household/household.dart';
import '../model/task/task.dart';
import '../service/household_service.dart';

class TaskUpdater {
  final TaskService _taskService = GetIt.instance<TaskService>();
  final HouseholdService _householdService = GetIt.instance<HouseholdService>();

  late final stream;

  TaskUpdater() {
    print("TaskUpdater Instantiated!");
    final tasksStream = _taskService.getTasksStream();

    // Poll tasks periodically
    stream = Stream.periodic(Duration(seconds: 5))
        .asyncMap((_) => tasksStream.first);

    listenToUpdates();
  }

  void listenToUpdates() {
    stream.listen(_autoUpdate, onError: (error) {
      print('Stream error: $error');
    });
  }

  void _autoUpdate(_) {
    print(_);
  }
}

Future<void> updateHouseholdRotation(Household household) async {
  final taskService = GetIt.instance<TaskService>();

  List<Task> tasks = await taskService.getTasks(household.tasks);

  for (Task t in tasks) {
    if (t.repeat != null) {
      if (t.repeat != 0) {
        t.deadline = t.deadline?.add(Duration(days: t.repeat!));
      } else {
        t.deadline = t.deadline?.add(Duration(minutes: 5));
      }

      if (t.rotating) {
        DocumentReference? currentAssignee = t.assignee;
        int index = household.inhabitants.indexOf(currentAssignee!);
        t.assignee =
            household.inhabitants[(index + 1) % household.inhabitants.length];
      }

      taskService.updateTask(t);
    }
  }
}
