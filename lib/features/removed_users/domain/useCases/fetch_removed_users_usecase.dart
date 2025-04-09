import 'package:zawaj/features/removed_users/domain/entities/removed_user_entity.dart';
import 'package:zawaj/features/removed_users/domain/repositories/removed_users_repository.dart';

class FetchUsersUseCase {
  final RemovedUsersRepository userRepository;

  FetchUsersUseCase(this.userRepository);

  Future<List<RemovedUsersEntity>> execute(int page) async {
    try {
      return await userRepository.fetchUsers(page);
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }
}
