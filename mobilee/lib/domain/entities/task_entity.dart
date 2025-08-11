class Task {
  final int id;
  final String title;
  final String? description;
  final bool completed;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.completed,
  });
}
