import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase.dart';
import '../services/folders_database.dart';

class FolderDetailsScreen extends StatefulWidget {
  final String folderId;

  const FolderDetailsScreen({Key? key, required this.folderId}) : super(key: key);

  @override
  State<FolderDetailsScreen> createState() => _FolderDetailsScreenState();
}

class _FolderDetailsScreenState extends State<FolderDetailsScreen> {
  final TextEditingController _folderNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final Set<String> _selectedNotes = {};
  final FirestoreService firestoreService = FirestoreService();

  bool _isLoading = true;
  late Stream<List<DocumentSnapshot>> notesStream;

  @override
  void initState() {
    super.initState();
    _loadFolderDetails();
  }

  Future<void> _loadFolderDetails() async {
    // Load folder data
    final folder = await FoldersDatabase().getFolderById(widget.folderId);
    final notesInFolder = await FoldersDatabase().getNotesInFolder(widget.folderId);

    setState(() {
      _folderNameController.text = folder['name'];
      _descriptionController.text = folder['description'];
      _isLoading = false;
    });

    // Set notes stream
    notesStream = FoldersDatabase().getNotesInFolder(widget.folderId);
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    // Update folder details
    await FoldersDatabase().updateFolder(
      widget.folderId,
      _folderNameController.text,
      _descriptionController.text,
    );

    // Update selected notes in folder
    await FoldersDatabase().updateNotesInFolder(widget.folderId, _selectedNotes);

    setState(() => _isLoading = false);

    Navigator.pop(context, true);
  }

  Future<void> _deleteFolder() async {
    await FoldersDatabase().deleteFolder(widget.folderId);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Folder Details",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 243, 132),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _deleteFolder,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _folderNameController,
              decoration: const InputDecoration(labelText: "Folder Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            const Text("Notes in Folder", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Display notes that are part of the folder
            StreamBuilder<List<DocumentSnapshot>>(
              stream: notesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error loading notes"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No notes available"));
                }

                final notes = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    final noteId = note.id;
                    final noteTitle = note['note'];

                    return CheckboxListTile(
                      value: _selectedNotes.contains(noteId),
                      onChanged: (bool? isChecked) {
                        setState(() {
                          if (isChecked == true) {
                            _selectedNotes.add(noteId);
                          } else {
                            _selectedNotes.remove(noteId);
                          }
                        });
                      },
                      title: Text(noteTitle),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
