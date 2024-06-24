import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mozz_test_task/pages/chat_page/widgets/custom_text_field.dart';
import 'package:mozz_test_task/pages/chat_page/widgets/view_message_bubble.dart';
import 'package:mozz_test_task/services/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String chatRoomId;
  const ChatPage({super.key, required this.chatRoomId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  void sendMessage() {}
  @override
  Widget build(BuildContext context) {
    ChatService _chatService = ChatService();

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _chatService.getMessages(widget.chatRoomId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var messages = snapshot.data!.docs;
            print(messages);

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
                        ViewMessageBubble(text: "e['text']", isMe: true),
                        ...messages.map((e) =>
                            ViewMessageBubble(text: e['text'], isMe: true))
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
