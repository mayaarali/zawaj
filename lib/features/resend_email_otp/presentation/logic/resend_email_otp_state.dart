part of 'resend_email_otp_cubit.dart';

abstract class ResendEmailOtpState extends Equatable {
  const ResendEmailOtpState();

  @override
  List<Object> get props => [];
}

class OtpInitial extends ResendEmailOtpState {}

class OtpLoading extends ResendEmailOtpState {}

class OtpSuccess extends ResendEmailOtpState {
  final OtpResponse otpResponse;

  const OtpSuccess(this.otpResponse);

  @override
  List<Object> get props => [otpResponse];
}

class OtpFailure extends ResendEmailOtpState {
  final String error;

  const OtpFailure(this.error);

  @override
  List<Object> get props => [error];
}