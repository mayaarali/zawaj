import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zawaj/core/blocs/connectivity/states.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/theme/theme.dart';
import 'package:zawaj/core/widgets/no_internet_screen.dart';
import 'package:zawaj/features/dashboard/view.dart';
import 'package:zawaj/features/splash/view.dart';
import 'core/blocs/connectivity/bloc.dart';
import 'core/blocs/connectivity/events.dart';
import 'core/blocs/language/language_cubit.dart';
import 'core/blocs/language/language_states.dart';
import 'core/helper/app_providers.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    OneSignal.Notifications.addClickListener((event) {
      log('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: ${event.notification.additionalData!['UserId']}');
      CacheHelper.setData(
          key: Strings.userId,
          value: event.notification.additionalData!['UserId'] ?? '');
      if (event.notification.additionalData!['NotificationType'] == ['Likes']) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => const DashBoardScreen(
              initialIndex: 3,
            ),
          ),
        );
      } else if (event.notification.additionalData!['NotificationType'] ==
          ['Messages']) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => const DashBoardScreen(
              initialIndex: 1,
            ),
          ),
        );
      } else if (event.notification.additionalData!['NotificationType'] ==
          ['NewMatching']) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => const DashBoardScreen(
              initialIndex: 2,
            ),
          ),
        );
      } else if (event.notification.additionalData!['NotificationType'] ==
          ['Birthday']) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => const DashBoardScreen(
              initialIndex: 2,
            ),
          ),
        );
      }
      log('NOTIFICATION CLICK on');
    });
    return MultiBlocProvider(
      providers: [
        ...AppProviders.get(context),
        BlocProvider<ConnectivityBloc>(create: (context) => ConnectivityBloc()
            //  ..add(ListenConnectivity()),
            ),
      ],
      child: BlocConsumer<ConnectivityBloc, ConnectivityState>(
        listener: (context, state) {
          // You can add side-effects here if needed, like showing a dialog or logging
        },
        builder: (context, state) {
          log(state.toString()); // Log the current connectivity state
          print(
              '******************************************no internet*************************************');

          // Check for disconnected state and show the CheckInternetConnection screen
          if (state is InternetDisconnected) {
            return MaterialApp(
              home: const CheckInternetConnection(),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              navigatorKey: navigatorKey,
              showSemanticsDebugger: false,
              theme: themeData,
              debugShowCheckedModeBanner: false,
            );
          }
          // Check for connected state and show the app's normal content
          else if (state is InternetConnected) {
            return BlocConsumer<LanguageCubit, LanguageState>(
              listener: (context, state) {
                // Handle any side-effects for language changes if needed
              },
              builder: (context, state) {
                return MaterialApp(
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  navigatorKey: navigatorKey,
                  showSemanticsDebugger: false,
                  theme: themeData,
                  debugShowCheckedModeBanner: false,
                  home: const SplashView(),
                );
              },
            );
          } else {
            return MaterialApp(
              home: const CheckInternetConnection(),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              navigatorKey: navigatorKey,
              showSemanticsDebugger: false,
              theme: themeData,
              debugShowCheckedModeBanner: false,
            );
          }
        },
      ),
    );
  }
}
