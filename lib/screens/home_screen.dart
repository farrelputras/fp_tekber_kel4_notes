import 'package:flutter/material.dart';
import 'package:fp_tekber_kel4_notes/screens/add_note_screen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavController());

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
      //Start NavBar
      bottomNavigationBar: Obx(() => NavigationBar(
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) =>
                controller.selectedIndex.value = index,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.note_alt), label: 'Notes'),
              NavigationDestination(
                  icon: Icon(Icons.check_box_outlined), label: 'ToDoList')
            ],
          )),

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

class NavController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
}
