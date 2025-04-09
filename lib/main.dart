import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zawaj/app.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'core/helper/bloc_observer.dart';
import 'core/helper/cache_helper.dart';
import 'core/helper/dio_helper.dart';
import 'injection_controller.dart' as di;
// import 'package:flutter/services.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tzdata;

void main() async {
  //tzdata.initializeTimeZones();
  // String currentTimezone = tz.getLocation(DateTime.now().toString()).name;
  // print(
  //     '.........................................Current timezone: $currentTimezone');
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await EasyLocalization.ensureInitialized();
  await CacheHelper.init();
  await di.init();
  await DioHelper.init();

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  try {
    //OneSignal.initialize("a6f1788f-895f-497b-8258-01e30133c60b");
    OneSignal.initialize("30b87e9d-8b0d-4e52-8764-850cb0f0391f");
    await OneSignal.Notifications.requestPermission(true);
    //OneSignal.User.getOnesignalId()

    String? id2 = OneSignal.User.pushSubscription.token;
    String? id = OneSignal.User.pushSubscription.id;
    String? id3 = await OneSignal.User.getOnesignalId();

    log('id333333 is $id3');
    log('id is $id');
    log('id222222 is $id2');

    CacheHelper.setData(key: Strings.DEVICEID, value: id ?? 'fake');

    // String? id2;
    id2 = OneSignal.User.pushSubscription.id;
  } catch (e) {
    log('kkkkkkkkkkkkkkkkkkkkkkkkk$e');
  }

  OneSignal.User.pushSubscription.addObserver((state) {
    log("ussssserId22");

    ///print(id2);
    log("ussssserId");
    log(OneSignal.User.pushSubscription.optedIn.toString());
    log(OneSignal.User.pushSubscription.id.toString());
    log(OneSignal.User.pushSubscription.token.toString());
    log(state.current.jsonRepresentation());
    CacheHelper.setData(
        key: Strings.DEVICEID,
        value: OneSignal.User.pushSubscription.id ?? 'fake');
    log('device id in observer:' + CacheHelper.getData(key: Strings.DEVICEID));
  });
  log("AFTER ABSERVER");
  log(CacheHelper.getData(
    key: Strings.DEVICEID,
  ));

  String? id2 = OneSignal.User.pushSubscription.token;
  String? id = OneSignal.User.pushSubscription.id;
  String? id3 = await OneSignal.User.getOnesignalId();

  log('id333333 is $id3');
  log('id is $id');
  log('id222222 is $id2');
  String? deviceId = await CacheHelper.getData(
    key: Strings.DEVICEID,
  );
  if (deviceId == null || deviceId == '' || deviceId == 'fake') {
    await CacheHelper.setData(
        key: Strings.DEVICEID,
        value: OneSignal.User.pushSubscription.id ?? 'fake');

    log('device id: ${CacheHelper.getData(key: Strings.DEVICEID)}');
  }
  log("AFTER Condition");
  log(CacheHelper.getData(
    key: Strings.DEVICEID,
  ));

  // id2 = OneSignal.User.pushSubscription.id;

//OneSignal.Notifications.addForegroundWillDisplayListener((event) {
//  print('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');
//  print('NOTIFICATION CLICK Foreground');
//  navigatorKey.currentState?.push(
//    MaterialPageRoute(
//      builder: (context) => DashBoardScreen(
//        initialIndex: 1,
//      ),
//    ),
//  );
//});
  // Add this line to lock the orientation to portrait mode only
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //await SignalR.connectAndStart();
  //await SignalRService.connectAndStart();
  //CacheHelper.removeAllData();
  Bloc.observer = SimpleBlocObserver();
  EasyLocalization.logger.enableBuildModes = [];
  runApp(EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/languages', // <-- change the path of the translation files
      fallbackLocale: const Locale('ar', ''),
      startLocale: const Locale('ar', ''),
      child: const MyApp()));
}
