import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_tekber_kel4_notes/services/firebase.dart';
import 'add_note_screen.dart';
import 'notes_detail_screen.dart';

class QuickNotesSimple extends StatefulWidget {
  const QuickNotesSimple({Key? key}) : super(key: key);

  @override
  State<QuickNotesSimple> createState() => _QuickNotesSimpleState();
}

class _QuickNotesSimpleState extends State<QuickNotesSimple> {
  final TextEditingController searchController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();
  String searchQuery = "";

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
    color: Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade800
        : Colors.grey.shade200,
    borderRadius: BorderRadius.circular(12), // Sudut membulat
  ),
  child: TextField(
    controller: searchController,
    onChanged: (value) {
      setState(() {
        searchQuery = value.toLowerCase();
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
      isCollapsed: true, // Menghapus padding default
      prefixIcon: Icon(
        Icons.search,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white54
            : Colors.black54,
      ),
      hintText: 'Search Your Note',
      hintStyle: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white54
            : Colors.black54,
      ),
      border: InputBorder.none, // Tidak menggunakan border default
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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

                    // Filter notes based on search query
                    List filteredNotes = notesList.where((doc) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;
                      String note = data['note'] ?? '';
                      String content = data['content'] ?? '';
                      return note.toLowerCase().contains(searchQuery) ||
                          content.toLowerCase().contains(searchQuery);
                    }).toList();

                    if (filteredNotes.isEmpty) {
                      return const Center(
                        child: Text('No notes available.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredNotes.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = filteredNotes[index];
                        String docID = document.id;

                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;

                        String note = data['note'] ?? 'Untitled';
                        String content = data['content'] ?? 'No content';
                        Timestamp timestamp = data['timestamp'];
                        DateTime dateTime = timestamp.toDate();
                        String formattedDate =
                            '${dateTime.day}/${dateTime.month}/${dateTime.year}';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              note,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(content,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NoteDetailsScreen(docID: docID),
                                ),
                              );
                            },
                          ),
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
