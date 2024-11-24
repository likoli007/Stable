import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/service/task_service.dart';

import '../model/Task.dart';

class TaskView extends StatelessWidget {
  TaskView({Key? key}) : super(key: key);

  final _projectProvider = GetIt.instance<TaskService>();

  final List<Task> movieList = <Task>[];

  @override
  Widget build(BuildContext context) {
    print("building");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: FutureBuilder<List<Task>>(
        future: _projectProvider.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks available'));
          } else {
            final tasks = snapshot.data!;
            print(tasks.length);
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.name),
                  subtitle: Text(task.description),
                  trailing:
                      Icon(task.isDone ? Icons.check_circle : Icons.circle),
                );
              },
            );
          }
        },
      ),
    );
  }
}
