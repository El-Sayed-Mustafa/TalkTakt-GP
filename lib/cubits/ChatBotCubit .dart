import 'package:bloc/bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

enum ChatBotState { initial, listening, error, success }

class ChatBotCubit extends Cubit<ChatBotState> {
  ChatBotCubit() : super(ChatBotState.initial);

  final stt.SpeechToText _speech = stt.SpeechToText();

  void initializeSpeechToText() {
    _speech.initialize(
      onStatus: (status) {
        print('Speech recognition status: $status');
      },
      onError: (errorNotification) {
        print('Speech recognition error: $errorNotification');
        emit(ChatBotState.error);
      },
    );
  }

  Future<void> startListening() async {
    emit(ChatBotState.listening);

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
          emit(ChatBotState.error);
        },
      );

      if (available) {
        _speech.listen(
          onResult: (result) {
            emit(ChatBotState.success);
          },
        );
      } else {
        print('Speech recognition not available');
        emit(ChatBotState.error);
      }
    } else {
      // Microphone permission denied
      print('Microphone permission denied');
      emit(ChatBotState.error);
    }
  }
}
