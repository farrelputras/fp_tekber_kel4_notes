import 'package:flutter/material.dart';
import 'package:fp_tekber_kel4_notes/screens/add_note_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 243, 132), // Warna kuning untuk AppBar
        centerTitle: true, // Teks judul di tengah
        title: const Text(
          'Notes',
          style: TextStyle(
            color: Colors.black, // Teks warna hitam
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
  backgroundColor: Colors.yellow,
  elevation: 0,
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNoteScreen(),
      ),
    );
  },
  child: const Icon(
    Icons.add,
    color: Colors.black,
  ),
),
      body: const Center(
        child: Text(
          'No notes yet!',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey, // Warna teks placeholder
          ),
        ),
      ),
    );
  }
}
