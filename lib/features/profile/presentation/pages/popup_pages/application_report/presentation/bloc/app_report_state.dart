abstract class AppReportState {}

final class AppReportInitial extends AppReportState {}

final class AppReportLoading extends AppReportState {}

final class AppReportSuccess extends AppReportState {
  final String message;
  AppReportSuccess({required this.message});
}

final class AppReportFailed extends AppReportState {
  final String message;
  AppReportFailed({required this.message});
}
