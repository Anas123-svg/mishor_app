class Task {
  String ?title;
  bool? completed;

  Task({this.title, this.completed});

  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        completed = json['completed'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'completed': completed,
      };
}