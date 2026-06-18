import 'package:smart_kishan/shared/models/user.dart';

class Note {
  const Note({
    this.id,
    this.title,
    this.description,
    this.priority,
    this.userId,
    this.date,
    this.user,
  });

  final int? id;
  final String? title;
  final String? description;
  final int? priority;
  final int? userId;
  final String? date;
  final User? user;

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      priority: json['priority'] as int?,
      userId: json['user_id'] as int?,
      date: json['created_at'] as String?,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Body for create/update. Server assigns id/user/date.
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'priority': priority,
  };
}
