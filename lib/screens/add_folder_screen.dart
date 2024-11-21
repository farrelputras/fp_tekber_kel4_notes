import 'package:flutter/material.dart';

class AddFolderScreen extends StatelessWidget {
  const AddFolderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Folder"
        ,style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black
        )
        ,),
        backgroundColor: const Color.fromARGB(255, 255, 243, 132),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: "Folder Name",
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: "Description",
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Choose Your Notes",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              onPressed: () {},
              child: const Center(
                child: Text("Save", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
