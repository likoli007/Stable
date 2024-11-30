import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/model/task/task.dart';
import 'package:stable/service/task_service.dart';

import 'package:stable/page/task/add_task_page.dart';

class TaskView extends StatelessWidget {
  TaskView({Key? key}) : super(key: key);

  final _taskProvider = GetIt.instance<TaskService>();

  @override
  Widget build(BuildContext context) {
    print("building");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: StreamBuilder<List<Task>>(
        stream: _taskProvider.getTasksStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error!}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // ignore: null_check_on_nullable_type_parameter
          final tasks = snapshot.data!;
          print(tasks.length);
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(task.name),
                subtitle: Text(task.description),
                trailing: Icon(task.isDone ? Icons.check_circle : Icons.circle),
              );
            },
          );
        },
      ),
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
    );
  }
}
