part of 'consultant_bloc.dart';

abstract class ConsultantState {}

final class ConsultantInitial extends ConsultantState {}

class ConsultantLoading extends ConsultantState {}

class ConsultantSuccess extends ConsultantState {
  List<ConsultantModel> consultantList = [];
  ConsultantSuccess(this.consultantList);
}

class ConsultantLoaded extends ConsultantState {
  List<ConsultantModel> consultantLoadedList = [];
  ConsultantLoaded(this.consultantLoadedList);
}

class ConsultantFailed extends ConsultantState {
  String message;
  ConsultantFailed({required this.message});
}

class ClickConsultantLoading extends ConsultantState {}

class ClickConsultantSuccess extends ConsultantState {
  String message;

  ClickConsultantSuccess({required this.message});
}

class ClickConsultantFailed extends ConsultantState {
  String message;
  ClickConsultantFailed({required this.message});
}

class CallConsultant extends ConsultantState {}
