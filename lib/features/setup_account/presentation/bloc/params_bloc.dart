import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/event.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/setup_bloc.dart';
import '../../data/models/params_model.dart';
import '../../data/repository/setup_repository.dart';
import 'states.dart';

class ParamsBloc extends Bloc<SetUpEvent, SetUpStates> {
  SetUpRepositoryImp setupRepositoryImp;

  static ParamsBloc get(context) => BlocProvider.of(context);

  ParamsBloc({required this.setupRepositoryImp}) : super(InitStates());
  List<ParamsModel> paramsList = [];

  getParams(context) async {
    emit(GetParamsLoading());
    var response = await setupRepositoryImp.getParams();
    response.fold((failure) {
      emit(GetParamsFailed(failure));
    }, (model) {
      paramsList = [];
      paramsList.addAll(model);
      SetUpBloc.get(context).dropValueList =
          List.filled(paramsList.length, null);
      SetUpBloc.get(context).dropValueBodyList =
          List.filled(paramsList.length, null);
      emit(GetParamsSuccess(model));
    });
  }
}
