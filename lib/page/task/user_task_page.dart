import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/service/household_service.dart';
import 'package:stable/service/inhabitant_service.dart';

import '../../common/widget/loading_future_builder.dart';
import '../../common/widget/loading_stream_builder.dart';
import '../../common/widget/page_template.dart';
import '../../model/household/household.dart';
import '../../model/inhabitant/inhabitant.dart';
import '../../model/subtask/subtask.dart';
import '../../model/task/task.dart';
import '../../service/task_service.dart';

class UserTaskPage extends StatelessWidget {
  UserTaskPage({Key? key}) : super(key: key);

  final _taskProvider = GetIt.instance<TaskService>();
  final _householdProvider = GetIt.instance<HouseholdService>();
  final _userProvider = GetIt.instance<UserService>();
  //final Inhabitant userInhabitant;

  @override
  Widget build(BuildContext context) {
    return PageTemplate(title: 'Tasks', child: buildUserFuture());
  }

  Widget buildUserFuture() {
    return LoadingFutureBuilder(
        future:
            _userProvider.getInhabitant(FirebaseAuth.instance.currentUser!.uid),
        builder: buildHouseholdsFuture);
  }

  Widget buildHouseholdsFuture(BuildContext context, Inhabitant? user) {
    return LoadingFutureBuilder(
        future: _householdProvider.getUserHouseholds(user!),
        builder: buildTaskStream);
  }

  Widget buildTaskStream(BuildContext context, List<Household?> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final household = data[index];
        return ExpansionTile(
          title: Text(household!.name),
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: LoadingStreamBuilder(
                stream: _taskProvider.getTasksStreamByRefs(household.tasks),
                builder: taskViewBuilder,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget subTaskViewBuilder(BuildContext context, List<Subtask> data) {
    final subtasks = data;

    if (subtasks.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: subtasks.length,
        itemBuilder: (context, subIndex) {
          final subtask = subtasks[subIndex];
          return ListTile(
            title: Text(subtask.description),
            trailing: Checkbox(
              value: subtask.isDone,
              onChanged: (value) {
                setSubtaskDone(subtask);
              },
            ),
          );
        },
      );
    }

    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text('No subtasks'),
    );
  }

  Widget taskViewBuilder(BuildContext context, List<Task> data) {
    final tasks = data;
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ExpansionTile(
          title: Text(task.name),
          subtitle: Text(task.description),
          trailing: IconButton(
            icon: Icon(task.isDone ? Icons.check_circle : Icons.circle),
            onPressed: () => setDone(task),
          ),
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: LoadingStreamBuilder<List<Subtask>>(
                stream: _taskProvider.getTaskSubTasksStream(task),
                builder: subTaskViewBuilder,
              ),
            ),
          ],
        );
      },
    );
  }

  setDone(Task t) {
    _taskProvider.setIsDoneTask(t);
  }

  setSubtaskDone(Subtask s) {
    _taskProvider.setIsDoneSubtask(s);
  }
}
