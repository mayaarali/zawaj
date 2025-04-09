import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/validator/validator.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/send_impression/data/model/model.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/send_impression/data/remote_data_source/repository.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/send_impression/presentation/bloc/bloc.dart';

import '../../../../../../../../core/constants/dimensions.dart';
import '../../../../../../../../core/constants/strings.dart';
import '../../../../../../../../core/widgets/custom_appbar.dart';
import '../../../../../../../../core/widgets/custom_button.dart';
import '../../../../../../../../core/widgets/custom_text_field.dart';

class SendImpression extends StatelessWidget {
  SendImpression({super.key});

  final TextEditingController _sendImpressiontextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKeyy = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppFeedbackCubit(
        AppFeedbackRepository(Dio()),
      ),
      child: BlocConsumer<AppFeedbackCubit, FeedbackState>(
        listener: (context, state) {
          if (state is FeedbackSent) {
            context.getSnackBar(
              snackText: Strings.youAddedFeedbackToThApplication,
              isError: false,
            );
            // MagicRouter.goBack();
            // MagicRouter.goBack();
          } else if (state is FeedbackLoading) {
            const LoadingCircle();
          } else if (state is FeedbackError) {
            context.getSnackBar(
              snackText: state.message,
              isError: false,
            );
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
              child: Column(
                children: [
                  const CustomAppBar(
                    title: Strings.impression,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKeyy,
                    child: CustomTextField(
                      validate: (v) => Validator.validateEmpty(v),
                      hintText: Strings.send_impression,
                      maxLines: 5,
                      controller: _sendImpressiontextEditingController,
                      height: Dimensions(context: context).textFieldHeight * 3,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    onTap: () {
                      if (BlocProvider.of<AppFeedbackCubit>(context)
                              .isLoading ==
                          false) {
                        String message =
                            _sendImpressiontextEditingController.text;
                        if (_formKeyy.currentState!.validate()) {
                          BlocProvider.of<AppFeedbackCubit>(context)
                              .sendFeedback(
                            AppFeedback(message: message),
                          );
                        }
                      }
                    },
                    text: Strings.send,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
