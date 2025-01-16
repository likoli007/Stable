import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:stable/model/inhabitant/inhabitant.dart';
import 'package:stable/model/subtask/subtask.dart';
import 'package:stable/model/task/task.dart';
import 'package:stable/service/inhabitant_service.dart';
import 'package:stable/ui/common/page/page_body.dart';
import 'package:stable/ui/common/util/shared_ui_constants.dart';
import 'package:stable/ui/page/task/task_assignee_pick_page.dart';
import 'package:stable/service/household_service.dart';

import 'package:stable/service/task_service.dart';

class AddTaskPage extends StatefulWidget {
  final Task? task;
  final Inhabitant? assignee;
  final String householdRef;
  final bool isEditing;

  const AddTaskPage({
    super.key,
    required this.householdRef,
    this.task,
    this.assignee,
    this.isEditing = false,
  });

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _taskProvider = GetIt.instance<TaskService>();
  final _householdProvider = GetIt.instance<HouseholdService>();
  final _inhabitantProvider = GetIt.instance<InhabitantService>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  late bool _isDone;
  late bool _isRepeat;
  late bool _isRotating;

  DateTime? _selectedDeadline;
  List<Subtask> _subtasks = [];
  Inhabitant? _assignee;
  String _repeatDays = "Daily";

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.task?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _isDone = widget.task?.isDone ?? false;
    _selectedDeadline = widget.task?.deadline;
    _isRepeat = widget.task?.repeat != null ? true : false;
    _isRotating = widget.task?.rotating ?? false;

    if (_isRepeat) {
      _repeatDays = _getRepeatString();
    }

    if (widget.task?.assignee != null) {
      _loadAssignee(widget.task!.assignee!);
    }

    _loadSubtasks();
  }

  Future<void> _loadAssignee(DocumentReference ref) async {
    final Inhabitant? inhabitant = await _getAssigneeInfo(ref);
    setState(() {
      _assignee = inhabitant;
    });
  }

  Future<Inhabitant?> _getAssigneeInfo(DocumentReference? ref) async {
    if (ref == null) return null;

    final Inhabitant? result =
        await _inhabitantProvider.getInhabitant(ref!.id.toString());

    return result;
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

  void _toggleTaskRepetition(bool? value) {
    setState(() {
      _isRepeat = value ?? false;
    });
  }

  void _toggleTaskCompletion(bool? value) {
    setState(() {
      _isDone = value ?? false;
      // If the user unchecked isDone, set all isDone for all subtasks
      // to false or vice versa
      for (Subtask subtask in _subtasks) {
        subtask.isDone = _isDone;
      }
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
    final int? repeatValue = _getTaskRepeat();

    if (widget.task != null) {
      widget.task?.isDone = _isDone;
      widget.task?.subtasks =
          await _taskProvider.setNewSubtasks(widget.task!, _subtasks);
      widget.task?.description = _descriptionController.text;
      widget.task?.name = _nameController.text;
      widget.task?.deadline = _selectedDeadline;
      widget.task?.assignee =
          FirebaseFirestore.instance.doc('User/${_assignee?.id}');
      widget.task?.repeat = _isRepeat ? repeatValue : null;
      widget.task?.rotating = _isRotating;
      _taskProvider.updateTask(widget.task);
    }
    Navigator.pop(context);
  }

  void _handleSaveButton() {
    if (widget.isEditing) {
      _changeTask();
    } else {
      _addTask();
    }
  }

  String _getRepeatString() {
    switch (widget.task!.repeat) {
      case 1:
        return 'Daily';
      case 7:
        return 'Weekly';
      case 30:
        return 'Monthly';
      default:
        return '5 Minutes';
    }
  }

  int? _getTaskRepeat() {
    if (_isRepeat) {
      switch (_repeatDays) {
        case 'Daily':
          return 1;
        case 'Weekly':
          return 7;
        case 'Monthly':
          return 30;
        default:
          return 0;
      }
    }
    return null;
  }

  Future<void> _addTask() async {
    final name = _nameController.text;
    final description = _descriptionController.text;

    final int? repeatValue = _getTaskRepeat();

    if (name.isNotEmpty && _assignee != null && _selectedDeadline != null) {
      final DocumentReference? taskRef = await _taskProvider.addTask(
          assignee: _assignee?.id,
          name: name,
          description: description,
          isDone: _isDone,
          deadline: _selectedDeadline,
          repeat: repeatValue,
          subtasks: _subtasks,
          rotating: _isRotating);

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
    return PageBody(
      title: widget.isEditing ? 'Edit Task' : 'Add Task',
      floatingActionButton: FloatingActionButton(
        onPressed: _handleSaveButton,
        child: const Icon(Icons.save),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTaskNameInput(),
          const SizedBox(height: SMALL_GAP),
          _buildTaskDescriptionInput(),
          const SizedBox(height: SMALL_GAP),
          _buildDeadlinePicker(),
          const SizedBox(height: SMALL_GAP),
          _buildAssigneeSelectionWidget(),
          const SizedBox(height: SMALL_GAP),
          _buildDoneCheckbox(),
          const SizedBox(height: SMALL_GAP),
          _buildRepeatingCheckbox(),
          const SizedBox(height: SMALL_GAP),
          _buildRotatingCheckbox(),
          const SizedBox(height: STANDARD_GAP),
          const Center(child: Text('Subtasks')),
          const SizedBox(height: SMALL_GAP),
          _buildSubtaskAddingWidget(),
          if (widget.isEditing) _buildDeleteButton(),
        ],
      ),
    );
  }

  void _deleteTask() {
    _householdProvider.removeTask(widget.householdRef, widget.task!.id);
    _taskProvider.removeTask(widget.task!.id);
    Navigator.pop(context);
  }

  Widget _buildDeleteButton() {
    return ElevatedButton.icon(
      onPressed: () => _deleteTask(),
      icon: const Icon(Icons.delete),
      label: const Text('Delete task'),
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
            icon: const Icon(Icons.close),
            onPressed: () => _deleteSubtask(index),
            tooltip: 'Delete subtask',
          ),
        ],
      ),
    );
  }

  Widget _buildRotatingCheckbox() {
    return Row(
      children: [
        const Text("Set as rotating"),
        const Spacer(),
        Checkbox(
          value: _isRotating,
          onChanged: (value) {
            _toggleTaskRotation(value);
          },
        ),
      ],
    );
  }

  void _toggleTaskRotation(bool? value) {
    setState(() {
      _isRotating = value ?? false;
    });
  }

  Widget _buildRepeatingCheckbox() {
    return Row(
      children: [
        const Text("Set as repeating"),
        const Spacer(),
        _buildRepeatingTaskSelection(),
        Checkbox(
          value: _isRepeat,
          onChanged: (value) {
            _toggleTaskRepetition(value);
          },
        ),
      ],
    );
  }

  Widget _buildRepeatingTaskSelection() {
    if (_isRepeat) {
      return DropdownButton<String>(
        value: _repeatDays,
        items: ['Daily', 'Weekly', 'Monthly']
            .map((frequency) => DropdownMenuItem<String>(
                  value: frequency,
                  child: Text(frequency),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _repeatDays = value!;
          });
        },
        hint: const Text('Select Frequency'),
      );
    }
    return const SizedBox();
  }

  Widget _buildDoneCheckbox() {
    return Row(
      children: [
        const Text("Set as completed"),
        const Spacer(),
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
      decoration: const InputDecoration(labelText: 'Task Name *'),
    );
  }

  Widget _buildDeadlinePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _selectedDeadline == null
              ? 'Deadline *'
              : 'Deadline: ${DateFormat('yyyy-MM-dd – kk:mm').format(_selectedDeadline!)}',
        ),
        TextButton(
          onPressed: _pickDeadline,
          child: Text(
              _selectedDeadline == null ? 'Pick Deadline' : 'Change Deadline'),
        ),
      ],
    );
  }

  Widget _buildAssigneeSelectionWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _assignee == null ? 'No assignee' : "Assignee: ${_assignee!.name}",
        ),
        TextButton(
          onPressed: () => _selectAssignee(context),
          child:
              Text(_assignee == null ? 'Select Assignee' : "Change Assignee"),
        ),
      ],
    );
  }

  Future<void> _selectAssignee(BuildContext context) async {
    final List<DocumentReference> inhabitants =
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
