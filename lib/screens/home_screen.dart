import 'package:flutter/material.dart';
import 'package:fp_tekber_kel4_notes/widget/notes_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[50],
          elevation: 0,
          onPressed: () {},
          child: Icon(
            Icons.add,
            color: Colors.black,
          )),
      body: NotesBody(),
    );
  }
}
