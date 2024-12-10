import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/tasks_firebase.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId; // Ganti menjadi String untuk UUID
  final String taskName;
  final int difficulty;
  final DateTime dueDate;
  final bool completed; // Tambahkan parameter ini

  const TaskDetailScreen({
    Key? key,
    required this.taskId, // Ganti menjadi String untuk UUID
    required this.taskName,
    required this.difficulty,
    required this.dueDate,
    required this.completed, // Tambahkan parameter ini
  }) : super(key: key);

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final TasksFirebase _tasksFirebase = TasksFirebase();

  late TextEditingController _nameController;
  late int _selectedDifficulty;
  late DateTime _selectedDueDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.taskName);
    _selectedDifficulty = widget.difficulty;
    _selectedDueDate = widget.dueDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDueDate) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  Future<void> _updateTask() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task name cannot be empty')),
      );
      return;
    }

    try {
      await _tasksFirebase.updateTask(
        taskId: widget.taskId, // Gunakan taskId sebagai String UUID
        name: _nameController.text,
        difficulty: _selectedDifficulty,
        dueDate: _selectedDueDate,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task updated successfully!')),
      );

      Navigator.pop(context); // Tutup layar setelah update
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Update Task",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Task Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _selectedDifficulty,
                  decoration: const InputDecoration(
                    labelText: "Difficulty",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Easy')),
                    DropdownMenuItem(value: 2, child: Text('Medium')),
                    DropdownMenuItem(value: 3, child: Text('Hard')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedDifficulty = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _selectDate,
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Due Date",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy').format(_selectedDueDate),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _updateTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Update Task"),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () async {
                final bool confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: const Text('Are you sure you want to delete this task?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );

                if (confirm) {
                  try {
                    await _tasksFirebase.deleteTask(widget.taskId); // Gunakan taskId sebagai String UUID
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task deleted successfully!')),
                    );
                    Navigator.pop(context); // Tutup layar setelah penghapusan
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete task: $e')),
                    );
                  }
                }
              },
              backgroundColor: Colors.red,
              child: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }
}
