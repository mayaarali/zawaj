class ChatMessage {
  final int messageId;
  final String senderId;
  final String recipientId;
  final int chatId;
  final String content;
  final bool isActive;
  final int isChatEnded;
  final int daysToEnd;
  final DateTime sentAt;

  ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.recipientId,
    required this.chatId,
    required this.content,
    required this.sentAt,
    required this.isActive,
    required this.isChatEnded,
    required this.daysToEnd,
  });
}

class ChatData {
  final DateTime chatCreatedAt;
  final bool isUserDeleted;

  final List<ChatMessage> messages;

  ChatData({
    required this.chatCreatedAt,
    required this.isUserDeleted,
    required this.messages,
  });
}
