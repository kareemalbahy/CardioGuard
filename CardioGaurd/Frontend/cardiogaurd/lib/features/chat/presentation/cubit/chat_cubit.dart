import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cardiogaurd/features/chat/domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;
  StreamSubscription? _subscription;

  ChatCubit(this.repository) : super(ChatState.initial());

  void initChat(String chatId, String currentUserId) {
    _subscription?.cancel();
    _subscription = repository.getMessages(chatId, currentUserId).listen(
      (messages) {
        emit(state.copyWith(messages: messages));
      },
      onError: (error) {
        print('ChatCubit Error: $error');
      },
    );
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    final message = MessageEntity(
      id: '',
      text: text.trim(),
      timestamp: DateTime.now(),
      senderId: senderId,
      receiverId: receiverId,
      isMe: true,
    );

    try {
      await repository.sendMessage(chatId, message);
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
