import 'package:flutter/material.dart';

class AddFolderScreen extends StatefulWidget {
  const AddFolderScreen({Key? key}) : super(key: key);

  @override
  State<AddFolderScreen> createState() => _AddFolderScreenState();
}

class _AddFolderScreenState extends State<AddFolderScreen> {
  final TextEditingController _folderNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _folderNameError;
  String? _descriptionError;

  // Fungsi untuk validasi dan menyimpan folder
  void _saveFolder() {
    setState(() {
      _folderNameError = _folderNameController.text.isEmpty ? "Folder name cannot be empty" : null;
      _descriptionError = _descriptionController.text.isEmpty ? "Description cannot be empty" : null;
    });

    if (_folderNameError == null && _descriptionError == null) {
      // Jika validasi berhasil, data bisa dikembalikan ke screen sebelumnya
      Navigator.pop(context, {
        "name": _folderNameController.text,
        "description": _descriptionController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add New Folder",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 243, 132),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Folder Name
            TextField(
              controller: _folderNameController,
              decoration: InputDecoration(
                labelText: "Folder Name",
                errorText: _folderNameError,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Input Description
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                errorText: _descriptionError,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Choose Your Notes
            const Text(
              "Choose Your Notes",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // List of Notes with Checkboxes
            Expanded(
              child: ListView(
                children: [
                  CheckboxListTile(
                    value: true,
                    onChanged: (value) {},
                    title: const Text("Catetan MRTI"),
                  ),
                  CheckboxListTile(
                    value: false,
                    onChanged: (value) {},
                    title: const Text("Catetan Tekber"),
                  ),
                  CheckboxListTile(
                    value: false,
                    onChanged: (value) {},
                    title: const Text("Catetan PSTI"),
                  ),
                ],
              ),
            ),

            // Save Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              onPressed: _saveFolder,
              child: const Center(
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
