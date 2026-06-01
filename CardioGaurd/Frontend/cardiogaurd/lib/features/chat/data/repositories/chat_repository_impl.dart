import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<MessageEntity>> getMessages(String chatId, String currentUserId) {
    return remoteDataSource.getMessages(chatId, currentUserId);
  }

  @override
  Future<void> sendMessage(String chatId, MessageEntity message) {
    return remoteDataSource.sendMessage(chatId, message);
  }
}
