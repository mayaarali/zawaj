import 'package:dartz/dartz.dart';
import 'package:zawaj/features/resend_email_otp/domain/entities/resend_email_otp_response.dart';
import 'package:zawaj/features/resend_email_otp/domain/repositories/resend_email_otp_repository.dart';

class ResendEmailOtpUseCase {
  final ResendEmailOtpRepository repository;

  ResendEmailOtpUseCase(this.repository);

  Future<Either<Exception, OtpResponse>> call() async {
    try {
      final result = await repository.resendOtp();
      return Right(result);
    } catch (e) {
      return Left(Exception('Failed to resend OTP'));
    }
  }
}