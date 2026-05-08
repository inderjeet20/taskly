import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  const TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.createdAt,
    required this.userId,
    required this.category,
  });

  final String? id;
  final String title;
  final String description;
  final DateTime date;
  final String status;
  final DateTime createdAt;
  final String userId;
  final String category;

  bool get isCompleted => status == 'completed';

  factory TaskModel.fromMap(Map<String, dynamic> map, String id) {
    return TaskModel(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: map['status'] as String? ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: map['userId'] as String? ?? '',
      category: map['category'] as String? ?? 'General',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'userId': userId,
      'category': category,
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? status,
    DateTime? createdAt,
    String? userId,
    String? category,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      category: category ?? this.category,
    );
  }
}
