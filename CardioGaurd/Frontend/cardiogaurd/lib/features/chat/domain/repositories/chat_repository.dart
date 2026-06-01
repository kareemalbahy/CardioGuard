import '../entities/message_entity.dart';

abstract class ChatRepository {
  Stream<List<MessageEntity>> getMessages(String chatId, String currentUserId);
  Future<void> sendMessage(String chatId, MessageEntity message);
}
