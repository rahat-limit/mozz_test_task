import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  Stream<List<Map<String, dynamic>>> getMessages(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) {
        final chat = doc.data();
        return chat;
      }).toList();
    });
  }

  Future<void> sendMessage(String chatRoomId, String text, String myId) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'userId': myId,
      'text': text,
      'timestamp': DateTime.now().toString()
    });
  }

  Stream<List<Map<String, dynamic>>> getChatsStream() {
    return FirebaseFirestore.instance
        .collection('chats')
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) {
        final chat = doc.data();
        return {...chat, "id": doc.id};
      }).toList();
    });
  }

  Future clearChatHistory(String chatRoomId) async {
    var collections = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages');

    var snapshots = await collections.get();

    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }
}
