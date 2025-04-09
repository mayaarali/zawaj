import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/cache_helper.dart';

import '../../data/repository/auth_repository_imp.dart';
import 'auth_event.dart';
import 'auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthStates> {
  static AuthBloc get(context) => BlocProvider.of(context);
  AuthRepositoryImp authRepositoryImp;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController resetPassController = TextEditingController();
  TextEditingController confirmationEmailController = TextEditingController();
  TextEditingController oTPController = TextEditingController();
  TextEditingController verifyEmailOtpController = TextEditingController();
  TextEditingController verifyPhoneOtpController = TextEditingController();
  bool isFailed = false;
  bool isLoading = false;

  AuthBloc({required this.authRepositoryImp}) : super(InitStates()) {
    on<LoginEvent>((event, emit) async {
      emit(LoadingAuth());
      String? deviceId = await CacheHelper.getData(key: Strings.DEVICEID);
      var response = await authRepositoryImp.login(
        email: event.email,
        password: event.pass,
        deviceId: deviceId ?? 'fake',
      );
      response.fold((failure) {
        emit(AuthFailed(message: failure));
      }, (message) {
        emit(AuthSuccess(message: message));
      });
    });

    on<RegisterEvent>((event, emit) async {
      emit(LoadingAuth());
      String? deviceId = await CacheHelper.getData(key: Strings.DEVICEID);
      var response = await authRepositoryImp.register(
        email: emailController.text,
        password: passwordController.text,
        //  confirmPassword: confirmPassController.text,
        //   phone: phoneController.text,
        //   userName: nameController.text,
        deviceId: deviceId ?? 'fake',
      );
      response.fold((failure) {
        emit(AuthFailed(message: failure));
      }, (message) {
        emit(RegisterSuccess(message: Strings.login_success));
      });
    });

    on<SocialLoginEvent>((event, emit) async {
      try {
        String? deviceId = await CacheHelper.getData(key: Strings.DEVICEID);

        emit(LoadingAuth());
        final googleSignIn = GoogleSignIn();
        final googleUser = await googleSignIn.signIn();
        final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

        if (googleUser != null) {
          final googleAuth = await googleUser.authentication;

          if (googleAuth.idToken != null) {
            var userCredential = await _firebaseAuth.signInWithCredential(
              GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken,
              ),
            );
            var uniqueId = userCredential.user!.uid;
            var name = userCredential.user!.displayName;

            var email = userCredential.user!.email;
            var providerPlatform = userCredential.credential!.providerId;
            var response = await authRepositoryImp.socialLogin(
              email: email!,
              name: name!,
              uniqueId: uniqueId,
              providerPlatform: providerPlatform,
              deviceId: deviceId ?? '',
            );

            response.fold((failure) {
              emit(AuthFailed(message: failure));
              googleSignIn.signOut(); // Sign out the user from Google
            }, (message) {
              emit(AuthSuccess(message: Strings.login_success));
            });
          }
        } else {
          throw FirebaseAuthException(
            message: "Sign-in aborted by user",
            code: "ERROR_ABORTED_BY_USER",
          );
        }
      } catch (e) {
        if (e is FirebaseAuthException && e.code == "ERROR_ABORTED_BY_USER") {
          emit(GoogleLoginFail());
        } else {
          // Handle other exceptions
          // ...
        }
      }
    });

    on<FacebookLoginEvent>((event, emit) async {
      try {
        emit(LoadingAuth());
        String? deviceId = await CacheHelper.getData(key: Strings.DEVICEID);

        final LoginResult loginResult = await FacebookAuth.instance.login();
        if (loginResult.status == LoginStatus.success) {
          final accessToken = loginResult.accessToken!;
          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(accessToken.token);
          final userData = await FacebookAuth.instance
              .getUserData(fields: 'email, id, name');
          final email = userData['email'];
          final id = userData['id'];
          final name = userData['name'];

          var response = await authRepositoryImp.socialLogin(
            email: email,
            name: name,
            uniqueId: id,
            providerPlatform: facebookAuthCredential.providerId,
            deviceId: deviceId ?? 'fake',
          );
          response.fold((failure) {
            emit(AuthFailed(message: failure));
          }, (message) {
            emit(AuthSuccess(message: Strings.login_success));
          });
        } else if (loginResult.status == LoginStatus.cancelled) {
          throw FirebaseAuthException(
            message: "Sign-in aborted by user",
            code: "ERROR_ABORTED_BY_USER",
          );
        } else {
          throw FirebaseAuthException(
            message: "Error occurred during Facebook sign-in",
            code: "ERROR_FACEBOOK_SIGN_IN",
          );
        }
      } catch (e) {
        if (e is FirebaseAuthException) {
          emit(SocialLoginFail());
        } else {
          // Handle other exceptions
          // ...
        }
      }
    });

    on<SendEmailEvent>((event, emit) async {
      emit(LoadingAuth());
      var response = await authRepositoryImp.sendEmail(
          value: confirmationEmailController.text);
      response.fold((failure) {
        emit(SendEmailFailed(message: failure));
      }, (message) {
        emit(SendEmailSuccess(message: message));
      });
    });

    on<ConfirmEmail>((event, emit) async {
      emit(LoadingAuth());
      var response = await authRepositoryImp.confirmEmail(
          otp: verifyEmailOtpController.text);
      response.fold((failure) {
        emit(ConfirmEmailFailed(message: failure));
      }, (message) {
        emit(ConfirmEmailSuccess(message: message));
      });
    });

    on<ConfirmPhone>((event, emit) async {
      emit(LoadingAuth());
      var response = await authRepositoryImp.confirmPhone(
          otp: verifyPhoneOtpController.text);
      response.fold((failure) {
        emit(SendPhoneFailed(message: failure));
      }, (message) {
        emit(SendPhoneSuccess(message: message));
      });
    });

    on<LogOutEvent>((event, emit) async {
      emit(LoadingAuth());
      var response = await authRepositoryImp.logOut();
      response.fold((failure) {
        emit(LogOutFailed(message: failure));
      }, (message) {
        emit(LogOutSuccess(message: message));
      });
    });

    on<CompleteRegister>((event, emit) async {
      isLoading = true;
      emit(LoadingAuth());
      var response = await authRepositoryImp.completeRegister(
          name: nameController.text, phoneNumber: phoneController.text);
      response.fold((failure) {
        isLoading = false;

        emit(CompleteRegisterFailed(message: failure));
      }, (message) {
        isLoading = false;

        emit(CompleteRegisterSuccess(message: message));
        CacheHelper.setData(key: Strings.Name, value: nameController.text);
      });
    });

    CacheHelper.setData(key: Strings.Name, value: nameController.text);

    on<ResetPasswordEvent>((event, emit) async {
      emit(ResetPasswordLoadingAuth());
      var response = await authRepositoryImp.resetPassword(
        password: resetPassController.text,
        confirmPassword: resetPassController.text,
        code: CacheHelper.getData(key: Strings.otpToken),
      );
      response.fold((failure) {
        emit(ResetPasswordFailed(message: failure));
      }, (message) {
        emit(ResetPasswordSuccess(message: Strings.resetPassDone));
      });
    });

    String failedMsg = '';
    on<CheckOtpEvent>((event, emit) async {
      isFailed = false;
      emit(CheckOTPLoadingAuth());
      var response = await authRepositoryImp.checkOtp(
        code: oTPController.text,
      );
      response.fold((failure) {
        isFailed = true;
        failedMsg = failure;
        emit(CheckOTPFailed(message: failure));
        // isFailed = false;
        //emit(CheckOTPFailed(message: failure));
      }, (message) {
        isFailed = false;
        emit(CheckOTPSuccess(message: Strings.resetPassDone));
      });
      isFailed = false;
    });

/*
    on<SocialLoginEvent>((event, emit) async {
      emit(LoadingAuth());
      final googleSignIn = GoogleSignIn();
        final googleUser = await googleSignIn.signIn();
          final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

      var response = await authRepositoryImp.socialLogin(
          email: '', name: '', uniqueId: '', socialToken: '');
      response.fold((failure) {
        emit(AuthFailed(message: failure));
      }, (message) {
        emit(AuthSuccess(message: message));
      });
    });
    */

    // on<SocialRegisterEvent>((event, emit) async {
    //   emit(LoadingAuth());
    //   var response = await authRepositoryImp.socialRegister(
    //     id: event.id,
    //     type: event.type,
    //     email: event.email,
    //     name: event.name,
    //   );
    //   response.fold((failure) {
    //     emit(AuthFailed(message: failure));
    //   }, (message) {
    //     emit(AuthSuccess(message: message));
    //   });
    // });
    // on<OtpEvent>((event, emit) async {
    //   emit(LoadingAuthOtp());
    //   var response = await authRepositoryImp.checkOtp(
    //     email: event.email,
    //     otp: event.otp,
    //   );
    //   response.fold((failure) {
    //     emit(AuthFailed(message: failure));
    //   }, (message) {
    //     emailController.clear();
    //     otpController.clear();
    //     passwordController.clear();
    //     emit(SuccessAuthOtp(message: message));
    //
    //   });
    // });
    //
    //
    // on<ReEnterPassEvent>((event, emit) async {
    //   emit(LoadingAuth());
    //   var response = await authRepositoryImp.reEnterPassord(
    //
    //     email: event.email,
    //     otp: event.otp,
    //     pass: event.pass,
    //     confirmPass: event.confirmPass
    //
    //   );
    //   response.fold((failure) {
    //     emit(AuthFailed(message: failure));
    //   }, (message) {
    //     emit(ChangePasswordSuccess(message: message));
    //   });
    // });
    //
    // on<UpdateProfileEvent>((event, emit) async {
    //   emit(LoadingAuth());
    //   var response = await authRepositoryImp.updateProfile(
    //      avatar: event.avatar,
    //       email: event.email,
    //      name: event.name,
    //       password: event.pass,
    //       confirmPassword: event.confirmPass
    //
    //   );
    //   response.fold((failure) {
    //     emit(AuthFailed(message: failure));
    //   }, (message) {
    //     emit(ChangePasswordSuccess(message: message));
    //   });
    // });
    //
    // on<DeleteAccountEvent>((event, emit) async {
    //   emit(LoadingAuth());
    //   var response = await authRepositoryImp.deleteAccount();
    //   response.fold((failure) {
    //     emit(AuthFailed(message: failure));
    //   }, (message) {
    //     emit(DeleteAccountSuccess(message: message));
    //   });
    // });

    // });
  }

  PageController pageController = PageController(
    viewportFraction: 1,
    keepPage: true,
  );
  bool isSecure = true;
  getSecure() {
    isSecure = !isSecure;
    emit(GetSecure(isSecure));
  }

  var selectedImage;

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    final userData =
        await FacebookAuth.instance.getUserData(fields: 'email, id, name');
    final email = userData['email'];
    final id = userData['id'];
    final name = userData['name'];
    facebookAuthCredential.accessToken;
    facebookAuthCredential.idToken;
    facebookAuthCredential.providerId;
    print('accessToken');
    print(facebookAuthCredential.accessToken);
    print('idToken');
    print(facebookAuthCredential.idToken);
    print(facebookAuthCredential.providerId);
    print('email');
    print(email);
    print('id');
    print(id);
    print('name');
    print(name);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future signInWithGoogle() async {
////////////////////////////////////////////////////////////////////////////////////

    final googleSignIn = GoogleSignIn();
    // Trigger the authentication flow
    final googleUser = await googleSignIn.signIn();

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
        );
        print('userCredential.user');
        print('idToken');
        print(googleAuth.idToken);
        print('accessToken');
        print(googleAuth.accessToken);
        print('credential');
        print(userCredential.credential);
        print('userCredential.user');
        print(userCredential.user);
        print("userCredential.userId");
        print(userCredential.user!.uid);
        return userCredential;
      }
    } else {
      throw FirebaseAuthException(
        message: "Sign in aborded by user",
        code: "ERROR_ABORDER_BY_USER",
      );
    }
  }

  bool containsCapitalLetter(String value) {
    return value.contains(RegExp(r'[A-Z]'));
  }

  bool containsLowerLetter(String value) {
    return value.contains(RegExp(r'[A-Z]'));
  }

  bool containsSymbol(String value) {
    return value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  bool containsNum(String value) {
    return value.contains(RegExp(r'[0-9]'));
  }

  String resetPassowrdValidation(value) {
    if (value.isEmpty) {
      return "It Can't be empty".tr();
    } else if (value.length < 3) {
      return 'weak';
    } else if (value.length < 8) {
      return 'Password must be more than 8';
    } else if (!containsCapitalLetter(value) || !containsSymbol(value)) {
      return 'Password must contain at least one Uppercase letter and one symbol';
    } else if (!containsLowerLetter(value)) {
      return 'Password must contain at least one lowercase letter';
    } else if (!containsNum(value)) {
      return 'Password must contain at least one number';
    } else {
      return 'success';
    }
  }

  Color firstContainerColor = Colors.grey; // Default color: green
  Color secondContainerColor = Colors.grey;
  Color thirdContainerColor = Colors.grey;
  void setColor(String value) {
    if (value.isEmpty) {
      // Reset colors to default
      firstContainerColor = Colors.grey;
      secondContainerColor = Colors.grey;
      thirdContainerColor = Colors.grey;
      return;
    }
    String validationMessage = resetPassowrdValidation(value);
    if (validationMessage == 'weak') {
      firstContainerColor = ColorManager.primaryColor;
      secondContainerColor = Colors.grey;
      thirdContainerColor = Colors.grey;
    } else if (validationMessage == 'Password must be more than 8' ||
        validationMessage ==
            'Password must contain at least one Uppercase letter and one symbol' ||
        validationMessage ==
            'Password must contain at least one lowercase letter' ||
        validationMessage == 'Password must contain at least one number') {
      firstContainerColor = ColorManager.yellowColor;
      secondContainerColor = ColorManager.yellowColor;
      thirdContainerColor = Colors.grey;
    } else if (validationMessage == 'success') {
      firstContainerColor = ColorManager.greenColor;
      secondContainerColor = ColorManager.greenColor;
      thirdContainerColor = ColorManager.greenColor;
    }
  }
}
