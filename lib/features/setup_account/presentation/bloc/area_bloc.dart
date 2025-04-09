import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/features/setup_account/data/repository/setup_repository.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/event.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/states.dart';

class AreaBloc extends Bloc<AreaEvent, SetUpStates> {
  SetUpRepositoryImp setupRepositoryImp;

  static AreaBloc get(context) => BlocProvider.of(context);

  AreaBloc({required this.setupRepositoryImp}) : super(InitStates()) {
    on<AreaEvent>((event, emit) async {
      emit(GetAreaLoading());
      print('befoooreeee response');
      var response = await setupRepositoryImp.getArea(cityId: event.cityId);
      print(response);
      response.fold((failure) {
        emit(GetAreaFailed(failure));
      }, (model) {
        emit(GetAreaSuccess(model));
      });
    });
  }
}
