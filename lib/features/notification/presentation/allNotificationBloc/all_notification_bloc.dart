import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/features/notification/data/repository/whoLike_repo.dart';
import 'package:zawaj/features/notification/presentation/whoLikedMe_bloc/who_like_me_bloc.dart';

class AllNotificationBloc extends Bloc<WhoLikeMeEvent, WhoLikeMeState> {
  static AllNotificationBloc get(context) => BlocProvider.of(context);
  WhoLikedMeRepositoryImp whoLikedMeRepositoryImp;
  AllNotificationBloc({required this.whoLikedMeRepositoryImp})
      : super(WhoLikeMeInitial()) {
    on<AllNotificationEvent>((event, emit) async {
      emit(AllNotificationLoading());
      var response = await whoLikedMeRepositoryImp.getNotification();
      response.fold((failure) {
        emit(AllNotificationFailure(mesaage: failure));
      }, (notificationModel) {
        emit(AllNotificationSuccess(notificationModel));
      });
    });
  }
}
