import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/validator/validator.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/dashboard/view.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/send_report/presentation/bloc/send_report_bloc.dart';

import '../../../../../../../../core/constants/dimensions.dart';
import '../../../../../../../../core/constants/strings.dart';
import '../../../../../../../../core/widgets/custom_appbar.dart';
import '../../../../../../../../core/widgets/custom_button.dart';
import '../../../../../../../../core/widgets/custom_text_field.dart';

class SendReport extends StatelessWidget {
  final String userId;
  final String userName;

  SendReport({
    super.key,
    required this.userId,
    required this.userName,
  });
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SendReportBloc, SendReportState>(
      listener: (context, state) {
        if (state is SendReportSuccess) {
          context.getSnackBar(
            snackText: Strings.youAddedFeedbackToThApplication,
            isError: false,
          );
          MagicRouter.navigateAndPopAll(DashBoardScreen(initialIndex: 2));
          SendReportBloc.get(context).reportController.clear();
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            print('Unfocus************************');
            FocusScope.of(context).unfocus();
          },
          child: CustomScaffold(
            isFullScreen: true,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const CustomAppBar(
                    title: Strings.report_user,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: 'أبلغ عن ',
                              color: ColorManager.darkGrey,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            CustomText(
                              text: userName,
                              fontWeight: FontWeight.w700,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          controller:
                              SendReportBloc.get(context).reportController,
                          hintText: Strings.desc,
                          maxLines: 5,
                          height:
                              Dimensions(context: context).textFieldHeight * 3,
                          validate: (value) =>
                              Validator.validateEmptyValues(value),

                          // validate: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return Strings.pleaseEntredescription;
                          //   }
                          //   return null;
                          // },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        state is SendReportLoading
                            ? const LoadingCircle()
                            : CustomButton(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    SendReportBloc.get(context)
                                        .add(SentEvent(userId: userId));
                                  }
                                },
                                text: Strings.send,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
