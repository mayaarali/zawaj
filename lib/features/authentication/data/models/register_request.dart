import 'package:flutter/cupertino.dart';

class RegisterRequest{

  var phoneNumber     = ValueNotifier<String?>("");
  var password        = ValueNotifier<String?>("");
  var userName        = ValueNotifier<String?>("");
  var confirmPassword = ValueNotifier<String?>("");
}