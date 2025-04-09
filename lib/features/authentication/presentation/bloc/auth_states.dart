class AuthStates {}

class GetSecure extends AuthStates {
  bool isSecure;
  GetSecure(this.isSecure);
}

class InitStates extends AuthStates {}

class LoadingAuth extends AuthStates {}

class SocialLoginFail extends AuthStates {}

class GoogleLoginFail extends AuthStates {}

class LoadingAuthOtp extends AuthStates {}

class SuccessAuthOtp extends AuthStates {
  String message;
  SuccessAuthOtp({required this.message});
}

class AuthFailed extends AuthStates {
  String message;
  AuthFailed({required this.message});
}

class AuthSuccess extends AuthStates {
  String message;
  AuthSuccess({required this.message});
}

class LogOutFailed extends AuthStates {
  String message;
  LogOutFailed({required this.message});
}

class LogOutSuccess extends AuthStates {
  String message;
  LogOutSuccess({required this.message});
}

class RegisterSuccess extends AuthStates {
  String message;
  RegisterSuccess({required this.message});
}

class ConfirmEmailSuccess extends AuthStates {
  String message;
  ConfirmEmailSuccess({required this.message});
}

class ConfirmEmailFailed extends AuthStates {
  String message;
  ConfirmEmailFailed({required this.message});
}

class DeleteAccountSuccess extends AuthStates {
  String message;
  DeleteAccountSuccess({required this.message});
}

class ChangePasswordSuccess extends AuthStates {
  String message;
  ChangePasswordSuccess({required this.message});
}

class SendEmailLoadingAuth extends AuthStates {}

class SendEmailSuccess extends AuthStates {
  String message;
  SendEmailSuccess({required this.message});
}

class SendEmailFailed extends AuthStates {
  String message;
  SendEmailFailed({required this.message});
}

class SendPhoneSuccess extends AuthStates {
  String message;
  SendPhoneSuccess({required this.message});
}

class SendPhoneFailed extends AuthStates {
  String message;
  SendPhoneFailed({required this.message});
}

class ResetPasswordLoadingAuth extends AuthStates {}

class ResetPasswordSuccess extends AuthStates {
  String message;
  ResetPasswordSuccess({required this.message});
}

class ResetPasswordFailed extends AuthStates {
  String message;
  ResetPasswordFailed({required this.message});
}

class CheckOTPLoadingAuth extends AuthStates {}

class CheckOTPSuccess extends AuthStates {
  String message;
  CheckOTPSuccess({required this.message});
}

class CheckOTPFailed extends AuthStates {
  String message;
  CheckOTPFailed({required this.message});
}

class CompleteRegisterSuccess extends AuthStates {
  String message;
  CompleteRegisterSuccess({required this.message});
}

class CompleteRegisterFailed extends AuthStates {
  String message;
  CompleteRegisterFailed({required this.message});
}

class ImageCamera extends AuthStates {}

class ImageGallery extends AuthStates {}
