import 'package:zawaj/features/resend_email_otp/data/datasource/resend_email_otp_remote_datasource.dart';
import 'package:zawaj/features/resend_email_otp/domain/entities/resend_email_otp_response.dart';
import 'package:zawaj/features/resend_email_otp/domain/repositories/resend_email_otp_repository.dart';

class ResendEmailOtpRepositoryImpl implements ResendEmailOtpRepository {
  final ResendEmailOtpRemoteDataSource remoteDataSource;

  ResendEmailOtpRepositoryImpl({required this.remoteDataSource});

  @override
  Future<OtpResponse> resendOtp() async {
    return remoteDataSource.resendOtp();
  }
}