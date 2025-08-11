class TaskModel {
  final String id;
  final String title;
  final String? description;
  final bool completed;
  final String? ownerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.completed,
    this.ownerId,
    this.createdAt,
    this.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      completed: json['completed'] as bool? ?? false,
      ownerId: json['ownerId'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'completed': completed,
        'ownerId': ownerId,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}