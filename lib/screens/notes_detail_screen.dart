import 'package:flutter/material.dart';
import 'package:fp_tekber_kel4_notes/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteDetailsScreen extends StatefulWidget {
  final String docID;
  const NoteDetailsScreen({Key? key, required this.docID}) : super(key: key);

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNoteDetails();
  }

  Future<void> _loadNoteDetails() async {
  DocumentSnapshot<Map<String, dynamic>> doc = await firestoreService.getNoteById(widget.docID);
  if (doc.data() != null) {
    Map<String, dynamic> data = doc.data()!;
    titleController.text = data['note'];
    contentController.text = data['content'];
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await firestoreService.deleteNote(widget.docID);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note deleted successfully!')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Content',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await firestoreService.updateNote(
                  widget.docID,
                  titleController.text,
                  contentController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note updated successfully!')),
                );
              },
              child: const Text('Update Note'),
            ),
          ],
        ),
      ),
    );
  }
}
