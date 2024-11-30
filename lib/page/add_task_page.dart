import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../model/task/task.dart';
import '../service/task_service.dart';

class AddTaskPage extends StatefulWidget {
  AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _taskProvider = GetIt.instance<TaskService>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isDone = false;

  DateTime _selectedDeadline = DateTime.now();

  // function for helping user pick their own deadline date
  // TODO: move to its own spot?
  Future<void> _pickDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDeadline = pickedDate;
      });
    }
  }

  void _addTask() {
    final name = _nameController.text;
    final description = _descriptionController.text;

    //TODO: actual validation, but here or in service?
    if (name.isNotEmpty && description.isNotEmpty && true) {
      _taskProvider.addTask(
          assignees: null,
          name: name,
          description: description,
          isDone: _isDone,
          deadline: _selectedDeadline,
          repeat: null,
          subtasks: null);

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Is Done:'),
                const SizedBox(width: 8),
                Checkbox(
                  value: _isDone,
                  onChanged: (value) {
                    setState(() {
                      _isDone = value ?? false;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            //deadline picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDeadline == null
                      ? 'No Deadline Chosen'
                      : 'Deadline: ${_selectedDeadline!.toLocal()}'
                          .split(' ')[0],
                ),
                TextButton(
                  onPressed: _pickDeadline,
                  child: const Text('Pick Deadline'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _addTask();
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
