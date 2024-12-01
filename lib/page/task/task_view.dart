import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/common/widget/loading_stream_builder.dart';
import 'package:stable/common/widget/page_template.dart';
import 'package:stable/model/task/task.dart';
import 'package:stable/service/task_service.dart';

import 'package:stable/page/task/add_task_page.dart';

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

  // Builder function passed to PageTemplate
  Widget taskViewBuilder(BuildContext context, List<Task> data) {
    final tasks = data;
    print(tasks.length);
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.name),
          subtitle: Text(task.description),
          trailing: IconButton(
            icon: Icon(task.isDone ? Icons.check_circle : Icons.circle),
            onPressed: () => setDone(tasks[index]),
          ),
        );
      },
    );
  }

  setDone(Task t) {
    _taskProvider.setDone(t);
  }
}
