part of 'send_report_bloc.dart';

abstract class SendReportEvent {}

class SentEvent extends SendReportEvent {
  String userId;

  SentEvent({
    required this.userId,
  });
}
