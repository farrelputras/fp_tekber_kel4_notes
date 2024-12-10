  import 'package:cloud_firestore/cloud_firestore.dart';

  class TasksFirebase {
    final CollectionReference _tasksCollection =
        FirebaseFirestore.instance.collection('tasks');

    // Auto-incremental ID for tasks
    Future<int> _getNextTaskId() async {
      final QuerySnapshot querySnapshot = await _tasksCollection.get();
      return querySnapshot.docs.length + 1;
    }

    // Create Task
    Future<void> createTask({
      required String name,
      required int difficulty,
      required DateTime dueDate,
    }) async {
      final int taskId = await _getNextTaskId();
      await _tasksCollection.doc(taskId.toString()).set({
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

    // Read Task by ID
    Future<Map<String, dynamic>?> readTaskById(int taskId) async {
      final DocumentSnapshot doc =
          await _tasksCollection.doc(taskId.toString()).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    }

    // Update Task
    Future<void> updateTask({
      required int taskId,
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

      await _tasksCollection.doc(taskId.toString()).update(updates);
    }
    

    // Delete Task
    Future<void> deleteTask(int taskId) async {
      await _tasksCollection.doc(taskId.toString()).delete();
    }
  }
