class Todolist {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String status;

  Todolist({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.status,
  });

  factory Todolist.fromJson(Map<String, dynamic> json) {
    return Todolist(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      time: json['time'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'status': status,
    };
  }
}
