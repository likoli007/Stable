import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/service/task_service.dart';

import '../model/household/household.dart';
import '../model/task/task.dart';
import '../service/household_service.dart';

/*
  IDEA: periodically poll all households, for each household check the task expiration date
    if it is in the past, increment it by its repeat period and possibly assign a new assignee
 */
class TaskUpdater {
  final TaskService _taskService = GetIt.instance<TaskService>();
  final HouseholdService _householdService = GetIt.instance<HouseholdService>();

  late final stream;

  TaskUpdater() {
    print("TaskUpdater Instantiated!");
    final householdStream = _householdService.getHouseholdsStream();

    // Poll tasks periodically
    stream = Stream.periodic(Duration(seconds: 30))
        .asyncMap((_) => householdStream.first);

    listenToUpdates();
  }

  void listenToUpdates() {
    stream.listen(_autoUpdate, onError: (error) {
      print('Stream error: $error');
    });
  }

  void _autoUpdate(List<Household> households) {
    print("running update method");
    for (Household household in households) {
      if (household.tasks.isNotEmpty) {
        updateHouseholdRotation(household);
      }
    }
  }

  Future<void> updateHouseholdRotation(Household household) async {
    List<Task> tasks = await _taskService.getTasks(household.tasks);

    for (Task t in tasks) {
      if (t.deadline!.isBefore(DateTime.now())) {
        DocumentReference? failedTaskRef = await _taskService.addTask(
            assignee: t.assignee?.id.toString(),
            name: t.name,
            description: t.description,
            isDone: t.isDone,
            deadline: t.deadline,
            repeat: null,
            subtasks: [],
            rotating: false);

        _householdService.updateHouseholdHistory(
            household.id, failedTaskRef!, t.isDone);

        if (t.repeat != null) {
          if (t.repeat != 0) {
            t.deadline = t.deadline?.add(Duration(days: t.repeat!));
          } else {
            //DEBUG, TODO: REMOVE
            t.deadline = t.deadline?.add(Duration(minutes: 5));
            print(
                "changed " + t.name + " to deadline: " + t.deadline.toString());
          }
          if (t.rotating) {
            DocumentReference? currentAssignee = t.assignee;
            int index = household.inhabitants.indexOf(currentAssignee!);
            t.assignee = household
                .inhabitants[(index + 1) % household.inhabitants.length];
            print("rotated assignee for " +
                t.name +
                " from " +
                currentAssignee.toString() +
                " to " +
                t.assignee.toString());
          }
          _taskService.updateTask(t);
        } else {
          _taskService.removeTask(t.id);
        }
      }
    }
  }
}
