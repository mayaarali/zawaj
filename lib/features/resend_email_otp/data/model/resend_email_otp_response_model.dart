import 'package:zawaj/features/resend_email_otp/domain/entities/resend_email_otp_response.dart';

class OtpResponseModel extends OtpResponse {
  OtpResponseModel({required bool success, required String message}) 
    : super(success: success, message: message);

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      success: json['success'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}