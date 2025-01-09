import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:stable/page/task/task_assignee_pick_page.dart';
import 'package:stable/service/household_service.dart';

import 'package:stable/service/task_service.dart';

import '../../model/household/household.dart';
import '../../model/inhabitant/inhabitant.dart';
import '../../model/subtask/subtask.dart';
import '../../model/task/task.dart';

class AddTaskPage extends StatefulWidget {
  final Task? task;
  final String householdRef;
  final bool isEditing;

  AddTaskPage(
      {Key? key, required this.householdRef, this.task, this.isEditing = false})
      : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _taskProvider = GetIt.instance<TaskService>();
  final _householdProvider = GetIt.instance<HouseholdService>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  late bool _isDone;
  DateTime? _selectedDeadline = null;
  List<Subtask> _subtasks = [];
  Inhabitant? _assignee;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.task?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _isDone = widget.task?.isDone ?? false;
    _selectedDeadline = widget.task?.deadline;

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
      _subtasks.add(new Subtask(
          id: "", description: "", isDone: false, taskReference: null));
    });
  }

  void _updateSubtask(int index, String name) {
    setState(() {
      _subtasks[index].description = name;
    });
  }

  void _toggleTaskCompletion(bool? value) {
    setState(() {
      _isDone = value ?? false;
      //if the user unchecked isDone, set all isDones for all subtasks to false
      //also vice versa
      for (Subtask subtask in _subtasks) subtask.isDone = _isDone;
    });
  }

  void _percolateIsDone() {
    bool percolate = true;
    for (Subtask subtask in _subtasks) {
      if (!subtask.isDone) {
        percolate = false;
        break;
      }
    }
    setState(() {
      print(percolate);
      _isDone = percolate;
    });
  }

  void _toggleSubtaskCompletion(int index) {
    setState(() {
      _subtasks[index].isDone = !_subtasks[index].isDone;
      _percolateIsDone();
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
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime finalDeadline = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _selectedDeadline = finalDeadline;
        });
      }
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

  Future<void> _addTask() async {
    final name = _nameController.text;
    final description = _descriptionController.text;

    //TODO: actual validation, but here or in service?
    if (name.isNotEmpty && description.isNotEmpty && true) {
      DocumentReference? taskRef = await _taskProvider.addTask(
          assignee: _assignee?.id,
          name: name,
          description: description,
          isDone: _isDone,
          deadline: _selectedDeadline,
          repeat: null,
          subtasks: _subtasks);

      if (taskRef != null) {
        _householdProvider.addTaskToHousehold(widget.householdRef, taskRef);
      }

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
            _buildTaskNameInput(),
            const SizedBox(height: 16),
            _buildTaskDescriptionInput(),
            const SizedBox(height: 16),
            _buildDoneCheckbox(),
            const SizedBox(height: 16),
            _buildDeadlinePicker(),
            const SizedBox(height: 16),
            _buildAssigneeSelectionWidget(),
            const SizedBox(height: 16),
            const Text('Subtasks:'),
            const SizedBox(height: 8),
            _buildSubtaskAddingWidget(),
            _buildTaskAddingButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskAddingButton() {
    return ElevatedButton(
      onPressed: () {
        _handleActionButton();
      },
      child: const Text('Add Task'),
    );
  }

  Widget _buildSubtaskAddingWidget() {
    return Expanded(
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
          return _buildSubtaskInputWidget(index);
        },
      ),
    );
  }

  void _deleteSubtask(int index) {
    setState(() {
      _subtasks.removeAt(index);
    });
  }

  Widget _buildSubtaskInputWidget(int index) {
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
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => _deleteSubtask(index),
            tooltip: 'Delete subtask',
          ),
        ],
      ),
    );
  }

  Widget _buildDoneCheckbox() {
    return Row(
      children: [
        const Text('Is Done:'),
        const SizedBox(width: 8),
        Checkbox(
          value: _isDone,
          onChanged: (value) {
            _toggleTaskCompletion(value);
          },
        ),
      ],
    );
  }

  Widget _buildTaskDescriptionInput() {
    return TextField(
      controller: _descriptionController,
      decoration: const InputDecoration(labelText: 'Description'),
    );
  }

  Widget _buildTaskNameInput() {
    return TextField(
      controller: _nameController,
      decoration: const InputDecoration(labelText: 'Task Name'),
    );
  }

  Widget _buildDeadlinePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _selectedDeadline == null
              ? 'No Deadline Chosen'
              : 'Deadline: ${DateFormat('yyyy-MM-dd – kk:mm').format(_selectedDeadline!)}',
        ),
        TextButton(
          onPressed: _pickDeadline,
          child: const Text('Pick Deadline'),
        ),
      ],
    );
  }

  Widget _buildAssigneeSelectionWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _assignee == null ? 'No assignee' : _assignee!.name,
        ),
        TextButton(
          onPressed: () => _selectAssignee(context),
          child: Text('Select Assignee'),
        ),
      ],
    );
  }

  Future<void> _selectAssignee(BuildContext context) async {
    List<DocumentReference> inhabitants =
        await _householdProvider.getHouseholdInhabitants(widget.householdRef);

    final Inhabitant? selectedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskAssigneePickPage(
          users: inhabitants,
        ),
      ),
    );

    if (selectedUser != null) {
      setState(() {
        _assignee = selectedUser;
      });
    }
  }
}
