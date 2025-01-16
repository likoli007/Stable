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
  final bool showAssignee;
  final bool isFailedView;

  CommonTaskView(
      {super.key,
      required this.household,
      required this.showAssignee,
      required this.isFailedView});

  final _taskProvider = GetIt.instance<TaskService>();
  final _householdProvider = GetIt.instance<HouseholdService>();
  final _inhabitantProvider = GetIt.instance<InhabitantService>();

  @override
  Widget build(BuildContext context) {
    return LoadingStreamBuilder(
      stream: _taskProvider.getTasksStreamByRefs(
        isFailedView ? household.taskHistory : household.tasks,
      ),
      builder: _buildTaskView,
    );
  }

  Widget _buildTaskView(BuildContext context, List<Task> data) {
    final tasks = data;

    if (tasks.isEmpty) {
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
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];

        return ListTile(
          title: Text(task.name),
          subtitle: Text(task.description),
          trailing: _buildTaskTrailingButton(task),
          onTap: () => !isFailedView ? _editTask(context, task) : (),
          leading: SizedBox(
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

  Widget _buildSubTaskView(BuildContext context, List<Subtask> data) {
    final subtasks = data; // TODO Delete if stays unused

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

  void _setDone(Task t) {
    _taskProvider.setIsDoneTask(t);
  }

  void _setSubtaskDone(Subtask s) {
    _taskProvider.setIsDoneSubtask(s);
  }
}
