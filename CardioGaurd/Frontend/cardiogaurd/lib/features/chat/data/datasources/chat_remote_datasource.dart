import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message_entity.dart';

abstract class ChatRemoteDataSource {
  Stream<List<MessageEntity>> getMessages(String chatId, String currentUserId);
  Future<void> sendMessage(String chatId, MessageEntity message);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<MessageEntity>> getMessages(String chatId, String currentUserId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      try {
        return snapshot.docs.map((doc) {
          final data = Map<String, dynamic>.from(doc.data());
          data['id'] = doc.id;
          return MessageEntity.fromFirestore(data, currentUserId);
        }).toList();
      } catch (e) {
        print('Error parsing chat messages: $e');
        return [];
      }
    });
  }

  @override
  Future<void> sendMessage(String chatId, MessageEntity message) async {

    await _firestore.collection('chats').doc(chatId).set({
      'lastMessage': message.text,
      'lastTimestamp': FieldValue.serverTimestamp(),
      'participants': [message.senderId, message.receiverId],
    }, SetOptions(merge: true));

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toFirestore());
  }
}
