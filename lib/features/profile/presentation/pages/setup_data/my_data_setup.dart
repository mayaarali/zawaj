import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/features/setup_account/presentation/pages/update_profile_data.dart';

import '../../../../../core/constants/color_manager.dart';
import '../../../../../core/constants/image_manager.dart';
import '../../../../../core/constants/strings.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../setup_account/presentation/widgets/custom_expandable_panel.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/states.dart';

class MyProfileData extends StatefulWidget {
  const MyProfileData({super.key});

  @override
  State<MyProfileData> createState() => _MyProfileDataState();
}

class _MyProfileDataState extends State<MyProfileData> {
  @override
  void initState() {
    ProfileBloc.get(context).getMyProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        isFullScreen: true,
        child: Column(
          children: [
            CustomAppBar(
              title: Strings.my_personal_data,
              isBack: true,
              leading: GestureDetector(
                onTap: () {
                  MagicRouter.navigateTo(UpdateProfileData());
                },
                child: SvgPicture.asset(
                  ImageManager.filter,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            //  AgeRangeSelector(),
            const SizedBox(
              height: 20,
            ),
            // MainParam(
            //   heightController:bloc.heightRequiredController ,
            //   weightController: bloc.weightRequiredController,
            //   isRequired: false,
            // ),
            const SizedBox(
              height: 15,
            ),
            BlocConsumer<ProfileBloc, ProfileStates>(
                listener: (BuildContext context, ProfileStates state) {
                  if (state is SuccessProfile) {}
                  if (state is FailedProfile) {
                    context.getSnackBar(
                        snackText: state.message, isError: true);
                  }
                },
                builder: (BuildContext context, ProfileStates state) =>
                    state is LoadingProfile
                        ? const LinearProgressIndicator(
                            color: ColorManager.primaryColor,
                          )
                        : state is SuccessProfile
                            ? Expanded(
                                child: ListView(
                                  //mainAxisSize: MainAxisSize.min,
                                  children: [
                                    MainParam(
                                      profileData: state.profileData,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Wrap(
                                      direction: Axis.horizontal,
                                      children: [
                                        for (int i = 0;
                                            i <
                                                state.profileData.parameters!
                                                    .length;
                                            i++)
                                          Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                end: i.isEven ? 0 : 0,
                                                bottom: 15),
                                            child: SizedBox(
                                              width: (context.width * 0.5) - 25,
                                              //height: 60,
                                              child: ItemExpandable(
                                                title: state
                                                        .profileData
                                                        .parameters![i]
                                                        .parameterName ??
                                                    '',
                                                value: state
                                                        .profileData
                                                        .parameters![i]
                                                        .valueName ??
                                                    '',
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox())
          ],
        ));
  }
}

class ItemExpandable extends StatelessWidget {
  const ItemExpandable({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return CustomExpandedPanel(
        header: CustomText(
          text: title,
          color: ColorManager.primaryColor,
        ),
        expanded: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: CustomText(
                color: Colors.black,
                text: DateTime.tryParse(value) == null
                    ? value
                    : value.split("T")[0],
                align: TextAlign.start,
              ),
            ),
          ],
        ));
  }
}

class MainParam extends StatelessWidget {
  MainParam(
      {super.key, required this.profileData, this.isRequiredData = false});
  var profileData;
  bool isRequiredData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isRequiredData
            ? Row(
                children: [
                  Expanded(
                    child: ItemExpandable(
                      title: Strings.min_age,
                      value: profileData.minAge.toString(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ItemExpandable(
                        title: Strings.max_age,
                        value: profileData.maxAge.toString()),
                  ),
                ],
              )
            : const SizedBox(),
        isRequiredData
            ? const SizedBox(
                height: 15,
              )
            : const SizedBox(),
        Row(
          children: [
            isRequiredData
                ? const SizedBox()
                : Expanded(
                    child: Column(
                      children: [
                        ItemExpandable(
                          title: Strings.age,
                          value: profileData.age.toString(),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
          ],
        ),
        isRequiredData
            ? const SizedBox()
            : const SizedBox(
                height: 15,
              ),
        isRequiredData
            ? const SizedBox()
            : Row(
                children: [
                  Expanded(
                    child: ItemExpandable(
                      title: Strings.area,
                      value: profileData.city.toString(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ItemExpandable(
                        title: Strings.city,
                        value: profileData.area.toString()),
                  ),
                ],
              ),
        const SizedBox(
          height: 15,
        ),
        isRequiredData
            ? Row(
                children: [
                  Expanded(
                    child: ItemExpandable(
                      title: Strings.min_height,
                      value: profileData.minHeight.toString(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ItemExpandable(
                        title: Strings.max_height,
                        value: profileData.maxHeight.toString()),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: ItemExpandable(
                      title: Strings.height,
                      value: profileData.height.toString(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ItemExpandable(
                        title: Strings.weight,
                        value: profileData.weight.toString()),
                  ),
                ],
              ),
        !isRequiredData
            ? const SizedBox()
            : const SizedBox(
                height: 15,
              ),
        isRequiredData
            ? Row(
                children: [
                  Expanded(
                    child: ItemExpandable(
                      title: Strings.min_weight,
                      value: profileData.minWeight.toString(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ItemExpandable(
                        title: Strings.max_weight,
                        value: profileData.maxWeight.toString()),
                  ),
                ],
              )
            : SizedBox(),
        const SizedBox(
          height: 15,
        ),
        isRequiredData
            ? const SizedBox()
            : ItemExpandable(
                title: Strings.marital_status,
                value: profileData.maritalStatus.toString(),
              ),
      ],
    );
  }
}
