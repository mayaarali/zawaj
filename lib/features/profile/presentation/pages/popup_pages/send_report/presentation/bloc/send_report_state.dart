part of 'send_report_bloc.dart';

abstract class SendReportState {}

final class SendReportInitial extends SendReportState {}

final class SendReportLoading extends SendReportState {}

final class SendReportSuccess extends SendReportState {
  final String message;
  SendReportSuccess({required this.message});
}

final class SendReportFailed extends SendReportState {
  final String message;
  SendReportFailed({required this.message});
}
