import 'package:flutter/material.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  void _sendMessage() {
    String input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'message': input});
      _messages.add({'sender': 'bot', 'message': _getBotResponse(input)});
      _controller.clear();
    });
  }

  String _getBotResponse(String message) {
    message = message.toLowerCase();
    if (message.contains("hello")) return "Hi there!";
    if (message.contains("how are you")) return "I'm just code, but I'm good!";
    if (message.contains("bye")) return "Goodbye!";
    return "Sorry, I didn't understand that.";
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const Text(
              "AI Chatbot",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: _messages.length,
                itemBuilder: (_, index) {
                  final msg = _messages[index];
                  final isUser = msg['sender'] == 'user';
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(msg['message']!),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
