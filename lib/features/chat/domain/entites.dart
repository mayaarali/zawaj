class ChatMessage {
  final int messageId;
  final String senderId;
  final String recipientId;
  final String content;
  final DateTime sentAt;

  ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.recipientId,
    required this.content,
    required this.sentAt,
  });
}

class ChatData {
  final DateTime chatCreatedAt;
  final List<ChatMessage> messages;

  ChatData({
    required this.chatCreatedAt,
    required this.messages,
  });
}
