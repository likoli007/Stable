import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:stable/service/task_service.dart';

import '../../model/subtask/subtask.dart';
import '../../model/task/task.dart';

class AddTaskPage extends StatefulWidget {
  final Task? task;
  final bool isEditing;

  AddTaskPage({Key? key, this.task, this.isEditing = false}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _taskProvider = GetIt.instance<TaskService>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  bool _isDone = false;

  DateTime _selectedDeadline = DateTime.now();

  List<Subtask> _subtasks = [];

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.task?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _isDone = widget.task?.isDone ?? false;
    _selectedDeadline = widget.task?.deadline ?? DateTime.now();

    _loadSubtasks();
  }

  Future<void> _loadSubtasks() async {
    if (widget.task?.subtasks != null) {
      var newSubtasks = await _taskProvider.getRelevantSubtasks(widget.task!);
      setState(() {
        _subtasks = newSubtasks;
      });
    }
  }

  void _addSubtaskField() {
    setState(() {
      _subtasks.add(new Subtask(id: "", description: "", isDone: false));
    });
  }

  void _updateSubtask(int index, String name) {
    setState(() {
      _subtasks[index].description = name;
    });
  }

  void _toggleSubtaskCompletion(int index) {
    setState(() {
      _subtasks[index].isDone = !_subtasks[index].isDone;
    });
  }

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

  Future<void> _changeTask() async {
    if (widget.task != null) {
      widget.task?.isDone = _isDone;
      widget.task?.subtasks =
          await _taskProvider.setNewSubtasks(widget.task!, _subtasks);
      widget.task?.description = _descriptionController.text;
      widget.task?.name = _nameController.text;
      widget.task?.deadline = _selectedDeadline;
      //TODO: widget.task?.assignees
      //TODO: widget.task?.repeat
      _taskProvider.updateTask(widget.task);
    }
  }

  void _handleActionButton() {
    if (widget.isEditing) {
      _changeTask();
    } else {
      _addTask();
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
          subtasks: _subtasks);

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
            const SizedBox(height: 16),
            const Text('Subtasks:'),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _subtasks.length + 1,
                itemBuilder: (context, index) {
                  if (index == _subtasks.length) {
                    return TextButton(
                      onPressed: _addSubtaskField,
                      child: const Text('Add Subtask'),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) => _updateSubtask(index, value),
                            decoration: InputDecoration(
                              labelText: widget.isEditing
                                  ? _subtasks[index].description
                                  : 'Subtask ${index + 1}',
                            ),
                          ),
                        ),
                        Checkbox(
                          value: _subtasks[index].isDone,
                          onChanged: (value) => _toggleSubtaskCompletion(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _handleActionButton();
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
