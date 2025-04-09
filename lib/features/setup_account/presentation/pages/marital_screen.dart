import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/features/setup_account/presentation/pages/choose_images.dart';
import 'package:zawaj/features/setup_account/presentation/pages/continue_setup.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_scaffold.dart';
import '../../../../core/widgets/custom_text.dart';
import '../bloc/setup_bloc.dart';
import '../bloc/states.dart';
import '../widgets/custom_radios.dart';

class MaritalStatus extends StatelessWidget {
  MaritalStatus({super.key});
  final List<String> radioList = [
    Strings.single,
    Strings.married,
    Strings.heDivorced,
    Strings.sheDivorced,
    Strings.divorcedWithChildren,
    Strings.divorcedWithNoChildren,
    Strings.widower,
    Strings.others
  ];
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isFullScreen: true,
      child: BlocConsumer<SetUpBloc, SetUpStates>(
        listener: (BuildContext context, SetUpStates state) {},
        builder: (BuildContext context, SetUpStates state) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CustomAppBar(
              title: Strings.marital_status,
              isBack: true,
            ),
            const CustomRadios(1),
            SizedBox(
              height: context.height * 0.09,
            ),
            Column(
                children: List.generate(
              radioList.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Row(
                  children: [
                    Radio(
                      visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      groupValue:
                          SetUpBloc.get(context).setUpMap["MaritalStatus"],
                      onChanged: (value) {
                        SetUpBloc.get(context)
                            .changeMapValue(key: "MaritalStatus", value: value);
                      },
                      activeColor: ColorManager.primaryColor,
                      value: index,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomText(text: radioList[index])
                  ],
                ),
              ),
            )),
            SizedBox(
              height: context.height * 0.09,
            ),
            CustomButton(
              text: Strings.next,
              onTap: () {
                MagicRouter.navigateTo(ChooseImages());
              },
            )
          ],
        ),
      ),
    );
  }
}
