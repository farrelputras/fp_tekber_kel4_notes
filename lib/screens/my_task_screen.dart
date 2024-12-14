import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';
import '../services/tasks_firebase.dart';

class MyTaskScreen extends StatefulWidget {
  const MyTaskScreen({Key? key}) : super(key: key);

  @override
  State<MyTaskScreen> createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<MyTaskScreen> {
  final TasksFirebase _tasksFirebase = TasksFirebase();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  String _getDifficultyLabel(int difficulty) {
    switch (difficulty) {
      case 1:
        return "Easy";
      case 2:
        return "Medium";
      case 3:
        return "Hard";
      default:
        return "Unknown";
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 243, 132),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Tasks",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  hintText: 'Search tasks...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _tasksFirebase.readAllTasks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("No tasks found!"),
                    );
                  }

                  final tasks = snapshot.data!
                      .where((task) => task['name']
                          .toString()
                          .toLowerCase()
                          .contains(_searchQuery))
                      .toList();

                  if (tasks.isEmpty) {
                    return const Center(
                      child: Text("No matching tasks found."),
                    );
                  }

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final dueDate = (task['due_date'] as Timestamp).toDate();
                      final difficultyLabel =
                          _getDifficultyLabel(task['difficulty']);

                      return Card(
  elevation: 1,
  color: Theme.of(context).brightness == Brightness.dark
      ? Colors.black // Warna Card hitam untuk dark mode
      : const Color(0xFFF9F3E5), // Warna Card untuk light mode
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  margin: const EdgeInsets.symmetric(vertical: 8),
  child: InkWell(
    borderRadius: BorderRadius.circular(12), // Efek hover mencakup border radius
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskDetailScreen(
            taskId: task['taskId'],
            taskName: task['name'],
            difficulty: task['difficulty'],
            dueDate: dueDate,
            completed: task['completed'],
          ),
        ),
      );
    },
    onLongPress: () {
      _tasksFirebase.deleteTask(task['taskId']);
    },
    child: ListTile(
      contentPadding: const EdgeInsets.all(12),
      title: Text(
        task['name'],
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white // Warna font putih di dark mode
              : Colors.black87, // Warna font di light mode
        ),
      ),
      subtitle: Text(
        'Due Date: ${DateFormat('dd/MM/yyyy').format(dueDate)}\n'
        'Difficulty: $difficultyLabel',
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white70 // Warna font di dark mode
              : Colors.black54, // Warna font di light mode
        ),
      ),
      trailing: Checkbox(
        value: task['completed'],
        activeColor: Colors.purple,
        checkColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black // Border checkbox hitam di dark mode
            : Colors.white, // Border checkbox putih di light mode
        onChanged: (value) {
          _tasksFirebase.updateTask(
            taskId: task['taskId'],
            completed: value,
                                );
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskDetailScreen(
                                    taskId: task['taskId'],
                                    taskName: task['name'],
                                    difficulty: task['difficulty'],
                                    dueDate: dueDate,
                                    completed: task['completed'],
                                  ),
                                ),
                              );
                            },
                            onLongPress: () {
                              _tasksFirebase.deleteTask(task['taskId']);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddTaskScreen(),
          );
        },
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
