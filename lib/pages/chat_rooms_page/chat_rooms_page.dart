import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mozz_test_task/main.dart';
import 'package:mozz_test_task/pages/chat_page/chat_page.dart';
import 'package:mozz_test_task/pages/chat_rooms_page/widgets/drop_down_menu_button.dart';
import 'package:mozz_test_task/provider/user_provider.dart';
import 'package:mozz_test_task/services/chat_service.dart';
import 'package:provider/provider.dart';

class ChatRoomsPage extends StatefulWidget {
  const ChatRoomsPage({super.key});

  @override
  State<ChatRoomsPage> createState() => _ChatRoomsPageState();
}

class _ChatRoomsPageState extends State<ChatRoomsPage> {
  @override
  Widget build(BuildContext context) {
    String id = context.watch<UserProvider>().getUserId;
    ChatService _chatService = ChatService();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chats',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          centerTitle: false,
          actions: const [DropDownMenuButton(), SizedBox(width: 10)],
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _chatService.getChatsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              //   return Center(child: Text('No chat rooms available.'));
              // }

              var chatRooms = snapshot.data!;

              return ListView.builder(
                itemCount: chatRooms.length,
                itemBuilder: (context, index) {
                  var chatRoom = chatRooms[index];
                  var userId1 = chatRoom['user1'].toString().trim();
                  var userId2 = chatRoom['user2'].toString().trim();
                  var chatRoomId = userId1 == id ? userId2 : userId1;
                  if (userId1 != id && userId2 != id) {
                    return const SizedBox();
                  }
                  return Column(children: [
                    ListTile(
                      title: Text('Chat Room with $chatRoomId'),
                      // subtitle: Text('Participants: ${participants.join(', ')}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                                chatRoomId: chatRoom['id'],
                                senderId: chatRoomId),
                          ),
                        );
                      },
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider())
                  ]);
                },
              );
            }));
  }
}
