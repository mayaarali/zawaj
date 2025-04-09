import 'package:zawaj/features/removed_users/data/datasSource/removed_users_reomte_datasource.dart';
import 'package:zawaj/features/removed_users/data/models/removed_users_model.dart';
import 'package:zawaj/features/removed_users/domain/entities/removed_user_entity.dart';
import 'package:zawaj/features/removed_users/domain/repositories/removed_users_repository.dart';

class UserRepositoryImpl implements RemovedUsersRepository {
  final RemovedUsersRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<RemovedUsersEntity>> fetchUsers(int page) async {
    try {
      final List<Map<String, dynamic>> userData =
          await remoteDataSource.fetchUsers(page);
      return userData
          .map((json) => RemovedUsersModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }
}

