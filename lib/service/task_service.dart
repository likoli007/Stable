import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stable/database/service/database_service.dart';
import 'package:stable/model/task/task.dart';

import '../model/subtask/subtask.dart';

class TaskService {
  final DatabaseService<Task> _taskRepository;
  final DatabaseService<Subtask> _subTaskRepository;

  const TaskService(this._taskRepository, this._subTaskRepository);

  Future<void> removeTask(String taskId) async {
    Task? t = await _taskRepository.getDocument(taskId);
    Task task = t!;
    for (int i = 0; i < task.subtasks!.length; i++) {
      DocumentReference? r = task.subtasks?[i];
      _subTaskRepository.deleteDocument(r!.id.toString());
    }
    _taskRepository.deleteDocument(taskId);
  }

  Future<List<Task>> getTasks(List<DocumentReference>? refs) {
    final taskStream = _taskRepository.getDocumentsByIds(refs);
    return taskStream;
  }

  Future<void>? setIsDoneTask(Task t) async {
    t.isDone = !t.isDone;
    Map<String, dynamic> doneField = {"isDone": t.isDone};
    _taskRepository.updateDocument(t.id, doneField);

    //TODO update all isDones for the whole Tasks
    if (t.subtasks != null && t.subtasks!.isNotEmpty) {
      List<Subtask> subtasks =
          await _subTaskRepository.getDocumentsByIds(t.subtasks);
      for (Subtask s in subtasks) {
        s.isDone = t.isDone;
        _subTaskRepository.updateEntity(s.id, s);
      }
    }
    return;
  }

  Future<void> _percolateIsDone(Subtask s) async {
    String? ref = s.taskReference?.id.toString();
    Task? t = await _taskRepository.getDocument(ref!);
    if (t == null) return;
    if (!s.isDone && t.isDone) {
      t.isDone = s.isDone;
      _taskRepository.updateEntity(t.id, t);
      return;
    }

    List<Subtask> subtaskList =
        await _subTaskRepository.getDocumentsByIds(t.subtasks);
    bool percolate = true;
    for (Subtask subtask in subtaskList) {
      if (!subtask.isDone) {
        percolate = false;
        break;
      }
    }
    if (percolate) {
      t.isDone = true;
      _taskRepository.updateEntity(t.id, t);
    }
  }

  Future<void>? setIsDoneSubtask(Subtask s) {
    s.isDone = !s.isDone;
    Map<String, dynamic> doneField = {"isDone": s.isDone};
    _subTaskRepository.updateDocument(s.id, doneField);

    _percolateIsDone(s);

    return null;
  }

  Future<DocumentReference?> addSubTask({
    required String description,
    required bool isDone,
  }) async {
    Subtask subtask = Subtask(
        id: "template",
        description: description,
        isDone: isDone,
        taskReference: null);

    DocumentReference newSubTaskReference =
        await _subTaskRepository.add(subtask);

    return newSubTaskReference;
  }

  Stream<List<Subtask>> getTaskSubTasksStream(Task t) {
    return _subTaskRepository.observeDocumentsByIds(t.subtasks);
  }

  Future<void> updateTask(Task? t) async {
    if (t != null) {
      _taskRepository.updateEntity(t.id, t);
    }
  }

  Future<List<Subtask>> getRelevantSubtasks(Task t) async {
    List<DocumentReference> subtaskRefs = t.subtasks ?? [];

    List<Subtask> subtaskList = [];

    if (subtaskRefs.isNotEmpty) {
      subtaskList = await _subTaskRepository.getDocumentsByIds(subtaskRefs);
    }
    return subtaskList;
  }

  Future<void> assignTaskReference(
      List<DocumentReference>? subtaskRefs, DocumentReference taskRef) async {
    if (subtaskRefs!.isEmpty) {
      return;
    }

    List<Subtask> subtasks =
        await _subTaskRepository.getDocumentsByIds(subtaskRefs);

    for (Subtask s in subtasks) {
      s.taskReference = taskRef;
      _subTaskRepository.updateEntity(s.id, s);
    }
  }

  Future<DocumentReference?> addTask(
      {required String? assignee,
      required String? name,
      required String? description,
      required bool? isDone,
      required DateTime? deadline,
      required int? repeat,
      required List<Subtask>? subtasks,
      required bool? rotating}) async {
    //TODO validation checks and document reference handling

    if (name == null ||
        description == null ||
        deadline == null ||
        isDone == null) {
      return null;
    }

    List<DocumentReference> subtaskReferences = [];
    if (subtasks != null) {
      for (int i = 0; i < subtasks.length; i++) {
        bool subIsDone = subtasks[i].isDone;
        String subDescription = subtasks[i].description;
        //TODO: checking of descriptions

        DocumentReference? ref =
            await addSubTask(description: subDescription, isDone: subIsDone);

        if (ref != null) {
          subtaskReferences.add(ref);
        }
      }
    }

    DocumentReference? assigneeRef = assignee == null
        ? null
        : FirebaseFirestore.instance.doc('User/$assignee');

    Task newTask = Task(
        id: "discard",
        assignee: assigneeRef,
        name: name,
        description: description,
        deadline: deadline,
        isDone: isDone,
        repeat: repeat,
        subtasks: subtaskReferences,
        rotating: rotating!);

    DocumentReference newId = await _taskRepository.add(newTask);

    assignTaskReference(newTask.subtasks, newId);

    newTask.id = newId.toString();
    return newId;
  }

  Future<List<DocumentReference<Object?>>> setNewSubtasks(
      Task t, List<Subtask> subtaskList) async {
    List<DocumentReference> result = [];
    for (int i = 0; i < subtaskList.length; i++) {
      DocumentReference ref = await _subTaskRepository.setOrUpdate(
          subtaskList[i], subtaskList[i].id);
      result.add(ref);
    }
    return result;
  }

  Stream<List<Task>> getTasksStream() {
    final projectsStream = _taskRepository.observeDocuments();

    return projectsStream;
  }

  Stream<List<Task>> getTasksStreamByRefs(List<DocumentReference> refs) {
    return _taskRepository.observeDocumentsByIds(refs);
  }
}
