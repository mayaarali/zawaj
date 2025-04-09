import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/features/setup_account/data/repository/setup_repository.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/event.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/states.dart';

class CityBloc extends Bloc<SetUpEvent, SetUpStates> {
  SetUpRepositoryImp setupRepositoryImp;

  static CityBloc get(context) => BlocProvider.of(context);

  CityBloc({required this.setupRepositoryImp}) : super(InitStates());

  getCity() async {
    emit(GetCityLoading());
    var response = await setupRepositoryImp.getCity();
    response.fold((failure) {
      emit(GetCityFailed(failure));
    }, (model) {
      emit(GetCitySuccess(model));
    });
  }
}
