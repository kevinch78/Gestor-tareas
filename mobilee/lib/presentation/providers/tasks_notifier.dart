import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/task_model.dart';
import '../../data/datasources/api_service.dart';
import '../providers/api_provider.dart';

final tasksNotifierProvider = StateNotifierProvider<TasksNotifier, AsyncValue<List<TaskModel>>>((ref) {
  final api = ref.watch(apiServiceProvider);
  return TasksNotifier(api);
});

class TasksNotifier extends StateNotifier<AsyncValue<List<TaskModel>>> {
  final ApiService api;
  
  TasksNotifier(this.api) : super(const AsyncValue.loading()) {
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      state = const AsyncValue.loading();
      final tasks = await api.getTasks();
      state = AsyncValue.data(tasks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTask(String title, String? description) async {
    try {
      final newTask = await api.createTask(title, description);
      state = state.whenData((list) => [newTask, ...list]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleComplete(TaskModel task) async {
    try {
      final updated = await api.updateTask(task.id, {'completed': !task.completed});
      state = state.whenData((list) => list.map((t) => t.id == updated.id ? updated : t).toList());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await api.deleteTask(id);
      state = state.whenData((list) => list.where((t) => t.id != id).toList());
    } catch (e) {
      rethrow;
    }
  }
}
