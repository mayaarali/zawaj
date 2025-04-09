import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import '../../../../core/constants/end_points.dart';
import '../../../../core/helper/dio_helper.dart';

class AuthDataSourceImp {
  @override
  DioHelper apiClientHelper;
  AuthDataSourceImp({required this.apiClientHelper});

  Future register({
    required String email,
    required String password,
    // required String userName,
    // required String phone,
    //  required String confirmPassword
  }) async {
    final deviceid = await CacheHelper.getData(key: Strings.DEVICEID);
    return apiClientHelper.postData(
        url: EndPoints.register,
        data: FormData.fromMap({
          //  "name": userName.trim(),
          "email": email.trim(),
          "password": password.trim(),
          //"phoneNumber": phone.trim(),
          // "ConfirmPassword": confirmPassword.trim(),
          "DeviceId": deviceid ?? '',
          "timeZone": DateTime.now().timeZoneName
        }));
  }

  Future login({required String email, required String password}) async {
    final deviceid = await CacheHelper.getData(key: Strings.DEVICEID);
    log('device id is $deviceid');
    return apiClientHelper.postData(url: EndPoints.login, data: {
      "email": email.trim(),
      "password": password.trim(),
      "deviceId": deviceid ?? '',
      "timeZone": DateTime.now().timeZoneName
    });
  }

  Future logOut() async {
    String? token = await CacheHelper.getData(key: Strings.token);
    return apiClientHelper.putData(url: EndPoints.logout, token: token);
  }

  Future verifyEmail({required String otp}) {
    return apiClientHelper.postData(
        url: EndPoints.confirmEmail, data: FormData.fromMap({"Otp": otp}));
  }

  Future verifyPhone({required String otp}) {
    return apiClientHelper.postData(
        url: EndPoints.confirmPhone, data: FormData.fromMap({"Otp": otp}));
  }

  Future completeRegister({required String name, required String phoneNumber}) {
    return apiClientHelper.putData(
        url: EndPoints.continueRegister,
        data: FormData.fromMap({"Name": name, "PhoneNumber": phoneNumber}));
  }

  Future sendEmail({required String value}) {
    return apiClientHelper
        .postData(url: EndPoints.sendEmail, data: {"value": value});
  }

  Future resetPassword({
    required String password,
    required String confirmPassword,
    required String code,
  }) {
    return apiClientHelper.postData(
        url: EndPoints.resetPassword,
        data: FormData.fromMap({
          "Token": code,
          "Password": password,
          "ConfirmPassword": confirmPassword,
        }));
  }

  Future checkOtp({
    required String code,
  }) {
    return apiClientHelper.postData(
        url: EndPoints.checkOtp,
        data: FormData.fromMap({
          "otp": code,
        }));
  }

  Future socialLogin({
    required String email,
    required String name,
    required String uniqueId,
    required String providerPlatform,
  }) async {
    final deviceid = await CacheHelper.getData(key: Strings.DEVICEID);

    return apiClientHelper.postData(
        url: EndPoints.socialLogin,
        data: FormData.fromMap({
          "Name": name.trim(),
          "Email": email.trim(),
          "UniqueId": uniqueId.trim(),
          "ProviderPlatform": providerPlatform.trim(),
          "DeviceId": deviceid ?? 'fake',
          "timeZone": DateTime.now().timeZoneName
        }));
  }
  // Future socialLogin({required String id,
  //   required String type}) async {
  //
  //   Map map={
  //
  //     "platform_type": type};
  //   if(type=='google'){
  //     map.addEntries({"google_id":id}.entries);
  //   }else{
  //     map.addEntries({"facebook_id":id}.entries);
  //   }
  //
  //
  //   return
  //     DioHelper().postData(url: EndPoints.socialLogin, data: map);
  //
  // }
  //
  // Future socialRegister({required String email,required String name,required  String id,
  //  required String type}) async {
  //   Map map={
  //     "email": email,
  //     "name": name,
  //     "register_type": type};
  //   if(type=='google'){
  //     map.addEntries({"google_id":id}.entries);
  //   }else{
  //     map.addEntries({"facebook_id":id}.entries);
  //   }
  //   print(map);
  //   print(socialRegister);
  //   return
  //     DioHelper().postData(url: EndPoints.socialRegister, data: map);
  //
  // }
  //
  // Future checkOtp(String email, String otp) async {
  //   Response response = await DioHelper()
  //       .postData(url: EndPoints.checkOtp, data: {"email": email, "otp": otp});
  //   print(response.data);
  //   return response;
  // }
  // Future deleteAccount() async {
  //   Response response = await DioHelper()
  //       .deleteData(url: EndPoints.delete_account,);
  //   print(response.data);
  //   return response;
  // }
  // Future reenterPass(String email, String otp,String password,String confirmPassword) async {
  //   Response response = await DioHelper()
  //       .putData(url: EndPoints.reEnterPass, data: {
  //         "email": email, "otp": otp,
  //         "password": password,
  //         "password_confirmation": confirmPassword
  //
  //
  //       });
  //   print(response.data);
  //   return response;
  // }
  //
  // Future updateProfile({required String email,required String name,required String password,
  //   required String confirmPassword, String? avatar}) async {
  //
  //
  //   FormData formData = FormData.fromMap({
  //     "email": email,
  //     "name": name,
  //
  //   });
  //   if(password!=''&&confirmPassword!=''){
  //     formData.fields.add(MapEntry('password', password));
  //     formData.fields.add(MapEntry('password_confirmation', confirmPassword));
  //   }
  //   if(avatar!=null){
  //     formData.files.add(MapEntry('avatar', await MultipartFile.fromFile(avatar)));
  //   }
  //   debugPrint('${email}=====${avatar}======${password}======${confirmPassword}=======${name}');
  //   Response response = await DioHelper()
  //       .postData(url: EndPoints.update_profile, data:formData );
  //   print(response.data);
  //   return response;
  // }
}
