import 'package:flutter/material.dart';
import 'package:fp_tekber_kel4_notes/screens/add_note_screen.dart';
import 'package:get/get.dart';

class MyAppScreen extends StatelessWidget {
  const MyAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      //Start AppBar
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(
            255, 255, 243, 132), // Warna kuning untuk AppBar
        centerTitle: true, // Teks judul di tengah
        title: const Text(
          'EduNotes',
          style: TextStyle(
            color: Colors.black, // Teks warna hitam
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      //Start ActionButton
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 189, 117, 202),
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

      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 16.0,
              ),

              //Search Bar
              SearchBar(
                controller: searchController,
                leading: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                ),
                hintText: 'Search Your Note',
              ),
              const SizedBox(
                height: 16.0,
              ),

              //My Apps Text
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'My Apps',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
}
