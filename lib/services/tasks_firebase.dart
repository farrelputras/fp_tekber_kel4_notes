import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class TasksFirebase {
  final Uuid _uuid = Uuid(); // Untuk menghasilkan UUID
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  // Create Task
  Future<void> createTask({
    required String name,
    required int difficulty,
    required DateTime dueDate,
  }) async {
    final String taskId = _uuid.v4(); // Menghasilkan UUID
    await _tasksCollection.doc(taskId).set({
      'taskId': taskId,
      'name': name,
      'completed': false,
      'difficulty': difficulty,
      'due_date': dueDate,
    });
  }

  // Read All Tasks
  Stream<List<Map<String, dynamic>>> readAllTasks() {
    return _tasksCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }

  // Read Task by ID (menggunakan String UUID)
  Future<Map<String, dynamic>?> readTaskById(String taskId) async {
    final DocumentSnapshot doc =
        await _tasksCollection.doc(taskId).get();
    return doc.exists ? doc.data() as Map<String, dynamic> : null;
  }

  // Update Task (menggunakan String UUID)
  Future<void> updateTask({
    required String taskId,
    String? name,
    bool? completed,
    int? difficulty,
    DateTime? dueDate,
  }) async {
    Map<String, dynamic> updates = {};
    if (name != null) updates['name'] = name;
    if (completed != null) updates['completed'] = completed;
    if (difficulty != null) updates['difficulty'] = difficulty;
    if (dueDate != null) updates['due_date'] = dueDate;

    await _tasksCollection.doc(taskId).update(updates); // Menggunakan taskId UUID
  }

  // Delete Task (menggunakan String UUID)
  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete(); // Menggunakan taskId UUID
  }
}
