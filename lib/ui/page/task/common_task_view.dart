import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/ui/common/util/shared_ui_constants.dart';
import 'package:stable/ui/common/widget/big_icon_page.dart';
import 'package:stable/ui/common/widget/builder/loading_stream_builder.dart';
import 'package:stable/ui/common/widget/full_width_button.dart';
import 'package:stable/ui/common/widget/user_profile_picture.dart';
import 'package:stable/model/household/household.dart';
import 'package:stable/model/inhabitant/inhabitant.dart';
import 'package:stable/model/subtask/subtask.dart';
import 'package:stable/model/task/task.dart';
import 'package:stable/service/household_service.dart';
import 'package:stable/service/inhabitant_service.dart';
import 'package:stable/service/task_service.dart';
import 'package:stable/ui/page/task/add_task_page.dart';

class CommonTaskView extends StatelessWidget {
  final Household household;
  final bool isUserView;
  final bool isFailedView;

  CommonTaskView(
      {super.key,
      required this.household,
      required this.isUserView,
      required this.isFailedView});

  final _taskProvider = GetIt.instance<TaskService>();
  final _householdProvider = GetIt.instance<HouseholdService>();
  final _inhabitantProvider = GetIt.instance<InhabitantService>();

  @override
  Widget build(BuildContext context) {
    return LoadingStreamBuilder(
      stream: _taskProvider.getTasksStreamByRefs(
        isFailedView ? household.failedTaskHistory : household.tasks,
      ),
      builder: _buildTaskView,
    );
  }

  Widget _buildTaskView(BuildContext context, List<Task> data) {
    final List<Task> tasks = isUserView
        ? data
            .where((task) =>
                task.assignee!.id == FirebaseAuth.instance.currentUser!.uid)
            .toList()
        : data;

    if (tasks.isEmpty && !isUserView) {
      return BigIconPage(
        icon: const Icon(Icons.sentiment_very_satisfied, size: BIG_ICON_SIZE),
        title: 'No tasks. Hooray!',
        text: isFailedView
            ? "No failed tasks? That's great! Keep it up!"
            : "Don't be afraid, it does not mean you are out of work. "
                'It means no one has assigned you any tasks yet. However you can outrun '
                'your friends and create some tasks for them before they do!',
        buttons: [
          FullWidthButton(
            label: "Add task",
            icon: const Icon(Icons.add_task),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskPage(
                  householdRef: household.id,
                ),
              ),
            ),
          )
        ],
      );
    } else if (tasks.isEmpty) {
      return Center(
        child: Text("No Tasks for you from this household!"),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 2.0),
          title: Text(task.name),
          subtitle: Text(task.description),
          trailing: _buildTaskTrailingButton(task),
          onTap: () => !isFailedView ? _editTask(context, task) : (),
          leading: isUserView
              ? null
              : SizedBox(
                  height: 50,
                  width: 50,
                  child: _buildAssigneeInformation(task),
                ),
        );
      },
    );
  }

  Widget _buildTaskTrailingButton(Task task) {
    if (isFailedView) {
      return IconButton(
          onPressed: () => _removeTaskFromHistory(task),
          icon: const Icon(Icons.delete_forever));
    }
    return IconButton(
      icon: Icon(task.isDone ? Icons.check_circle : Icons.circle),
      onPressed: () => _setDone(task),
    );
  }

  void _removeTaskFromHistory(Task t) {
    _householdProvider.removeTaskFromHistory(household.id, t.id);
    _taskProvider.removeTask(t.id);
  }

  Widget _buildAssigneeInformation(Task task) {
    return LoadingStreamBuilder(
        stream: _inhabitantProvider
            .getInhabitantStream(task.assignee!.id.toString()),
        builder: _buildAssigneePicture);
  }

  Widget _buildAssigneePicture(BuildContext context, Inhabitant? inhabitant) {
    return UserProfilePicture(user: inhabitant!.id);
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

  void _setDone(Task t) {
    _taskProvider.setIsDoneTask(t);
  }
}
