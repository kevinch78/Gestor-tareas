import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/task_model.dart';
import '../../data/datasources/api_service.dart';
import '../providers/api_provider.dart';

final tasksNotifierProvider = StateNotifierProvider<TasksNotifier, AsyncValue<List<TaskModel>>>((ref) {
  final api = ref.watch(apiServiceProvider);
  return TasksNotifier(api, ref);
});

class TasksNotifier extends StateNotifier<AsyncValue<List<TaskModel>>> {
  final ApiService api;
  final Ref ref;

  TasksNotifier(this.api, this.ref) : super(const AsyncValue.loading()) {
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      state = const AsyncValue.loading();
      final tasks = await api.getTasks();
      print("Tasks fetched: ${tasks.map((t) => t.title).toList()}");
      state = AsyncValue.data(tasks);
    } catch (e, st) {
      print("Fetch tasks error: $e");
      if (e is AuthException) {
        final tokenStorage = ref.read(tokenStorageProvider);
        final api = ref.read(apiServiceProvider);
        await tokenStorage.deleteToken();
        api.clearToken();
        state = AsyncValue.error('Sesión expirada. Redirigiendo al login.', st);
      } else {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<void> addTask(String title, String? description) async {
    try {
      final newTask = await api.createTask(title, description);
      state = state.whenData((tasks) => [newTask, ...tasks]);
      await fetchTasks();
    } catch (e) {
      if (e is AuthException) {
        final tokenStorage = ref.read(tokenStorageProvider);
        final api = ref.read(apiServiceProvider);
        await tokenStorage.deleteToken();
        api.clearToken();
      }
      rethrow;
    }
  }

  Future<void> toggleComplete(TaskModel task) async {
    try {
      final updated = await api.updateTask(task.id, {'completed': !task.completed});
      state = state.whenData((list) => list.map((t) => t.id == updated.id ? updated : t).toList());
    } catch (e) {
      if (e is AuthException) {
        final tokenStorage = ref.read(tokenStorageProvider);
        final api = ref.read(apiServiceProvider);
        await tokenStorage.deleteToken();
        api.clearToken();
      }
      rethrow;
    }
  }

  Future<void> editTask(TaskModel task, String newTitle, String? newDescription, bool newCompleted) async {
    try {
      final updatedTask = await api.updateTask(task.id, {
        'title': newTitle,
        'description': newDescription,
        'completed': newCompleted,
      });
      state = state.whenData((list) => list.map((t) => t.id == updatedTask.id ? updatedTask : t).toList());
    } catch (e) {
      if (e is AuthException) {
        final tokenStorage = ref.read(tokenStorageProvider);
        final api = ref.read(apiServiceProvider);
        await tokenStorage.deleteToken();
        api.clearToken();
      }
      rethrow;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await api.deleteTask(id);
      state = state.whenData((list) => list.where((t) => t.id != id).toList());
    } catch (e) {
      if (e is AuthException) {
        final tokenStorage = ref.read(tokenStorageProvider);
        final api = ref.read(apiServiceProvider);
        await tokenStorage.deleteToken();
        api.clearToken();
      }
      rethrow;
    }
  }
}