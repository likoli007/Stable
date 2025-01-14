import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/common/widget/loading_future_builder.dart';
import 'package:stable/common/widget/user_profile_picture.dart';
import 'package:stable/service/inhabitant_service.dart';

import '../../common/util/shared_ui_constants.dart';
import '../../common/widget/loading_stream_builder.dart';
import '../../model/household/household.dart';
import '../../model/inhabitant/inhabitant.dart';
import '../../model/subtask/subtask.dart';
import '../../model/task/task.dart';
import '../../service/task_service.dart';
import 'add_task_page.dart';

class CommonTaskView extends StatelessWidget {
  CommonTaskView(
      {Key? key, required this.household, required this.showAssignee})
      : super(key: key);

  final _taskProvider = GetIt.instance<TaskService>();
  final _inhabitantProvider = GetIt.instance<InhabitantService>();
  Household household;

  bool showAssignee;

  @override
  Widget build(BuildContext context) {
    return LoadingStreamBuilder(
      stream: _taskProvider.getTasksStreamByRefs(household.tasks),
      builder: _buildTaskView,
    );
  }

  Widget _buildTaskView(BuildContext context, List<Task> data) {
    final tasks = data;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        //return _buildTaskTile(context, task);
        return ListTile(
          title: Text(task.name),
          subtitle: Text(task.description),
          leading: SizedBox(
            height: 50,
            width: 50,
            child: _buildAssigneeInformation(task),
          ),
          trailing: IconButton(
            icon: Icon(task.isDone ? Icons.check_circle : Icons.circle),
            onPressed: () => _setDone(task),
          ),
          onTap: () => _editTask(context, task),
        );
      },
    );
  }

  Widget _buildAssigneeInformation(Task task) {
    return LoadingStreamBuilder(
        stream: _inhabitantProvider
            .getInhabitantStream(task.assignee!.id.toString()),
        builder: _buildAssigneePicture);
  }

  Widget _buildAssigneePicture(BuildContext context, Inhabitant? inhabitant) {
    return UserProfilePicture(user: inhabitant!);
  }

  Widget _buildSubTaskView(BuildContext context, List<Subtask> data) {
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
                // Update subtask's isDone state in Firestore
                _setSubtaskDone(subtask);
              },
            ),
          );
        },
      );
    }

    return const Padding(
      padding: EdgeInsets.all(SMALL_GAP),
      child: Text('No subtasks'),
    );
  }

  void _editTask(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskPage(
            householdRef: household.id, task: task, isEditing: true),
      ),
    );
  }

  _setDone(Task t) {
    _taskProvider.setIsDoneTask(t);
  }

  _setSubtaskDone(Subtask s) {
    _taskProvider.setIsDoneSubtask(s);
  }
}
