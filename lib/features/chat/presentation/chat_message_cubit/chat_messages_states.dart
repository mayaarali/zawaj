import 'package:zawaj/features/chat/data/model/chat_messages_model.dart';

class ChatMessagesState {}

class ChatMessagesLoadingState extends ChatMessagesState {}

class ChatMessagesErrorState extends ChatMessagesState {
  final String error;

  ChatMessagesErrorState(this.error);
}

class ChatMessagesLoadedState extends ChatMessagesState {
  final ChatData chatData;

  ChatMessagesLoadedState(this.chatData);
}

class MessageDeletedLoading extends ChatMessagesState {}

class MessageDeleted extends ChatMessagesState {}

class MessageDeletionError extends ChatMessagesState {}
