import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  Future<void> _sendMessage() async {
    String input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'message': input});
    });

    _controller.clear();

    if (_isMenuRequest(input)) {
      await _fetchAndDisplayMenu();
    } else {
      String botResponse = await _getBotResponse(input);

      setState(() {
        _messages.add({'sender': 'bot', 'message': botResponse});
      });
    }
  }

  bool _isMenuRequest(String input) {
    final lowerInput = input.toLowerCase();
    return lowerInput.contains('menu') ||
        lowerInput.contains('food') ||
        lowerInput.contains('dishes');
  }

  Future<void> _fetchAndDisplayMenu() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('restaurants').get();
      final dishes = snapshot.docs.map((doc) => doc.data()).toList();

      if (dishes.isEmpty) {
        setState(() {
          _messages.add({
            'sender': 'bot',
            'message': 'No dishes are currently available.'
          });
        });
      } else {
        final dishList = dishes
            .map((dish) => '${dish['name']} - ₹${dish['price'] ?? 'N/A'}')
            .join('\n');
        setState(() {
          _messages.add({
            'sender': 'bot',
            'message': 'Here are the available dishes:\n$dishList'
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'sender': 'bot',
          'message': 'Failed to fetch menu: ${e.toString()}'
        });
      });
    }
  }

  Future<String> _getBotResponse(String userMessage) async {
    const apiKey =
        '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';
    const url = 'https://openrouter.ai/api/v1/chat/completions';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "user", "content": userMessage}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        return "Error: ${response.statusCode}";
      }
    } catch (e) {
      return "Error contacting server.";
    }
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
