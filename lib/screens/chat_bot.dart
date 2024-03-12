import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talk_takt_gp/cubits/ChatBotCubit%20.dart';
import 'package:talk_takt_gp/widgets/chat_messages.dart';
import 'package:talk_takt_gp/widgets/voice_recognition.dart';

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
  late ChatBotCubit _chatBotCubit;

  @override
  void initState() {
    super.initState();
    _chatBotCubit = ChatBotCubit();
    _chatBotCubit.initializeSpeechToText();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _chatBotCubit.close();
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
          BlocBuilder<ChatBotCubit, ChatBotState>(
            builder: (context, state) {
              if (state == ChatBotState.listening) {
                // Add UI for listening state
                return CircularProgressIndicator();
              } else if (state == ChatBotState.error) {
                // Add UI for error state
                return Text('Error occurred');
              } else {
                // Add UI for other states
                return VoiceRecognition(
                  controller: _controller,
                  isTyping: isTyping,
                  startListening: _chatBotCubit.startListening,
                  scrollController: _scrollController,
                  onSend: _handleSendMessage,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _handleSendMessage(String userMessage, bool isTyping) {
    setState(() {
      _controller.clear();
      _messages.add({'text': userMessage, 'sender': 'user'});
      String botResponse = userMessage; // Update with actual bot response
      _messages.add({'text': botResponse, 'sender': 'bot'});
      isTyping = false; // Reset typing state
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }
}
