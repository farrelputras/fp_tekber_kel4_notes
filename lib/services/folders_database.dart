import 'package:cloud_firestore/cloud_firestore.dart';

class FoldersDatabase {
  final CollectionReference foldersCollection =
      FirebaseFirestore.instance.collection('folders');

  // Tambahkan folder baru
  Future<void> addFolder(String name, String description, List<String> selectedNotes) async {
    await foldersCollection.add({
      'name': name,
      'description': description,
      'notes': selectedNotes,
    });
  }

  Stream<QuerySnapshot> getFolders() {
    return foldersCollection.snapshots();
  }

  // Dapatkan folder berdasarkan ID
  Future<Map<String, dynamic>> getFolderById(String folderId) async {
    final doc = await foldersCollection.doc(folderId).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      throw Exception("Folder not found");
    }
  }

  // Perbaikan: Stream notes dalam folder
  Stream<List<DocumentSnapshot>> getNotesInFolder(String folderId) {
    return foldersCollection.doc(folderId).snapshots().asyncMap((folderSnapshot) async {
      if (folderSnapshot.exists) {
        List<String> notesIds = List<String>.from(folderSnapshot['notes'] ?? []);
        if (notesIds.isEmpty) return [];
        final notesQuery = await FirebaseFirestore.instance
            .collection('notes')
            .where(FieldPath.documentId, whereIn: notesIds)
            .get();
        return notesQuery.docs;
      } else {
        return [];
      }
    });
  }

  // Perbarui folder
  Future<void> updateFolder(String folderId, String name, String description) async {
    await foldersCollection.doc(folderId).update({
      'name': name,
      'description': description,
    });
  }

  // Perbarui notes dalam folder
  Future<void> updateNotesInFolder(String folderId, Set<String> noteIds) async {
    await foldersCollection.doc(folderId).update({
      'notes': noteIds.toList(),
    });
  }

  // Hapus folder
  Future<void> deleteFolder(String folderId) async {
    await foldersCollection.doc(folderId).delete();
  }
}
