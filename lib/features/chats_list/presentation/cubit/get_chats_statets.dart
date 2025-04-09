import 'package:equatable/equatable.dart';
import 'package:zawaj/features/chats_list/data/model/chats_model.dart';

abstract class ChatsState extends Equatable {
  const ChatsState();

  @override
  List<Object> get props => [];
}

class ChatsInitial extends ChatsState {}

class ChatsLoading extends ChatsState {}

class ChatsLoaded extends ChatsState {
  final List<Chat> chats;

  const ChatsLoaded(this.chats);

  @override
  List<Object> get props => [chats];
}

class ChatsError extends ChatsState {
  final String message;

  const ChatsError(this.message);

  @override
  List<Object> get props => [message];
}
