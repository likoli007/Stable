import 'package:stable/database/service/database_service.dart';
import 'package:stable/model/Task.dart';

class TaskService {
  final DatabaseService<Task> _taskRepository;

  const TaskService(this._taskRepository);

  Future<List<Task>> getTasks() {
    final taskStream = _taskRepository.getAllDocuments();
    return taskStream;
  }
}
