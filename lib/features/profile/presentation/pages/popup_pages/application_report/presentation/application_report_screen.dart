import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/validator/validator.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/dashboard/view.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/application_report/presentation/bloc/app_report_bloc.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/application_report/presentation/bloc/app_report_state.dart';

import '../../../../../../../../../core/constants/dimensions.dart';
import '../../../../../../../../../core/constants/strings.dart';
import '../../../../../../../../../core/widgets/custom_appbar.dart';
import '../../../../../../../../../core/widgets/custom_button.dart';
import '../../../../../../../../../core/widgets/custom_text_field.dart';

class ApplicationReport extends StatefulWidget {
  ApplicationReport({
    super.key,
  });

  @override
  State<ApplicationReport> createState() => _ApplicationReportState();
}

class _ApplicationReportState extends State<ApplicationReport> {
  final GlobalKey<FormState> _formKeyy = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppReportBloc.get(context).reportMessageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppReportBloc, AppReportState>(
      listener: (context, state) {
        if (state is AppReportSuccess) {
          context.getSnackBar(
            snackText: Strings.youAddedFeedbackToThApplication,
            isError: false,
          );
          MagicRouter.navigateAndPopAll(const DashBoardScreen(initialIndex: 2));
          AppReportBloc.get(context).reportMessageController.clear();
        } else if (state is AppReportLoading) {
          const LoadingCircle();
        }
      },
      builder: (context, state) {
        return CustomScaffold(
            isFullScreen: true,
            child: Column(
              children: [
                const CustomAppBar(
                  title: Strings.appReport,
                ),
                const SizedBox(
                  height: 40,
                ),
                Form(
                  key: _formKeyy,
                  child: CustomTextField(
                    validate: (value) => Validator.validateEmptyValues(value),
                    // validate: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return Strings.pleaseEntredescription;
                    //   }
                    //   return null;
                    // },
                    controller:
                        AppReportBloc.get(context).reportMessageController,
                    hintText: Strings.desc,
                    maxLines: 5,
                    height: Dimensions(context: context).textFieldHeight * 3,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                state is AppReportLoading
                    ? const LoadingCircle()
                    : CustomButton(
                        onTap: () {
                          if (_formKeyy.currentState!.validate()) {
                            AppReportBloc.get(context).add(AppEvent());
                          }
                        },
                        text: Strings.send),
              ],
            ));
      },
    );
  }
}
