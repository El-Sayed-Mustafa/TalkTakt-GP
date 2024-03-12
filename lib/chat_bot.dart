import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:talk_takt_gp/chat_messages.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({Key? key}) : super(key: key);

  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool isTyping = false;
  final stt.SpeechToText _speech = stt.SpeechToText();

  @override
  void initState() {
    super.initState();
    _initializeSpeechToText();
  }

  void _initializeSpeechToText() {
    _speech.initialize(
      onStatus: (status) {
        print('Speech recognition status: $status');
      },
      onError: (errorNotification) {
        print('Speech recognition error: $errorNotification');
      },
    );
  }

  void _startListening() async {
    // Request microphone permission
    var status = await Permission.microphone.request();

    if (status == PermissionStatus.granted) {
      // Microphone permission granted, initialize and start speech recognition
      bool available = await _speech.initialize(
        onStatus: (status) {
          print('Speech recognition status: $status');
        },
        onError: (errorNotification) {
          print('Speech recognition error: $errorNotification');
        },
      );

      if (available) {
        _speech.listen(
          onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords;
            });
          },
        );
      } else {
        print('Speech recognition not available');
      }
    } else {
      // Microphone permission denied
      print('Microphone permission denied');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxMessageWidth = MediaQuery.of(context).size.width * 2 / 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TalkTakt'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessages(
              messages: _messages,
              maxMessageWidth: maxMessageWidth,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: (text) {
                      setState(() {
                        isTyping = text.isNotEmpty;
                      });
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12),
                    ),
                  ),
                ),
                IconButton(
                  icon: isTyping
                      ? const Icon(Icons.send)
                      : const Icon(Icons.keyboard_voice, size: 30),
                  onPressed: () {
                    setState(() {
                      if (isTyping) {
                        // Handle regular text input
                        String userMessage = _controller.text;
                        _controller.clear();
                        _messages.add({'text': userMessage, 'sender': 'user'});
                        String botResponse =
                            userMessage; // Update with actual bot response
                        _messages.add({'text': botResponse, 'sender': 'bot'});
                        isTyping = false; // Reset typing state
                      } else {
                        // Handle speech-to-text
                        _startListening();
                      }
                    });

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
