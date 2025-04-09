part of 'consultant_bloc.dart';

abstract class ConsultantEvent {}

class GetCEvent extends ConsultantEvent {}

class ClickConsultantEvent extends ConsultantEvent {
  int consultantId;
  ClickConsultantEvent({required this.consultantId});
}
