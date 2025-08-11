import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<Task> createTask(String title, String? description);
  Future<Task> updateTask(int id, Map<String, dynamic> changes);
  Future<void> deleteTask(int id);
}
