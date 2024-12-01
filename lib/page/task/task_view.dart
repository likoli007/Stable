import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/common/widget/loading_stream_builder.dart';
import 'package:stable/common/widget/page_template.dart';
import 'package:stable/model/task/task.dart';
import 'package:stable/service/task_service.dart';

import 'package:stable/page/task/add_task_page.dart';

import '../../model/subtask/subtask.dart';

class TaskView extends StatelessWidget {
  TaskView({Key? key}) : super(key: key);

  final _taskProvider = GetIt.instance<TaskService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Tasks',
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskPage(),
            ),
          );
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
      child: LoadingStreamBuilder<List<Task>>(
          stream: _taskProvider.getTasksStream(), builder: taskViewBuilder),
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
      padding: EdgeInsets.all(8.0),
      child: Text('No subtasks'),
    );
  }

  // Builder function passed to PageTemplate
  Widget taskViewBuilder(BuildContext context, List<Task> data) {
    final tasks = data;
    print(tasks.length);
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
            LoadingStreamBuilder<List<Subtask>>(
                stream: _taskProvider.getTaskSubTasksStream(task),
                builder: subTaskViewBuilder),
          ],
        );
      },
    );
  }

  setDone(Task t) {
    _taskProvider.setDone(t);
  }

  setSubtaskDone(Subtask s) {
    _taskProvider.setDoneSubtask(s);
  }
}
