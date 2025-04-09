import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:zawaj/features/removed_users/domain/entities/removed_user_entity.dart';
import 'package:zawaj/features/removed_users/domain/useCases/fetch_removed_users_usecase.dart';

part 'removed_user_state.dart';

class UserCubit extends Cubit<RemovedUsersState> {
  final FetchUsersUseCase fetchUsersUseCase;
  int currentPage = 1;
  List<RemovedUsersEntity> users = [];
  bool isLoadingMore = false;

  UserCubit(this.fetchUsersUseCase) : super(RemovedUsersInitial());

  Future<void> fetchUsers({bool loadMore = false}) async {
    if (!loadMore) {
      emit(RemovedUsersLoading());
    } else {
      isLoadingMore = true;
      emit(RemovedUsersLoaded(users));
    }

    try {
      final List<RemovedUsersEntity> fetchedUsers =
          await fetchUsersUseCase.execute(currentPage);
      if (loadMore) {
        users.addAll(fetchedUsers);
      } else {
        users = fetchedUsers;
      }
      emit(RemovedUsersLoaded(users));
      if (users.isNotEmpty) {
        currentPage++;
      }
    } catch (e) {
      emit(RemovedUsersError('Failed to fetch users: $e'));
    } finally {
      if (loadMore) {
        isLoadingMore = false;
      }
    }
  }
}
