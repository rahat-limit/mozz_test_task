import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        // .orderBy('timestamp', descending: true)
        .snapshots();
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
