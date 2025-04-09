
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setData({
    @required String? key,
    @required dynamic value,
  }) async {
    if (value is bool) {
      return await sharedPreferences!.setBool(key!, value);
    } else if (value is String) {
      return await sharedPreferences!.setString(key!, value);
    } else if (value is int) {
      return await sharedPreferences!.setInt(key!, value);
    }else if (value is List<String>){
      return await sharedPreferences!.setStringList(key!, value);
    } else {
      return await sharedPreferences!.setDouble(key!, value);
    }

  }

  static dynamic getData({
    @required String? key,
  }) {
    return sharedPreferences!.get(key!);
  }

  static Future<bool> removeData({
    @required String? key,
  }) async {
    return await sharedPreferences!.remove(key!);
  }

  static bool containData({
    @required String? key,
  }) {
    return  sharedPreferences!.containsKey(key!);
  }


  // static setUserData(User data){
  //   return setData(key: Strings.USER, value: jsonEncode(data.toJson()));
  // }
  //
  // static User? getUserData(){
  //   if(getData(key: Strings.USER) != null){
  //     Map<String, dynamic> list = jsonDecode(getData(key: Strings.USER));
  //     return User.fromJson(list);
  //   }else{
  //     return null;
  //   }
  // }

// Remove All Data
  static removeAllData() async {
    await sharedPreferences?.clear();
  }


}


