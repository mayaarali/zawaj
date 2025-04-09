import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/features/home/data/models/home_model.dart';
import 'package:zawaj/features/notification/data/models/notificationModel.dart';
import 'package:zawaj/features/notification/data/repository/whoLike_repo.dart';

part 'who_like_me_event.dart';
part 'who_like_me_state.dart';

class WhoLikeMeBloc extends Bloc<WhoLikeMeEvent, WhoLikeMeState> {
  static WhoLikeMeBloc get(context) => BlocProvider.of(context);
  WhoLikedMeRepositoryImp whoLikedMeRepositoryImp;
  WhoLikeMeBloc({required this.whoLikedMeRepositoryImp})
      : super(WhoLikeMeInitial()) {
    on<WhoLikeMeEvent>((event, emit) async {
      emit(WhoLikeMeLoading());
      var response = await whoLikedMeRepositoryImp.whoLikedMe();
      response.fold((failure) {
        emit(WhoLikeMeFailure(mesaage: failure));
      }, (homeModel) {
        emit(WhoLikeMeSuccess(homeModel));
      });
    });
  }
}
