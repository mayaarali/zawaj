import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/features/resend_email_otp/domain/entities/resend_email_otp_response.dart';
import 'package:zawaj/features/resend_email_otp/domain/use_cases/resend_email_otp_usecase.dart';

part 'resend_email_otp_state.dart';

class ResendEmailOtpCubit extends Cubit<ResendEmailOtpState> {
  final ResendEmailOtpUseCase resendOtp;

  ResendEmailOtpCubit(this.resendOtp) : super(OtpInitial());

  Future<void> resendOtpCubit() async {
    emit(OtpLoading());

    final result = await resendOtp();

    result.fold(
      (failure) => emit(OtpFailure(failure.toString())),
      (otpResponse) => emit(OtpSuccess(otpResponse)),
    );
  }
}