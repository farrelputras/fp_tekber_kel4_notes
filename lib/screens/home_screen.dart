import 'package:flutter/material.dart';

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
        backgroundColor: Colors.yellow, // Warna kuning untuk FAB
        elevation: 0, // Hilangkan bayangan FAB
        onPressed: () {
          // Tambahkan aksi FAB
        },
        child: const Icon(
          Icons.add,
          color: Colors.black, // Warna ikon hitam
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
