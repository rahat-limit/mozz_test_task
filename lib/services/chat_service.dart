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

        print(chat);

        return {...chat, "id": doc.id};
      }).toList();
    });
  }
}
