// chat_messages.dart
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  final List<Map<String, String>> messages;
  final double maxMessageWidth;

  const ChatMessages({
    Key? key,
    required this.messages,
    required this.maxMessageWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return Align(
            alignment: message['sender'] == 'user'
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: maxMessageWidth,
              ),
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                color: message['sender'] == 'user'
                    ? Colors.blue
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                message['text']!,
                style: TextStyle(
                  color:
                      message['sender'] == 'user' ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
