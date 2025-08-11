import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/task_model.dart';
import '../providers/tasks_notifier.dart';
import '../providers/api_provider.dart';
import '../widgets/task_tile.dart';
import '../../core/token_storage.dart';
import '../../data/datasources/api_service.dart';

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  final titleCtr = TextEditingController();
  final descCtr = TextEditingController();

  @override
  void dispose() {
    titleCtr.dispose();
    descCtr.dispose();
    super.dispose();
  }

  Future<void> _showAddDialog() async {
    titleCtr.clear();
    descCtr.clear();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: titleCtr, decoration: const InputDecoration(labelText: 'Título')),
          TextField(controller: descCtr, decoration: const InputDecoration(labelText: 'Descripción (opcional)')),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              final title = titleCtr.text.trim();
              final desc = descCtr.text.trim();
              if (title.isEmpty) return;
              try {
                await ref.read(tasksNotifierProvider.notifier).addTask(title, desc.isEmpty ? null : desc);
                if (mounted) Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
              }
            },
            child: const Text('Crear tarea'),
          ),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  Future<void> _logout() async {
    final tokenStorage = ref.read(tokenStorageProvider);
    final api = ref.read(apiServiceProvider);
    await tokenStorage.deleteToken();
    api.clearToken();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/'); // volver al login (ver main)
  }

  @override
  Widget build(BuildContext context) {
    final tasksState = ref.watch(tasksNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
        actions: [
          IconButton(onPressed: () => ref.read(tasksNotifierProvider.notifier).fetchTasks(), icon: const Icon(Icons.refresh)),
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: tasksState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Error: ${e.toString()}'),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () => ref.read(tasksNotifierProvider.notifier).fetchTasks(), child: const Text('Reintentar')),
            ]),
          ),
        ),
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(child: Text('Aún no tienes tareas'));
          }
          return ListView.separated(
            itemCount: tasks.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final t = tasks[i];
              return TaskTile(
                task: t,
                onToggle: (task) async {
                  try {
                    await ref.read(tasksNotifierProvider.notifier).toggleComplete(task);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No se pudo actualizar: $e')));
                  }
                },
                onDelete: (id) async {
                  try {
                    await ref.read(tasksNotifierProvider.notifier).deleteTask(id);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No se pudo borrar: $e')));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
