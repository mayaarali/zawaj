import 'package:dartz/dartz.dart';
import 'package:zawaj/features/chats_list/data/model/chats_model.dart';
import 'package:zawaj/features/chats_list/data/repository/repository_impl.dart';

class GetChats {
  final ChatRepository repository;

  GetChats(this.repository);

  Future<Either<Exception, List<Chat>>> call() async {
    try {
      final chats = await repository.getChats();
      return Right(chats);
    } catch (e) {
      return Left(Exception('Failed to load chats $e'));
    }
  }
}