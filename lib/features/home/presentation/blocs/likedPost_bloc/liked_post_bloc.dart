import 'package:bloc/bloc.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/features/home/data/repository/home_repo.dart';
import '../home_bloc/home_bloc.dart';

class LikedPostBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepositoryImp homeRepositoryImp;
  bool isLoading = false;

  LikedPostBloc({required this.homeRepositoryImp}) : super(HomeInitial()) {
    on<LikePostEvent>((event, emit) async {
      isLoading = true;
      // emit(IsLoading());

      emit(IsLikedPostLoading());

      var response =
          await homeRepositoryImp.isLikedPost(userId: event.userId.toString());
      response.fold((failure) {
        isLoading = false;
        emit(IsLikedPostFailure(message: failure));
      }, (message) {
        isLoading = false;
        emit(IsLikedPostSuccess(message: Strings.youLiked));
      });
    });

    on<DisLikePostEvent>((event, emit) async {
      isLoading = true;
      emit(IsDisLikedPostLoading());
      var response = await homeRepositoryImp.isDisLikedPost(
          userId: event.userId.toString());
      response.fold((failure) {
        isLoading = false;
        emit(IsLikedPostFailure(message: failure));
      }, (message) {
        isLoading = false;

        emit(IsLikedPostSuccess(message: Strings.youDisLiked));
      });
    });

    on<RemoveUserEvent>((event, emit) async {
      emit(RemoveUserLoading());
      var response =
          await homeRepositoryImp.removeUser(userId: event.userId.toString());
      response.fold((failure) {
        emit(RemoveUserFailure(message: failure));
      }, (message) {
        emit(RemoveUserSuccess(message: Strings.youDelete));
      });
    });
  }
}
