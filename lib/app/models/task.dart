class Task {
  Task(this.title, {this.subtitle = '', this.description = '', this.done = false});

  Task.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'] ?? '';
    description = json['description'] ?? '';
    done = json['done'];
  }

  late final String title;
  late final String subtitle;
  late final String description;
  late bool done;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'done': done,
    };
  }
}
