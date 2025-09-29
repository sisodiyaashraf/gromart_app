import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../provider/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _send(ChatProvider chat) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    chat.sendUserMessage(text);
    _scrollToBottom();
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied to clipboard ✅")),
    );
  }

  void _shareText(String text) {
    Share.share(text);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<ChatProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gromart Ai"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: chat.messages.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final m = chat.messages[index];
                final bool isUser = m.role == "user";

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFF4CAF50) // green
                          : Colors.grey.shade100, // light gray
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft:
                            isUser ? const Radius.circular(20) : Radius.zero,
                        bottomRight:
                            isUser ? Radius.zero : const Radius.circular(20),
                      ),
                    ),
                    child: isUser
                        ? Text(
                            m.text,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          )
                        : GestureDetector(
                            onLongPress: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (_) => SafeArea(
                                  child: Wrap(
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.copy),
                                        title: const Text("Copy"),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _copyToClipboard(m.text);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.share),
                                        title: const Text("Share"),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _shareText(m.text);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: GptMarkdown(
                              m.text,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black87),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),

          // Typing indicator (dots animation)
          if (chat.isLoading)
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: Colors.grey,
                  size: 28,
                ),
              ),
            ),

          // Chat Input Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask me anything...",
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _send(chat),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () => _send(chat),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
