import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/features/favorites/data/repository/favorites_repo.dart';
import 'package:zawaj/features/home/data/models/home_model.dart';

part 'favorites_post_event.dart';
part 'favorites_post_state.dart';

class LikedPartnersBloc extends Bloc<LikedPartnersEvent, LikedPartnersStates> {
  static LikedPartnersBloc get(context) => BlocProvider.of(context);
  LikedPartnersRepositoryImp likedPartnersRepositoryImp;

  List<HomeModel> homeModel = [];
  int currentPage = 1;
  bool isLoadingMore = false;

  LikedPartnersBloc({required this.likedPartnersRepositoryImp})
      : super(LikedPartnersInitial()) {
    on<LoadLikedPartnersEvent>((event, emit) async {
      emit(LikedPartnersLoading());

      if (isLoadingMore) return;

      isLoadingMore = true;

      var response =
          await likedPartnersRepositoryImp.likedPartners(page: event.page);
      print(response);
      response.fold((failure) {
        emit(LikedPartnersFailed(message: failure));
        isLoadingMore = false;
      }, (fetchedModels) {
        // homeModel = [];
        log('iam in eveeeeeeeeeent');
        log(fetchedModels.length.toString());
        log(homeModel.length.toString());
        if (event.isReset == true) {
          homeModel = [];
        }
        for (var model in fetchedModels) {
          if (!homeModel.any((existing) => existing.userId == model.userId)) {
            homeModel.add(model);
          }
        }
        log('iam in eveeeeeeeeeent');
        log(fetchedModels.length.toString());
        log(homeModel.length.toString());
        emit(LikedPartnersSuccess(homeModel));
        isLoadingMore = false;
      });
    });
  }

  void loadMore() {
    currentPage++;
    add(LoadLikedPartnersEvent(currentPage));
  }

  void loadPrevious() {
    if (currentPage > 1) {
      currentPage--;
      add(LoadLikedPartnersEvent(currentPage));
    }
  }
}
