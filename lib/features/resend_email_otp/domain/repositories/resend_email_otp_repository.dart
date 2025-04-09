import '../entities/resend_email_otp_response.dart';

abstract class ResendEmailOtpRepository {
  Future<OtpResponse> resendOtp();
}
