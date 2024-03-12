import 'package:flutter/material.dart';

class VoiceRecognition extends StatelessWidget {
  final TextEditingController controller;
  final bool isTyping;
  final VoidCallback startListening;
  final ScrollController scrollController;
  final Function(String, bool) onSend;

  const VoiceRecognition({
    Key? key,
    required this.controller,
    required this.isTyping,
    required this.startListening,
    required this.scrollController,
    required this.onSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool localIsTyping = isTyping;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 16, bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (text) {
                // Update localIsTyping
                localIsTyping = text.isNotEmpty;
              },
              decoration: InputDecoration(
                hintText: 'Type something...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(
                    width: 2.0,
                    color: Colors.blue,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              ),
            ),
          ),
          IconButton(
            icon: localIsTyping
                ? const Icon(Icons.send)
                : const Icon(Icons.keyboard_voice, size: 30),
            onPressed: () {
              // Pass localIsTyping to the callback function
              onSend(controller.text, localIsTyping);

              // Scroll to bottom of the chat after sending message
              WidgetsBinding.instance.addPostFrameCallback((_) {
                scrollController
                    .jumpTo(scrollController.position.maxScrollExtent);
              });
            },
          ),
        ],
      ),
    );
  }
}
