import 'package:flutter/material.dart';
import 'add_task_screen.dart';

class MyTaskScreen extends StatelessWidget {
  const MyTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 243, 132),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'My Tasks',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Task 1
            TaskCard(
              title: "Tugas Tekber",
              dueDate: "21/11/2024",
              priority: "Medium",
              priorityColor: Colors.yellow,
              isCompleted: false,
            ),
            const SizedBox(height: 16),
            // Task 2
            TaskCard(
              title: "Tugas PAP",
              dueDate: "22/11/2024",
              priority: "Hard",
              priorityColor: Colors.red,
              isCompleted: true,
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
           child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String dueDate;
  final String priority;
  final Color priorityColor;
  final bool isCompleted;

  const TaskCard({
    super.key,
    required this.title,
    required this.dueDate,
    required this.priority,
    required this.priorityColor,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Checkbox
          Checkbox(
            value: isCompleted,
            activeColor: Colors.green,
            onChanged: (bool? value) {
              // Tambahkan logika untuk update status tugas
            },
          ),
          const SizedBox(width: 8),
          // Task Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "Due: $dueDate",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        priority,
                        style: TextStyle(
                          fontSize: 12,
                          color: priorityColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Edit & Delete Icons
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black54),
                onPressed: () {
                  // Tambahkan fungsi edit tugas
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.black54),
                onPressed: () {
                  // Tambahkan fungsi hapus tugas
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
