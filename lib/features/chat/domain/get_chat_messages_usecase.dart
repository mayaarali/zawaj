import 'package:zawaj/features/chat/data/model/chat_messages_model.dart';
import 'package:zawaj/features/chat/domain/chat_message_repository.dart';

class GetChatMessagesDataUseCase {
  final ChatMessagesRepository _repository;

  GetChatMessagesDataUseCase(this._repository);

  Future<ChatData> call(String user2Id,
      {int page = 1, int pageSize = 10}) async {
    return await _repository.fetchChatData(user2Id,
        page: page, pageSize: pageSize);
  }
}
