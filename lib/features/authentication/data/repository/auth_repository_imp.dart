import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/helper/api_error_handler.dart';
import '../../../../core/helper/cache_helper.dart';
import '../../../../core/network/network_info.dart';
import '../data_source/auth_datasource_imp.dart';

class AuthRepositoryImp {
  AuthDataSourceImp authDataSourceImp;
  NetworkInfo networkInfo;
  AuthRepositoryImp(
      {required this.authDataSourceImp, required this.networkInfo});
  Future<Either<String, String>> login({
    required String email,
    required String password,
    required String deviceId,
  }) async {
    if (await networkInfo.isConnected) {
      print('in looooogin func');
      try {
        Response response =
            await authDataSourceImp.login(email: email, password: password);
        // RegisterModel registerResponse = RegisterModel.fromJson(response.data);
        print('reeeeespoooonse login========${response.data}');

        if (response.statusCode == 200) {
          //CacheHelper.setUserData(registerResponse.user!);
          CacheHelper.setData(
              key: Strings.token, value: response.data['token']);
          CacheHelper.setData(
              key: Strings.emailConfirmed,
              value: response.data['emailConfirmed']);
          CacheHelper.setData(
              key: Strings.phoneConfirmed,
              value: response.data['phoneConfirmed']);
          CacheHelper.setData(
              key: Strings.verificationState,
              value: response.data['verificationState']);
          CacheHelper.setData(
              key: Strings.hasSetup, value: response.data['hasSetup']);
          CacheHelper.setData(
              key: Strings.hasRequired,
              value: response.data['hasReuiredSpecification']);
          CacheHelper.setData(
              key: Strings.isSubscribed,
              value: response.data['isSubscribed'] ?? false);
          return const Right(Strings.login_success);
        } else {
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      print('nooooooooooooo internet}');

      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, String>> register({
    required String email,
    required String password,
    required String deviceId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await authDataSourceImp.register(
          email: email,
          password: password,
        );
        print('sign up respoonse');
        if (response.statusCode == 200) {
          print('20000000');
          print(response.data);
          CacheHelper.setData(
              key: Strings.token, value: response.data['token']);
          CacheHelper.setData(key: Strings.emailConfirmed, value: false);
          CacheHelper.setData(key: Strings.phoneConfirmed, value: false);
          return const Right(Strings.regigestersuccessfully);
        } else {
          print('not 2000000');
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        print('DioException');

        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, String>> completeRegister({
    required String name,
    required String phoneNumber,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await authDataSourceImp.completeRegister(
            name: name, phoneNumber: phoneNumber);

        if (response.statusCode == 200) {
          print('============>200');

          return const Right(Strings.regigestersuccessfully);
        } else {
          print('not 2000000');
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        print('DioException');

        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, String>> socialLogin(
      {required String email,
      required String name,
      required String uniqueId,
      required String deviceId,
      required String providerPlatform}) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await authDataSourceImp.socialLogin(
          email: email,
          name: name,
          uniqueId: uniqueId,
          providerPlatform: providerPlatform,
        );

        if (response.statusCode == 200) {
          print('============>200');
          print(response.data);
          CacheHelper.setData(
              key: Strings.token, value: response.data['token']);
          CacheHelper.setData(
              key: Strings.hasSetup, value: response.data['hasSetup']);
          CacheHelper.setData(
              key: Strings.hasRequired,
              value: response.data['hasReuiredSpecification']);
          CacheHelper.setData(
              key: Strings.isSubscribed,
              value: response.data['isSubscribed'] ?? false);
          CacheHelper.setData(
              key: Strings.phoneConfirmed,
              value: response.data['phoneConfirmed']);
          CacheHelper.setData(
              key: Strings.verificationState,
              value: response.data['verificationState']);
          CacheHelper.setData(key: Strings.Name, value: name);
          CacheHelper.setData(key: Strings.emailConfirmed, value: true);
          //  CacheHelper.setData(key: Strings.phoneConfirmed, value: true);
          return const Right(Strings.regigestersuccessfully);
        } else {
          print('not 2000000');
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        print('DioException');

        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, String>> logOut() async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await authDataSourceImp.logOut();

        if (response.statusCode == 200) {
          print('logout done');
          print(response);
          return const Right(Strings.regigestersuccessfully);
        } else {
          print('not 2000000');
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        print('DioException');

        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, String>> sendEmail({
    required String value,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await authDataSourceImp.sendEmail(
          value: value,
        );

        if (response.statusCode == 200) {
          print('============>200');

          return const Right(Strings.regigestersuccessfully);
        } else {
          print('not 2000000');
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        print('DioException');

        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, String>> confirmEmail({
    required String otp,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await authDataSourceImp.verifyEmail(
          otp: otp,
        );

        if (response.statusCode == 200) {
          print('============>200');
          //CacheHelper.setData( key: Strings.token, value: response.data['token']);
          CacheHelper.setData(key: Strings.emailConfirmed, value: true);
          CacheHelper.setData(key: Strings.phoneConfirmed, value: false);
          return const Right(Strings.regigestersuccessfully);
        } else {
          print('not 2000000');
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        print('DioException');

        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, String>> confirmPhone({
    required String otp,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await authDataSourceImp.verifyPhone(
          otp: otp,
        );

        if (response.statusCode == 200) {
          print('============>200');

          CacheHelper.setData(key: Strings.emailConfirmed, value: true);
          CacheHelper.setData(key: Strings.phoneConfirmed, value: true);
          return const Right(Strings.regigestersuccessfully);
        } else {
          print('not 2000000');
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        print('DioException');

        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, String>> resetPassword({
    required String password,
    required String confirmPassword,
    required String code,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        print('innnnnnnnnnnnnn repooooooooooooooo');
        Response response = await authDataSourceImp.resetPassword(
          password: password,
          confirmPassword: confirmPassword,
          code: code,

          //CacheHelper.getData(key: Strings.otpToken),
        );

        if (response.statusCode == 200) {
          print('============>200');
          print(response);
          return const Right(Strings.regigestersuccessfully);
        } else {
          print('not 2000000');
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        print('DioException');

        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, String>> checkOtp({
    required String code,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await authDataSourceImp.checkOtp(
          code: code,
        );

        if (response.statusCode == 200) {
          print('============>200');

          print(response);
          CacheHelper.setData(
              key: Strings.otpToken, value: response.data['token']);

          return const Right(Strings.regigestersuccessfully);
        } else {
          print('not 2000000');
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        print('DioException');

        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  //
  // Future<Either<String, String>> socialLogin({required String id,
  //   required String type}) async {
  //   if(await networkInfo.isConnected){
  //
  //     try{
  //       Response response = await authDataSourceImp.socialLogin(type: type,id:id);
  //       RegisterModel registerResponse = RegisterModel.fromJson(response.data);
  //
  //       if(response.statusCode == 200 ){
  //         CacheHelper.setUserData(registerResponse.user!);
  //         CacheHelper.setData(key: AppConstants.token,value: registerResponse.token);
  //         GlobalData().setToken(registerResponse.token??"");
  //
  //         return  const Right(Strings.regigestersuccessfully);
  //       }
  //       else{
  //         return Left(ApiExceptionHandler.getMessage(response));
  //       }
  //     }on DioException catch(error){
  //       return Left(ApiExceptionHandler.getMessage(error));
  //     }
  //   }else{
  //     return const Left(Strings.nointernet);
  //   }
  // }
  //
  //
  // Future<Either<String, String>> socialRegister({required String email,required String name,required String id,
  //   required String type}) async {
  //   if(await networkInfo.isConnected){
  //
  //     try{
  //       Response response = await authDataSourceImp.socialRegister(email: email, name: name,type: type,id:id);
  //       RegisterModel registerResponse = RegisterModel.fromJson(response.data);
  //
  //       if(response.statusCode == 200 ){
  //         CacheHelper.setUserData(registerResponse.user!);
  //         CacheHelper.setData(key: AppConstants.token,value: registerResponse.token);
  //         GlobalData().setToken(registerResponse.token??"");
  //         return  const Right(Strings.regigestersuccessfully);
  //       }
  //       else{
  //         return Left(ApiExceptionHandler.getMessage(response));
  //       }
  //     }on DioException catch(error){
  //       return Left(ApiExceptionHandler.getMessage(error));
  //     }
  //   }else{
  //     return const Left(Strings.nointernet);
  //   }
  // }
  //
  // Future<Either<String, String>> reEnterPassord({required String email,required String otp,
  //   required String pass,required String confirmPass}) async {
  //   if(await networkInfo.isConnected){
  //
  //     try{
  //       Response response = await authDataSourceImp.reenterPass(email,otp,pass,confirmPass);
  //      // RegisterModel registerResponse = RegisterModel.fromJson(response.data);
  //         debugPrint('forget pass response===>${response}');
  //       if(response.statusCode == 200 ){
  //        // CacheHelper.setUserData(registerResponse.user!);
  //        //CacheHelper.setData(key: AppConstants.token,value: registerResponse.token);
  //         //GlobalData().setToken(registerResponse.token??"");
  //         return   Right(response.data['message']);
  //       }
  //       else{
  //         return Left(ApiExceptionHandler.getMessage(response));
  //       }
  //     }on DioException catch(error){
  //       return Left(ApiExceptionHandler.getMessage(error));
  //     }
  //   }else{
  //     return const Left(Strings.nointernet);
  //   }
  // }
  //
  // Future<Either<String, String>> checkOtp({required String email,required String otp}) async {
  //   if(await networkInfo.isConnected){
  //
  //     try{
  //       Response response = await authDataSourceImp.checkOtp(email,otp);
  //        RegisterModel registerResponse = RegisterModel.fromJson(response.data);
  //       debugPrint('otp response===>${response}');
  //       if(response.statusCode == 200 ){
  //         // CacheHelper.setUserData(registerResponse.user!);
  //         CacheHelper.setData(key: AppConstants.token,value: registerResponse.token);
  //        GlobalData().setToken(registerResponse.token??"");
  //         return  const Right(Strings.otpsuccessfully);
  //       }
  //       else{
  //         return Left(ApiExceptionHandler.getMessage(response));
  //       }
  //     }on DioException catch(error){
  //       return Left(ApiExceptionHandler.getMessage(error));
  //     }
  //   }else{
  //     return const Left(Strings.nointernet);
  //   }
  // }
  //
  //
  //
  //
  // Future<Either<String, String>> updateProfile({required String email,required String name,required String password,
  //   required String confirmPassword, String? avatar}) async {
  //   if(await networkInfo.isConnected){
  //
  //     try{
  //       Response response = await authDataSourceImp.updateProfile(email:email,name:name,avatar: avatar,
  //           password:password,confirmPassword: confirmPassword);
  //      // RegisterModel registerResponse = RegisterModel.fromJson(response.data);
  //       debugPrint('profile response===>${response}');
  //       if(response.statusCode == 200 ){
  //         CacheHelper.setUserData(User(name:name ,email:email ));
  //         //CacheHelper.setData(key: AppConstants.token,value: registerResponse.token);
  //        // GlobalData().setToken(registerResponse.token??"");
  //
  //         return   Right(response.data['message']??'');
  //       }
  //       else{
  //         return Left(ApiExceptionHandler.getMessage(response));
  //       }
  //     }on DioException catch(error){
  //       return Left(ApiExceptionHandler.getMessage(error));
  //     }
  //   }else{
  //     return const Left(Strings.nointernet);
  //   }
  // }
  //
  //
  // // Future<String> reEnterPassord(String email, String otp, String password,
  // //     String passwordConfirmation) async {
  // //   Response response =
  // //   await DioHelper().postData(url: EndPoints.reEnterPass, data: {
  // //     "email": email,
  // //     "otp": otp,
  // //     "password": password,
  // //     "password_confirmation": passwordConfirmation
  // //   });
  // //   print(response.data);
  // //   return response.data["message"];
  // // }
  //
  // Future<Either<String, String>> deleteAccount() async {
  //   if(await networkInfo.isConnected){
  //
  //     try{
  //       Response response = await authDataSourceImp.deleteAccount();
  //
  //       debugPrint('delete account response===>${response}');
  //       if(response.statusCode == 200 ){
  //
  //         return   Right(response.data['message']??'');
  //       }
  //       else{
  //         return Left(ApiExceptionHandler.getMessage(response));
  //       }
  //     }on DioException catch(error){
  //       return Left(ApiExceptionHandler.getMessage(error));
  //     }
  //   }else{
  //     return const Left(Strings.nointernet);
  //   }
  // }
}
