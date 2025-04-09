class Chat {
  final int chatId;
  final int isPinned;
  final int isChatOpen;
  final String userId;
  final String lastMessage;
  final String userName;
  final String lastMessageTime;
  final bool lastMessageState;
  final int unseenMessages;
  final List<String> userImages;

  Chat({
    required this.chatId,
    required this.userId,
    required this.isPinned,
    required this.isChatOpen,
    required this.lastMessage,
    required this.userName,
    required this.lastMessageTime,
    required this.unseenMessages,
    required this.userImages,
    required this.lastMessageState,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatId: json['chatId'] ?? '',
      isPinned: json['isPinned'] ?? '',
      userId: json['userId'] ?? '',
      isChatOpen: json['isChatOpen'] ?? '',
      lastMessageState: json['lastMessageState'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      userName: json['userName'] ?? '',
      lastMessageTime: json['lastMessageTime'] ?? '',
      unseenMessages: json['unseenMessages'] ?? 0,
      userImages: (json['userImages'] != null && json['userImages'] is List)
          ? List<String>.from(json['userImages'])
          : [],
    );
  }
}
