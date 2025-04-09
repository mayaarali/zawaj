import 'package:easy_localization/easy_localization.dart';
import 'package:zawaj/core/constants/strings.dart';

class Validator {
  static String? validateName(value) {
    if (value.isEmpty) {
      return ('ادخل الاسم').tr();
    } else {
      return null;
    }
  }

  static String? validateBio(value) {
    if (value == null || value.trim().isEmpty) {
      return "لا يمكن ان تكون الخانة فارغة".tr();
    } else if (value.length > 100) {
      return ('يجب ان لا تزيد عن 100 حرف ').tr();
    } else {
      return null;
    }
  }

// static String? validateParams(value) {
//   if (value.toInt() < (0)) {
//     return (' ادخل قيمة مناسبة').tr();
//   } else {
//     return null;
//   }
// }

  static String? validateParams(value) {
    int? parsedValue = int.tryParse(value);
    if (parsedValue != null && parsedValue < 0) {
      return 'ادخل قيمة مناسبة'.tr();
    } else {
      return null;
    }
  }

  static String? validateParamsRange(value) {
    int? parsedValue = int.tryParse(value);
    if (parsedValue != null && (parsedValue < 0 || parsedValue > 200)) {
      return 'ادخل قيمة مناسبة '.tr();
    } else {
      return null;
    }
  }

  static String? validatePhone(value) {
    String pattern = r'(^[0-9]+$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'ادخل رقم الهاتف';
    } else if (!regExp.hasMatch(value)) {
      return 'يجب أن يكون الهاتف أرقامًا';
    } else if (!(value.length == 10)) {
      return 'يجب أن يكون رقم الهاتف مكون من 10 أرقام';
    } else {
      return null;
    }
  }

  static String? validateEmail(value) {
    // String pattern=
    //   r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    //RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return ('ادخل البريد الإلكتروني').tr();
    } else if (value.length < 6) {
      return 'بريد إلكتروني خاطئ'.tr();
    } else if (value.length > 45) {
      return 'بريد إلكتروني خاطئ'.tr();
    } else if (!value.contains('@') && !value.contains('.com')) {
      return 'بريد إلكتروني خاطئ'.tr();
    } else {
      return null;
    }
  }

  static String? isNameValid(value) {
    final pattern = RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$');
    if (!pattern.hasMatch(value)) {
      return 'ادخل اسم مناسب';
    }
    if (value.length > 40) {
      return 'اسم طويل جدا !';
    } else {
      return null;
    }
  }

  static String? validatePassword(value) {
    if (value.isEmpty) {
      return 'أدخل كلمة المرور'.tr();
    } else if (value.length < 8) {
      return 'كلمة المرور يجب أن تكون أكثر من 8'.tr();
    } else {
      return null;
    }
  }

  static String? validateEmpty(value) {
    if (value.isEmpty) {
      return "لا يمكن ان تكون الخانة فارغة".tr();
    } else {
      return null;
    }
  }

  static String? validateEmptyValues(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "لا يمكن ان تكون الخانة فارغة".tr();
    } else {
      return null;
    }
  }

  static String? validateConfirmPass(pass, confirm) {
    if (confirm.isEmpty) {
      return "لا يمكن ان تكون الخانة فارغة".tr();
    } else if (pass != confirm) {
      return "كلمة مرور خاطئة".tr();
    } else {
      return null;
    }
  }

  static String? validatePayementCard(value) {
    if (value.isEmpty) {
      return Strings.enterPayCard.tr();
    }
    // else if (value.length < 16 || value.length > 16) {
    //   return Strings.enterValidPayCard.tr();
    // } else {
    //   return null;
    // }
  }

  static String? expiryCardDate(value) {
    if (value.isEmpty) {
      return "It Can't be empty".tr();
    } else if (value < DateTime.now().toString()) {
      return Strings.enterValidPayCard.tr();
    } else {
      return null;
    }
  }
}
