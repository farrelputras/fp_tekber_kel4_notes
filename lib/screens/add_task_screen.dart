import 'package:flutter/material.dart';
import '../services/tasks_firebase.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TasksFirebase _tasksFirebase = TasksFirebase();
  final TextEditingController _titleController = TextEditingController();
  DateTime? _dueDate;
  String? _selectedLevel;

  final List<Map<String, dynamic>> _levels = [
    {'label': 'Easy', 'value': 1},
    {'label': 'Medium', 'value': 2},
    {'label': 'Hard', 'value': 3},
  ];

  bool get _isFormValid =>
      _titleController.text.isNotEmpty &&
      _dueDate != null &&
      _selectedLevel != null;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  void _saveTask() {
    if (!_isFormValid) return;

    final difficulty = _levels
        .firstWhere((level) => level['label'] == _selectedLevel)['value'] as int;

    _tasksFirebase.createTask(
      name: _titleController.text,
      difficulty: difficulty,
      dueDate: _dueDate!,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add New Task",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Due Date",
                    border: OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: _dueDate == null
                        ? ""
                        : "${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}",
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedLevel,
              decoration: InputDecoration(
                labelText: "Difficulty",
                border: OutlineInputBorder(),
              ),
              items: _levels.map((level) {
                return DropdownMenuItem<String>(
                  value: level['label'],
                  child: Text(level['label']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLevel = value;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isFormValid ? _saveTask : null,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
