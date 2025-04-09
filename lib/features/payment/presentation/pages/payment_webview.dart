import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/dashboard/view.dart';
import 'package:zawaj/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zawaj/features/profile/presentation/pages/verification/presentation/verifing_request_sent_screen.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen(
      {Key? key, required this.userId, required this.isFromProfileScreen})
      : super(key: key);
  final String userId;
  final bool isFromProfileScreen;
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewXController webviewController;
  String? url = CacheHelper.getData(key: Strings.url);

  @override
  void initState() {
    super.initState();
    log('PaymentBloc.get(context).standardValuePayment==>${PaymentBloc.get(context).standardValuePayment}');
    ProfileBloc.get(context).getMyProfile();
    PaymentBloc.get(context).selectedPayIndex = -1;
    PaymentBloc.get(context).selectedStandardPayIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    final status = ProfileBloc.get(context).profileData?.verificationStatus;

    return CustomScaffold(
      child: SingleChildScrollView(
        child: BlocConsumer<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentLoading) {
              const LoadingCircle();
            }
            if (state is VerifyPaymentSuccess) {
              ProfileBloc.get(context).getMyProfile();

              // status == 'Pending'
              //     ? MagicRouter.navigateAndPopAll(
              //         const VerificationRequestSent())
              //     : MagicRouter.navigateAndPopAll(
              //         const DashBoardScreen(initialIndex: 2));
              // if (status == 'Pending') {
              //   MagicRouter.navigateAndPopAll(const VerificationRequestSent());
              // } else if (status == 'Accepted') {
              //   MagicRouter.navigateAndPopAll(
              //       const DashBoardScreen(initialIndex: 2));
              // } else {
              //   MagicRouter.goBack();
              // }
              //   CacheHelper.setData(key: Strings.isSubscribed, value: true);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Center(
                  child: WebViewX(
                    dartCallBacks: {
                      DartCallback(
                        name: 'TestDartCallback',
                        callBack: (msg) => context.getSnackBar(snackText: msg),
                      )
                    },
                    webSpecificParams: const WebSpecificParams(
                      printDebugInfo: true,
                    ),
                    initialSourceType: SourceType.urlBypass,
                    onWebViewCreated: (controller) {
                      webviewController = controller;
                      log('Page started created:');
                      webviewController.loadContent(url!);
                    },
                    width: MediaQuery.of(context).size.width,
                    height: 1150,
                    onPageStarted: (src) {
                      log('++++++++++Page started loading:++++++++++++ $src');
                    },
                    onPageFinished: (src) {
                      log('Page finished loading: $src');
                      if (src.contains('thankYou')) {
                        PaymentBloc.get(context).add(
                          VerifyPayment(
                            standardValue:
                                PaymentBloc.get(context).planId == null
                                    ? (PaymentBloc.get(context)
                                            .standardValuePayment ??
                                        0)
                                    : null,
                            plainId:
                                PaymentBloc.get(context).standardValuePayment ==
                                        null
                                    ? PaymentBloc.get(context).planId ?? 0
                                    : null,
                            url: src,
                            userId: widget.userId,
                          ),
                        );

                        log('********************planId AT VERIFYYYYY PAAAYMENNNTTTTT*************************');
                        //  log(PaymentBloc.get(context).planId ?? 0);
                        log('===================Success==================================');
                        log('===================Page finished loading==================================');
                        // final status = ProfileBloc.get(context)
                        //     .profileData
                        //     ?.verificationStatus;

                        if (status == 'Pending') {
                          CacheHelper.setData(
                                  key: Strings.isSubscribed, value: true)
                              .then((_) {
                            MagicRouter.navigateAndPopAll(
                                const VerificationRequestSent());
                          });
                        } else if (status == 'Accepted') {
                          CacheHelper.setData(
                                  key: Strings.isSubscribed, value: true)
                              .then((_) {
                            MagicRouter.navigateAndPopAll(
                                const DashBoardScreen(initialIndex: 2));
                          });
                        } else {
                          MagicRouter.goBack();
                        }

                        // MagicRouter.navigateAndPopAll(
                        //     const DashBoardScreen(initialIndex: 2));
                        // CacheHelper.setData(
                        //     key: Strings.isSubscribed, value: true);
                        // ProfileBloc.get(context)
                        //             .profileData
                        //             ?.verificationStatus ==
                        //         'Pending'
                        //     ? MagicRouter.navigateAndPopAll(
                        //         const VerificationRequestSent())
                        //     : ProfileBloc.get(context)
                        //                 .profileData
                        //                 ?.verificationStatus ==
                        //             'Accepted'
                        //         ? MagicRouter.navigateAndPopAll(
                        //             const DashBoardScreen(initialIndex: 2))
                        //         : MagicRouter.goBack();
                      }
                    },
                    onWebResourceError: (error) {
                      log('Error: ${error.description}');
                      context.getSnackBar(
                          snackText: 'فشل في الدفع', isError: true);
                    },
                    navigationDelegate: (navigation) {
                      log('=======================>>naaaaaaaaaavvv');
                      debugPrint(navigation.content.sourceType.toString());
                      return NavigationDecision.navigate;
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
