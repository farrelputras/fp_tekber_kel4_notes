import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/folders_database.dart';
import 'add_folder_screen.dart';
import 'folder_detail_screen.dart';

class MyFolderScreen extends StatefulWidget {
  const MyFolderScreen({Key? key}) : super(key: key);

  @override
  State<MyFolderScreen> createState() => _MyFolderScreenState();
}

class _MyFolderScreenState extends State<MyFolderScreen> {
  final FoldersDatabase foldersDatabase = FoldersDatabase();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 243, 132), // Warna kuning terang
        elevation: 0,
        centerTitle: true, // Membuat teks judul di tengah
        title: const Text(
          'My Folders',
          style: TextStyle(
            color: Colors.black, // Teks hitam
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Ikon hitam
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                  hintText: 'Search Your Folder',
                  hintStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white54
                        : Colors.black54,
                  ),
                  border: InputBorder.none, // Tidak menggunakan border default
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Folder List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: foldersDatabase.getFolders(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final folders = snapshot.data!.docs.where((doc) {
                      final name = doc['name'].toString().toLowerCase();
                      return name.contains(searchQuery);
                    }).toList();

                    if (folders.isEmpty) {
                      return const Center(
                        child: Text('No folders available.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: folders.length,
                      itemBuilder: (context, index) {
                        final folder = folders[index];
                        final folderId = folder.id;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Image.asset('assets/folder.png', width: 40),
                            title: Text(
                              folder['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(folder['description']),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FolderDetailsScreen(folderId: folderId),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error loading folders.'),
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
        backgroundColor: Colors.purple, // Warna ungu terang
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFolderScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white), // Ikon tambah putih
      ),
    );
  }
}
