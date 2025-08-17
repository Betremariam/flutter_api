class Task {
  final String id;
  final String title;
  bool completed;

  Task({required this.id, required this.title, this.completed = false});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      title: json['title'],
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'completed': completed};
  }
}
