import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:talk_takt_gp/grammer_hint.dart';

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

  @override
  void initState() {
    super.initState();
    initTTS();
  }

  void initTTS() {
    _flutterTts.setProgressHandler((text, start, end, word) {
      // Handle progress updates if needed
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
    return Container(
      color: const Color.fromARGB(1, 249, 249, 249),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: widget.messages.length * 2,
          itemBuilder: (context, index) {
            final int messageIndex = index ~/ 2;
            final bool isMessage = index % 2 == 0;

            if (isMessage) {
              final message = widget.messages[messageIndex];
              final isUser = message['sender'] == 'user';

              return Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: widget.maxMessageWidth,
                          ),
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.blue : Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: const [
                              // gry shadwo
                              BoxShadow(
                                color: Colors.black, // Shadow color
                                offset:
                                    Offset(0, 2), // changes position of shadow
                                blurRadius: 4, // changes spread of shadow
                              ),
                            ],
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
                            padding: const EdgeInsets.all(0),
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
                  ),
                  if (isUser)
                    GrammarHint(
                      userMessage: message['text']!,
                    ),
                ],
              );
            } else {
              return const SizedBox(height: 8.0);
            }
          },
        ),
      ),
    );
  }
}
