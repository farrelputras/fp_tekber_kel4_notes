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

  // Fungsi untuk mengubah angka kesulitan menjadi label
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
        backgroundColor: const Color.fromARGB(255, 255, 243, 132), // Warna kuning terang
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Tasks",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black), // Ikon hitam
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                cursorColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                decoration: InputDecoration(
                  isCollapsed: true,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white54
                        : Colors.black54,
                  ),
                  hintText: 'Search tasks...',
                  hintStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white54
                        : Colors.black54,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _tasksFirebase.readAllTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No tasks found!"));
                }

                final tasks = snapshot.data!
                    .where((task) => task['name']
                        .toString()
                        .toLowerCase()
                        .contains(_searchQuery))
                    .toList();

                if (tasks.isEmpty) {
                  return const Center(child: Text("No matching tasks found."));
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final dueDate = (task['due_date'] as Timestamp).toDate();
                    final difficultyLabel =
                        _getDifficultyLabel(task['difficulty']);
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          task['name'],
                          style: TextStyle(
                            decoration: task['completed']
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text(
                          'Due Date: ${DateFormat('dd/MM/yyyy').format(dueDate)}\nDifficulty: $difficultyLabel',
                        ),
                        trailing: Checkbox(
                          value: task['completed'],
                          onChanged: (value) {
                            _tasksFirebase.updateTask(
                              taskId: task['taskId'],
                              completed: value,
                            );
                          },
                        ),
                        // Navigasi ke TaskDetailScreen saat item diklik
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
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddTaskScreen(),
          );
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
