import 'package:cloud_firestore/cloud_firestore.dart';

class MessageEntity {
  final String id;
  final String text;
  final DateTime timestamp;
  final String senderId;
  final String receiverId;
  final bool isMe;

  MessageEntity({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.senderId,
    required this.receiverId,
    required this.isMe,
  });

  factory MessageEntity.fromFirestore(Map<String, dynamic> data, String currentUserId) {
    return MessageEntity(
      id: data['id'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      isMe: data['senderId'] == currentUserId,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'senderId': senderId,
      'receiverId': receiverId,
    };
  }
}