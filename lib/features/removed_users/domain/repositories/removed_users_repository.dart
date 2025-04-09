import 'package:zawaj/features/removed_users/domain/entities/removed_user_entity.dart';

abstract class RemovedUsersRepository {
  Future<List<RemovedUsersEntity>> fetchUsers(int page);
}

