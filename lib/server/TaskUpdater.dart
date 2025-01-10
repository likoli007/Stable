import 'package:get_it/get_it.dart';
import 'package:stable/service/task_service.dart';

import '../model/household/household.dart';
import '../model/task/task.dart';
import '../service/household_service.dart';

Future<void> updateHouseholdRotation(Household household) async {
  final taskService = GetIt.instance<TaskService>();

  List<Task> tasks = await taskService.getTasks(household.tasks);

  for (Task t in tasks) {
    if (t.repeat != null) {
      if (t.repeat != 0) {
        t.deadline?.add(Duration(days: t.repeat!));
      } else {
        t.deadline?.add(Duration(minutes: 5));
      }
      taskService.updateTask(t);
    }
  }
}
