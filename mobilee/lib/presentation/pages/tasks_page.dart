import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/task_model.dart';
import '../providers/tasks_notifier.dart';
import '../widgets/task_tile.dart';
import '../../data/datasources/api_service.dart';
import 'login_page.dart';
import'../providers/api_provider.dart';

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
    if (!mounted) return;
    titleCtr.clear();
    descCtr.clear();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF16213E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
        side: BorderSide(color: Color(0xFF00FF00), width: 2),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Nueva Tarea',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: const Color(0xFF00D4FF)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleCtr,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Título',
                labelStyle: TextStyle(color: Color(0xFF00FF00)),
                border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF00FF00))),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtr,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                labelStyle: TextStyle(color: Color(0xFF00FF00)),
                border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF00FF00))),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final title = titleCtr.text.trim();
                final desc = descCtr.text.trim();
                if (title.isEmpty) return;

                try {
                  await ref.read(tasksNotifierProvider.notifier).addTask(title, desc.isEmpty ? null : desc);
                  if (mounted) Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e', style: const TextStyle(color: Colors.white)), backgroundColor: Color(0xFF16213E)),
                  );
                }
              },
              child: const Text('Crear Tarea'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDialog(TaskModel task) async {
    if (!mounted) return;
    titleCtr.text = task.title;
    descCtr.text = task.description ?? '';
    bool newCompleted = task.completed;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF16213E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
        side: BorderSide(color: Color(0xFF00FF00), width: 2),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Editar Tarea',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: const Color(0xFF00D4FF)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleCtr,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(color: Color(0xFF00FF00)),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF00FF00))),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtr,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  labelStyle: TextStyle(color: Color(0xFF00FF00)),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF00FF00))),
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Completada', style: TextStyle(color: Colors.white)),
                value: newCompleted,
                onChanged: (value) => setState(() => newCompleted = value),
                activeColor: const Color(0xFF00D4FF),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final newTitle = titleCtr.text.trim();
                  final newDesc = descCtr.text.trim().isEmpty ? null : descCtr.text.trim();
                  if (newTitle.isEmpty) return;

                  try {
                    await ref.read(tasksNotifierProvider.notifier).editTask(task, newTitle, newDesc, newCompleted);
                    if (mounted) Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e', style: const TextStyle(color: Colors.white)), backgroundColor: Color(0xFF16213E)),
                    );
                  }
                },
                child: const Text('Guardar Cambios'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    final tokenStorage = ref.read(tokenStorageProvider);
    final api = ref.read(apiServiceProvider);
    await tokenStorage.deleteToken();
    api.clearToken();
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    final tasksState = ref.watch(tasksNotifierProvider);

    if (tasksState.hasError && tasksState.error is AuthException) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _logout();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Misión: Tareas', style: TextStyle(color: Color(0xFF00D4FF), fontSize: 24)),
        backgroundColor: const Color(0xFF16213E),
        elevation: 10,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF00FF00)),
            onPressed: () => ref.read(tasksNotifierProvider.notifier).fetchTasks(),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFFF00FF)),
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: const Color(0xFFFF00FF), // Púrpura neón
        child: const Icon(Icons.add, color: Colors.black),
        elevation: 10,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: tasksState.when(
          loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF00D4FF))),
          error: (e, st) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: $e', style: const TextStyle(color: Color(0xFFFF4500))),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ref.read(tasksNotifierProvider.notifier).fetchTasks(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          ),
          data: (tasks) {
            if (tasks.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Sin misiones activas', style: TextStyle(color: Color(0xFF00FF00))),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(8.0),
              itemCount: tasks.length,
              separatorBuilder: (_, __) => const Divider(height: 1, thickness: 1, color: Color(0xFF00FF00)),
              itemBuilder: (_, i) {
                final task = tasks[i];
                return TaskTile(
                  task: task,
                  onToggle: (task) async {
                    try {
                      await ref.read(tasksNotifierProvider.notifier).toggleComplete(task);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No se pudo actualizar: $e', style: const TextStyle(color: Colors.white)), backgroundColor: Color(0xFF16213E)),
                      );
                    }
                  },
                  onDelete: (id) async {
                    try {
                      await ref.read(tasksNotifierProvider.notifier).deleteTask(id);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No se pudo borrar: $e', style: const TextStyle(color: Colors.white)), backgroundColor: Color(0xFF16213E)),
                      );
                    }
                  },
                  onEdit: (task) async {
                    try {
                      await _showEditDialog(task);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al editar: $e', style: const TextStyle(color: Colors.white)), backgroundColor: Color(0xFF16213E)),
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}