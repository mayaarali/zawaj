abstract class AuthEvent {}

class RegisterEvent extends AuthEvent {
  // String email, pass,phone,name,confirmPass;
  RegisterEvent();
}

class LoginEvent extends AuthEvent {
  String email, pass;
  LoginEvent({required this.email, required this.pass});
}

class SocialLoginEvent extends AuthEvent {
  //String id, type;
  SocialLoginEvent(
      //{required this.id, required this.type}
      );
}

class FacebookLoginEvent extends AuthEvent {
  FacebookLoginEvent();
}

class SocialRegisterEvent extends AuthEvent {
  String id, type, name, email;
  SocialRegisterEvent(
      {required this.name,
      required this.email,
      required this.id,
      required this.type});
}

class OtpEvent extends AuthEvent {
  String otp, email;
  OtpEvent({required this.otp, required this.email});
}

class ConfirmEmail extends AuthEvent {}

class ConfirmPhone extends AuthEvent {}

class CompleteRegister extends AuthEvent {}

class ReEnterPassEvent extends AuthEvent {
  String otp, email, pass, confirmPass;
  ReEnterPassEvent(
      {required this.otp,
      required this.email,
      required this.confirmPass,
      required this.pass});
}

class UpdateProfileEvent extends AuthEvent {
  String name, email, pass, confirmPass;
  String? avatar;
  UpdateProfileEvent(
      {required this.name,
      required this.email,
      required this.confirmPass,
      required this.pass,
      this.avatar});
}

class SendEmailEvent extends AuthEvent {}

class ResetPasswordEvent extends AuthEvent {}

class CheckOtpEvent extends AuthEvent {}

class LogOutEvent extends AuthEvent {}

class DeleteAccountEvent extends AuthEvent {}
