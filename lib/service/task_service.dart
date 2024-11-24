import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stable/database/service/database_service.dart';
import 'package:stable/model/Task.dart';

class TaskService {
  final DatabaseService<Task> _taskRepository;

  const TaskService(this._taskRepository);

  Future<List<Task>> getTasks() {
    final taskStream = _taskRepository.getAllDocuments();
    return taskStream;
  }

  Future<String?> addTask(
      {required List<DocumentReference>? assignees,
      required String? name,
      required String? description,
      required bool? isDone,
      required DateTime? deadline,
      required DocumentReference? repeat,
      required List<DocumentReference>? subtasks}) async {
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
    Task newTask = Task(
        assignees: defaultReferenceList,
        name: name,
        description: description,
        deadline: deadline,
        isDone: isDone,
        repeat: defaultReference,
        subtasks: defaultReferenceList);

    await _taskRepository.add(newTask);
    return null;
  }

  Stream<List<Task>> getTasksStream() {
    final projectsStream = _taskRepository.observeDocuments();

    return projectsStream;
  }
}
