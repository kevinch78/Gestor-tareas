import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';

typedef OnToggle = void Function(TaskModel task);
typedef OnDelete = void Function(int id);

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final OnToggle onToggle;
  final OnDelete onDelete;

  const TaskTile({super.key, required this.task, required this.onToggle, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.completed,
        onChanged: (_) => onToggle(task),
      ),
      title: Text(task.title, style: TextStyle(decoration: task.completed ? TextDecoration.lineThrough : null)),
      subtitle: task.description == null || task.description!.isEmpty ? null : Text(task.description!),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => onDelete(task.id),
      ),
    );
  }
}
