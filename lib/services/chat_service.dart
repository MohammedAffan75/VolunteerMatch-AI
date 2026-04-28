import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  static final _db = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> chatListStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return _db
        .collection('chats')
        .where('participants', arrayContains: uid)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> messagesStream(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(String chatId, String text) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || text.trim().isEmpty) return;
    final ref = _db.collection('chats').doc(chatId);
    await ref.collection('messages').add({
      'senderId': uid,
      'text': text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    await ref.set({'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  }
}
