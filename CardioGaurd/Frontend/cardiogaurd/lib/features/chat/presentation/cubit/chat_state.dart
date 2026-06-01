part of 'chat_cubit.dart';

class ChatState extends Equatable {
  final List<MessageEntity> messages;

  const ChatState({required this.messages});

  factory ChatState.initial() {
    return const ChatState(
      messages: [],
    );
  }

  ChatState copyWith({
    List<MessageEntity>? messages,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object> get props => [messages];
}
