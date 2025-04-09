import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/application_report/data/repos/appReport_repository.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/application_report/presentation/bloc/app_report_state.dart';

part 'app_report_event.dart';

class AppReportBloc extends Bloc<AppReportEvent, AppReportState> {
  static AppReportBloc get(context) => BlocProvider.of(context);
  AppReportRepositortyImp appReportRepositortyImp;
  TextEditingController reportMessageController = TextEditingController();
  AppReportBloc({required this.appReportRepositortyImp})
      : super(AppReportInitial()) {
    on<AppReportEvent>((event, emit) async {
      emit(AppReportLoading());
      var response = await appReportRepositortyImp.appReport(
        message: reportMessageController.text,
      );
      response.fold((failure) {
        emit(AppReportFailed(message: failure));
      }, (message) {
        emit(AppReportSuccess(message: message));
      });
    });
  }
}
