import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/strings.dart';
import '../../helper/cache_helper.dart';
import 'language_states.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(InitLanguageState());
  static LanguageCubit get(context) => BlocProvider.of(context);
  bool isEnglish = false;
  bool isArabic = true;

  isSelected(BuildContext context, val) async{
    if (val == true) {
      isArabic = false;
      isEnglish = true;
      context.setLocale(const Locale('en'));
     await CacheHelper.setData(key: Strings.language, value: 'en');
      emit(SelectLanguage());
    } else {
      isEnglish = false;
      isArabic = true;
      context.setLocale(const Locale('ar'));
      await CacheHelper.setData(key: Strings.language, value: 'ar');
      emit(SelectLanguage());
    }
  }
}
