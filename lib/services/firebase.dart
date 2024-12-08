import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  // CREATE dengan ID auto-increment
  Future<void> addNote(String title, String content) async {
    QuerySnapshot snapshot =
        await notes.orderBy('id', descending: true).limit(1).get();
    int newId = snapshot.docs.isNotEmpty
        ? (snapshot.docs.first['id'] as int) + 1
        : 1;

    await notes.add({
      'id': newId,
      'note': title,
      'content': content,
      'timestamp': Timestamp.now(),
    });
  }

  // READ (stream untuk semua catatan)
  Stream<QuerySnapshot> getNotesStream() {
    return notes.orderBy('id').snapshots();
  }

  // READ SINGLE NOTE
  Future<DocumentSnapshot<Map<String, dynamic>>> getNoteById(String docId) async {
  return await notes.doc(docId).get() as DocumentSnapshot<Map<String, dynamic>>;
}


  // UPDATE
  Future<void> updateNote(String docId, String newTitle, String newContent) async {
    await notes.doc(docId).update({
      'note': newTitle,
      'content': newContent,
      'timestamp': Timestamp.now(),
    });
  }

  // DELETE
  Future<void> deleteNote(String docId) async {
    await notes.doc(docId).delete();
  }
}
