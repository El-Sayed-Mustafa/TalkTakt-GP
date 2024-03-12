import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatMessages extends StatefulWidget {
  final List<Map<String, String>> messages;
  final double maxMessageWidth;

  const ChatMessages({
    Key? key,
    required this.messages,
    required this.maxMessageWidth,
  }) : super(key: key);

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  final FlutterTts _flutterTts = FlutterTts();
  int? _currentWordStart, _currentWordEnd;

  @override
  void initState() {
    super.initState();
    initTTS();
  }

  void initTTS() {
    _flutterTts.setProgressHandler((text, start, end, word) {
      setState(() {
        _currentWordStart = start;
        _currentWordEnd = end;
      });
    });
    _flutterTts.getVoices.then((data) {
      try {
        // Set voice if needed
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: widget.messages.length,
        itemBuilder: (context, index) {
          final message = widget.messages[index];
          final isUser = message['sender'] == 'user';

          return Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Row(
              mainAxisAlignment:
                  isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: widget.maxMessageWidth,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                      ),
                      children: isUser
                          ? [TextSpan(text: message['text']!)]
                          : _buildTextSpans(message['text']!),
                    ),
                  ),
                ),
                if (!isUser)
                  Padding(
                    padding: const EdgeInsets.all(0), // Set padding to zero
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.play_circle,
                        size: 25,
                      ),
                      onPressed: () {
                        _flutterTts.speak(message['text']!);
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

  List<TextSpan> _buildTextSpans(String text) {
    if (_currentWordStart == null || _currentWordEnd == null) {
      return [TextSpan(text: text)];
    }

    final List<TextSpan> spans = [];
    spans.add(TextSpan(
      text: text.substring(0, _currentWordStart),
    ));
    spans.add(TextSpan(
      text: text.substring(_currentWordStart!, _currentWordEnd),
      style: const TextStyle(
        backgroundColor: Colors.purpleAccent,
      ),
    ));
    spans.add(TextSpan(
      text: text.substring(_currentWordEnd!),
    ));

    return spans;
  }
}
