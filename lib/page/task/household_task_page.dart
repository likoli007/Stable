import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/common/util/shared_ui_constants.dart';
import 'package:stable/common/widget/loading_stream_builder.dart';
import 'package:stable/common/widget/page_template.dart';
import 'package:stable/model/task/task.dart';
import 'package:stable/service/task_service.dart';

import 'package:stable/page/task/add_task_page.dart';

import 'package:stable/model/subtask/subtask.dart';

import '../../model/household/household.dart';
import '../../service/household_service.dart';

class HouseholdTaskPage extends StatelessWidget {
  HouseholdTaskPage({Key? key, required this.householdReference})
      : super(key: key);

  String householdReference;

  final _taskProvider = GetIt.instance<TaskService>();
  final _householdProvider = GetIt.instance<HouseholdService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        title: 'Tasks',
        floatingActionButton: _buildHouseholdTaskPageFloatingButton(context),
        child: _buildHouseholdStream());
  }

  FloatingActionButton _buildHouseholdTaskPageFloatingButton(
      BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddTaskPage(
              householdRef: householdReference,
            ),
          ),
        );
      },
      tooltip: 'Add',
      child: const Icon(Icons.add),
    );
  }

  Widget _buildHouseholdStream() {
    return LoadingStreamBuilder<Household?>(
      stream: _householdProvider.getHouseholdStream(householdReference),
      builder: _buildTaskStream,
    );
  }

  Widget _buildTaskStream(BuildContext context, Household? data) {
    return LoadingStreamBuilder<List<Task>>(
      stream: _taskProvider.getTasksStreamByRefs(data!.tasks),
      builder: _buildTaskView,
    );
  }

  Widget _buildTaskView(BuildContext context, List<Task> data) {
    final tasks = data;
    return ListView.builder(
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
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => editTask(context, task),
            ),
            LoadingStreamBuilder<List<Subtask>>(
                stream: _taskProvider.getTaskSubTasksStream(task),
                builder: subTaskViewBuilder),
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
                // Update subtask's isDone state in Firestore
                setSubtaskDone(subtask);
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

  void editTask(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskPage(
            householdRef: householdReference, task: task, isEditing: true),
      ),
    );
  }

  setDone(Task t) {
    _taskProvider.setIsDoneTask(t);
  }

  setSubtaskDone(Subtask s) {
    _taskProvider.setIsDoneSubtask(s);
  }
}
