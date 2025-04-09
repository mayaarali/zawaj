import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/send_report/data/repos/send_report_repo.dart';

part 'send_report_event.dart';
part 'send_report_state.dart';

class SendReportBloc extends Bloc<SendReportEvent, SendReportState> {
  static SendReportBloc get(context) => BlocProvider.of(context);
  SendReportRepositortyImp sendReportRepositortyImp;
  TextEditingController userController = TextEditingController();
  TextEditingController reportController = TextEditingController();
  SendReportBloc({required this.sendReportRepositortyImp})
      : super(SendReportInitial()) {
    on<SentEvent>((event, emit) async {
      emit(SendReportLoading());
      //String token = await CacheHelper.getData(key: Strings.token);
      // final HomeModel homeModel;
      //  int? userId = homeModel.id;
      var response = await sendReportRepositortyImp.sendReport(
        userId: event.userId,
        reason: reportController.text,
        reportMessage: reportController.text,
        userName: reportController.text,
      );
      response.fold((failure) {
        emit(SendReportFailed(message: failure));
      }, (message) {
        emit(SendReportSuccess(message: message));
      });
    });
  }
}
