// lib/models/task.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String? id;
  String title;
  bool isCompleted;

  Task({this.id, required this.title, this.isCompleted = false});

  // Convert Task to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  // Create Task from DocumentSnapshot
  factory Task.fromDocument(DocumentSnapshot doc) {
    return Task(
      id: doc.id,
      title: doc['title'],
      isCompleted: doc['isCompleted'],
    );
  }
}
