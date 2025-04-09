import 'package:bloc/bloc.dart';
import 'package:zawaj/features/home/data/repository/home_repo.dart';
import 'package:zawaj/features/home/presentation/blocs/home_bloc/home_bloc.dart';

class PartnerDetailsBloc extends Bloc<PartnerDetailsEvent, HomeState> {
  HomeRepositoryImp homeRepositoryImp;
  PartnerDetailsBloc({required this.homeRepositoryImp})
      : super(PartnerDetailsInitial());
  getPartnerDetails() async {
    emit(PartnerDetailsLoading());
    var response = await homeRepositoryImp.getPartnerData();
    print(response);
    response.fold((failure) {
      emit(PartnerDetailsFailure(message: failure));
    }, (homeList) {
      emit(PartnerDetailsSuccess(homeList));
    });
  }
}
