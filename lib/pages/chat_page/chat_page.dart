import 'package:flutter/cupertino.dart';
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
  final ChatService _chatService = ChatService();

  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200)).then((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    controller.clear();
  }

  void _scrollToOffset(double? offset) {
    if (offset != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(offset);
        }
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

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

    void clear() {
      _chatService.clearChatHistory(widget.chatRoomId);
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          widget.senderId,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
        ),
        centerTitle: false,
        actions: [
          TextButton.icon(
            style: ButtonStyle(
              side: WidgetStateProperty.all(
                  const BorderSide(color: Colors.grey, width: 1)),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            icon: const Icon(Icons.cleaning_services),
            onPressed: clear,
            label: const Text('Clear Chat History'),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _chatService.getMessages(widget.chatRoomId),
          builder: (context, snapshot) {
            _scrollToBottom();
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
