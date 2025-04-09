import 'package:zawaj/features/chat/data/data_source/chat_messages_dataSource.dart';
import 'package:zawaj/features/chat/data/model/chat_messages_model.dart';
import 'package:zawaj/features/chat/domain/chat_message_repository.dart';

class ChatMessagesRepositoryImpl implements ChatMessagesRepository {
  final ChatDataProvider dataProvider;

  ChatMessagesRepositoryImpl(this.dataProvider);

  @override
  Future<ChatData> fetchChatData(String user2Id,
      {int page = 1, int pageSize = 10}) async {
    final Map<String, dynamic> rawData = await dataProvider
        .fetchChatData(user2Id, page: page, pageSize: pageSize);
    return ChatData(
      chatCreatedAt: DateTime.parse(rawData['chatCreatedAt']),
      isUserDeleted: rawData['isUserDeleted'],
      messages: (rawData['messages'] as List)
          .map((msg) => ChatMessage(
                messageId: msg['messageId'],
                senderId: msg['senderId'],
                recipientId: msg['recipientId'],
                chatId: msg['chatId'],
                content: msg['content'],
                isActive: msg['isActive'],
                sentAt: DateTime.parse(msg['sentAt']),
                isChatEnded: msg['isChatEnded'],
                daysToEnd: msg['daysToEnd'],
              ))
          .toList(),
    );
  }
}
