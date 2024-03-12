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
          final isUser = message['sender'] == 'user';

          return Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: isUser
                  ? MainAxisAlignment.end
                  : MainAxisAlignment
                      .start, // Adjust mainAxisAlignment based on isUser
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: maxMessageWidth,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    message['text']!,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                if (!isUser)
                  Padding(
                    padding: const EdgeInsets.all(0), // Set padding to zero
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: const Icon(
                        Icons.play_circle,
                        size: 24,
                      ),
                      onPressed: () {
                        // Call the method to speak the message text
                        speakMessage(message['text']!);
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void speakMessage(String text) {
    // Implement the logic to speak the message text here
    // You can use the text-to-speech functionality from your HomePage or any other service
  }
}
