import 'package:flutter/material.dart';
import 'add_folder_screen.dart';

class MyFolderScreen extends StatefulWidget {
  const MyFolderScreen({Key? key}) : super(key: key);

  @override
  State<MyFolderScreen> createState() => _MyFolderScreenState();
}

class _MyFolderScreenState extends State<MyFolderScreen> {
  final List<Map<String, String>> folders = []; // List untuk menyimpan folder

  // Tambahkan folder dari AddFolderScreen
  void _navigateToAddFolderScreen() async {
    final newFolder = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddFolderScreen()),
    );

    if (newFolder != null) {
      setState(() {
        folders.add(newFolder);
      });
    }
  }

  // Hapus folder
  void _deleteFolder(int index) {
    setState(() {
      folders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 243, 132),
        elevation: 0,
        title: const Text(
          'My Folder',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: folders.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'No folder yet',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search Your Folder",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: folders.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          child: ListTile(
                            leading: Image.asset('assets/folder.png', width: 40),
                            title: Text(folders[index]["name"] ?? "Unnamed Folder"),
                            subtitle: Text(folders[index]["description"] ?? ""),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    // Tambahkan logika edit jika diperlukan
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteFolder(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddFolderScreen,
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
