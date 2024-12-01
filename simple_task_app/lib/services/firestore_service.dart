// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class FirestoreService {
  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  // Add a new task
  Future<void> addTask(Task task) async {
    await tasksCollection.add(task.toJson());
  }

  // Update a task
  Future<void> updateTask(Task task) async {
    await tasksCollection.doc(task.id).update(task.toJson());
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    await tasksCollection.doc(id).delete();
  }

  // Stream of tasks
  Stream<List<Task>> getTasks() {
    return tasksCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromDocument(doc)).toList();
    });
  }
}
