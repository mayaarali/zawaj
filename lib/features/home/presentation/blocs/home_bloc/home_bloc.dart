import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/features/home/data/models/home_model.dart';
import 'package:zawaj/features/home/data/repository/home_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepositoryImp homeRepositoryImp;
  static HomeBloc get(context) => BlocProvider.of(context);

  HomeBloc({required this.homeRepositoryImp}) : super(HomeInitial()) {}
  HomeModel? homeModel;
  List<HomeModel> homeModelList = [];
  getHomeData() async {
    emit(HomeLoading());
    var response = await homeRepositoryImp.getPartnerData();
    print(response);
    print("hoooome blooccc");
    response.fold((failure) {
      emit(HomeFailure(message: failure));
    }, (homeList) {
      homeModelList = homeList;
      emit(HomeSuccess(homeList));
      print("hooome successs");
    });
  }

  //////////////////for chat///////////////////
  Future<void> fetchHomeData(int page) async {
    emit(HomeLoading());
    var response = await homeRepositoryImp.getPartnerData(page: page);
    response.fold(
      (failure) => emit(HomeFailure(message: failure)),
      (homeList) {
        homeModelList.addAll(homeList);
        emit(HomeSuccess(homeModelList));
      },
    );
  }

  Future<void> fetchAllHomeData() async {
    for (int i = 1; i <= 10; i++) {
      await fetchHomeData(i);
    }
  }
}
