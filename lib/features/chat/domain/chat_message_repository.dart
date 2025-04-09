import 'package:zawaj/features/chat/data/model/chat_messages_model.dart';

abstract class ChatMessagesRepository {
  Future<ChatData> fetchChatData(String user2Id, {int page, int pageSize});
}
