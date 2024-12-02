import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stable/database/service/database_service.dart';
import 'package:stable/model/task/task.dart';

import '../model/subtask/subtask.dart';

class TaskService {
  final DatabaseService<Task> _taskRepository;
  final DatabaseService<Subtask> _subTaskRepository;

  const TaskService(this._taskRepository, this._subTaskRepository);

  Future<List<Task>> getTasks() {
    final taskStream = _taskRepository.getAllDocuments();
    return taskStream;
  }

  Future<void>? setIsDoneTask(Task t) {
    t.isDone = !t.isDone;
    Map<String, dynamic> doneField = {"isDone": t.isDone};
    _taskRepository.updateDocument(t.id, doneField);
    return null;
  }

  Future<void>? setIsDoneSubtask(Subtask s) {
    s.isDone = !s.isDone;
    Map<String, dynamic> doneField = {"isDone": s.isDone};
    _subTaskRepository.updateDocument(s.id, doneField);
    return null;
  }

  Future<DocumentReference?> addSubTask({
    required String description,
    required bool isDone,
  }) async {
    Subtask subtask =
        Subtask(id: "template", description: description, isDone: isDone);

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
    List<Subtask> subtaskList =
        await _subTaskRepository.getDocumentsByIds(subtaskRefs);

    return subtaskList;
  }

  Future<String?> addTask(
      {required List<DocumentReference>? assignees,
      required String? name,
      required String? description,
      required bool? isDone,
      required DateTime? deadline,
      required DocumentReference? repeat,
      required List<Subtask>? subtasks}) async {
    //TODO validation checks and document reference handling
    DocumentReference defaultReference =
        FirebaseFirestore.instance.doc('users/defaultReference');

    if (name == null ||
        description == null ||
        deadline == null ||
        isDone == null) {
      return "Problem with assigning!";
    }

    List<DocumentReference> defaultReferenceList = [defaultReference];

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

    Task newTask = Task(
        id: "discard",
        assignees: defaultReferenceList,
        name: name,
        description: description,
        deadline: deadline,
        isDone: isDone,
        repeat: defaultReference,
        subtasks: subtaskReferences);

    DocumentReference newId = await _taskRepository.add(newTask);
    newTask.id = newId.toString();
    return null;
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
}
