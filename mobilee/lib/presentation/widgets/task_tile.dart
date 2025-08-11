import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';

typedef OnToggle = void Function(TaskModel task);
typedef OnDelete = void Function(String id);
typedef OnEdit = void Function(TaskModel task);

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final OnToggle onToggle;
  final OnDelete onDelete;
  final OnEdit onEdit;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF16213E), Color(0xFF1A1A2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFF00FF00), width: 2),
        borderRadius: BorderRadius.zero,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D4FF).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Checkbox(
          value: task.completed,
          onChanged: (_) => onToggle(task),
          activeColor: const Color(0xFF00D4FF),
          checkColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        title: Text(
          task.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: Color(0xFF00FF00), offset: Offset(1, 1), blurRadius: 2),
            ],
          ),
        ),
        subtitle: task.description != null && task.description!.isNotEmpty
            ? Text(task.description!, style: const TextStyle(color: Color(0xFFAAAAAA)))
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFFFF00FF)),
              onPressed: () => onEdit(task),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Color(0xFFFF4500)),
              onPressed: () => onDelete(task.id),
            ),
          ],
        ),
      ),
    );
  }
}