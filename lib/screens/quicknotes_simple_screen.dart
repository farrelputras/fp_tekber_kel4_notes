import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_tekber_kel4_notes/services/firebase.dart';
import 'add_note_screen.dart';

class QuickNotesSimple extends StatefulWidget {
  const QuickNotesSimple({Key? key}) : super(key: key);

  @override
  State<QuickNotesSimple> createState() => _QuickNotesSimpleState();
}

class _QuickNotesSimpleState extends State<QuickNotesSimple> {
  final TextEditingController searchController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  @override
  void dispose() {
    searchController.dispose();
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
          'Quick Notes',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.black54),
                  hintText: 'Search Your Note',
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getNotesStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List notesList = snapshot.data!.docs;

                    if (notesList.isEmpty) {
                      return const Center(
                        child: Text('No notes available.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: notesList.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = notesList[index];
                        String docID = document.id;

                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        String noteText = data['note'];

                        return ListTile(
                          title: Text(noteText),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error loading notes.'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNoteScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
