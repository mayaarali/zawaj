part of 'verify_bloc.dart';

abstract class VerifyState {}

final class VerifyInitial extends VerifyState {}

final class VerifyLoading extends VerifyState {}

class AddImages extends VerifyState {}

final class VerifySuccess extends VerifyState {
  final String message;
  VerifySuccess({required this.message});
}

final class VerifyFailure extends VerifyState {
  final String message;
  VerifyFailure({required this.message});
}
