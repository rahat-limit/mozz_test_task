import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mozz_test_task/pages/chat_page/widgets/custom_text_field.dart';
import 'package:mozz_test_task/pages/chat_page/widgets/view_message_bubble.dart';
import 'package:mozz_test_task/provider/user_provider.dart';
import 'package:mozz_test_task/services/chat_service.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String chatRoomId;
  final String senderId;
  const ChatPage({super.key, required this.chatRoomId, required this.senderId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController controller = TextEditingController();
  ChatService _chatService = ChatService();

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var myId = context.watch<UserProvider>().getUserId;

    void sendMessage() {
      if (controller.text.isNotEmpty) {
        _chatService.sendMessage(
            widget.chatRoomId, controller.text.trim(), myId);
      }
      controller.clear();
    }

    return Scaffold(
      appBar: AppBar(
          titleSpacing: 0,
          title: Text(
            widget.senderId,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
          ),
          centerTitle: false),
      body: SafeArea(
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _chatService.getMessages(widget.chatRoomId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var messages = snapshot.data;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: OrientationBuilder(builder: (context, orientation) {
                  return Padding(
                    padding: orientation == Orientation.portrait
                        ? const EdgeInsets.only(bottom: 65.0)
                        : const EdgeInsets.only(bottom: 150.0),
                    child: Column(
                      children: [
                        // if (chatLoading)
                        //   Container(
                        //       padding: const EdgeInsets.all(8),
                        //       width: 40,
                        //       height: 40,
                        //       child: const CircularProgressIndicator(
                        //           strokeWidth: 3)),
                        ...messages!.map((e) {
                          return ViewMessageBubble(
                              text: e['text'],
                              isMe: e['userId'].toString().trim() ==
                                  myId.toString().trim(),
                              timestamp: e['timestamp']);
                        })
                      ],
                    ),
                  );
                }),
              ),
            );
            // return ListView.builder(
            //   itemCount: messages.length,
            //   reverse: true,
            //   itemBuilder: (context, index) {
            //     var message = messages[index];
            //     return ListTile(
            //       title: Text(message['text']),
            //       subtitle: Text(message['senderId']),
            //     );
            //   },
            // );
          },
        ),
      ),
      bottomSheet: OrientationBuilder(builder: (context, orientation) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height * 0.1
              : MediaQuery.of(context).size.height * 0.21,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.5)),
          ]),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: CustomTextField(
            controller: controller,
            title: 'Сообщение',
            sufixIcon: IconButton(
              onPressed: () {
                sendMessage();
              },
              icon: const Icon(
                Icons.send,
              ),
            ),
          ),
        );
      }),
    );
  }
}
