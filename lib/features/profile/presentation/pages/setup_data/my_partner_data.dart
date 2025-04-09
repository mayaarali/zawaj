import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/features/setup_account/presentation/pages/set_partenal_data.dart';

import '../../../../../core/constants/color_manager.dart';
import '../../../../../core/constants/strings.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/states.dart';
import 'my_data_setup.dart';

class MyPartnerData extends StatefulWidget {
  const MyPartnerData({super.key});

  @override
  State<MyPartnerData> createState() => _MyPartnerDataState();
}

class _MyPartnerDataState extends State<MyPartnerData> {
  @override
  void initState() {
    ProfileBloc.get(context).getMyPartner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isFullScreen: true,
      child: Column(
        children: [
          CustomAppBar(
            title: Strings.required_data,
            isBack: true,
            leading: GestureDetector(
              onTap: () {
                MagicRouter.navigateTo(SetPartnerData(isUpdated: true));
              },
              child: SvgPicture.asset(
                ImageManager.settingIcon,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          BlocConsumer<ProfileBloc, ProfileStates>(
              listener: (BuildContext context, ProfileStates state) {
                if (state is SuccessPartner) {}
                if (state is FailedPartner) {
                  context.getSnackBar(snackText: state.message, isError: true);
                }
              },
              builder: (BuildContext context, ProfileStates state) => state
                      is LoadingPartner
                  ? const LinearProgressIndicator(
                      color: ColorManager.primaryColor,
                    )
                  : state is SuccessPartner
                      ? Expanded(
                          child: ListView(
                            //mainAxisSize: MainAxisSize.min,
                            children: [
                              MainParam(
                                  profileData: state.partnerList,
                                  isRequiredData: true),
                              const SizedBox(
                                height: 15,
                              ),
                              Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  for (int i = 0;
                                      i < state.partnerList.parameters!.length;
                                      i++)
                                    Padding(
                                      padding: EdgeInsetsDirectional.only(
                                          end: i.isEven ? 0 : 0, bottom: 15),
                                      child: SizedBox(
                                        width: (context.width * 0.5) - 25,
                                        //height: 60,
                                        child: ItemExpandable(
                                          title: state
                                                  .partnerList
                                                  .parameters![i]
                                                  .parameterName ??
                                              '',
                                          value: state.partnerList
                                                  .parameters![i].valueName ??
                                              '',
                                        ),
                                      ),
                                    ),
                                  //   Column(
                                  //     children: [
                                  //       Container(
                                  //         height: 50,
                                  //         width: 50,
                                  //         color: Colors.amber,
                                  //       ),
                                  //       Container(
                                  //         height: 50,
                                  //         width: 50,
                                  //         color: Colors.green,
                                  //       ),
                                  //       Container(
                                  //         height: 50,
                                  //         width: 50,
                                  //         color: Colors.black,
                                  //       ),
                                  //       Container(
                                  //         height: 50,
                                  //         width: 50,
                                  //         color: Colors.red,
                                  //       ),
                                  //       Container(
                                  //         height: 50,
                                  //         width: 50,
                                  //         color: Colors.amber,
                                  //       ),
                                  //       Container(
                                  //         height: 50,
                                  //         width: 50,
                                  //         color: Colors.green,
                                  //       ),
                                  //       Container(
                                  //         height: 50,
                                  //         width: 50,
                                  //         color: Colors.black,
                                  //       ),
                                  //       Container(
                                  //         height: 50,
                                  //         width: 50,
                                  //         color: Colors.red,
                                  //       ),
                                  //       Container(
                                  //         height: 50,
                                  //         width: 50,
                                  //         color: Colors.amber,
                                  //       ),
                                  //       Container(
                                  //         height: 50,
                                  //         width: 50,
                                  //         color: Colors.green,
                                  //       ),
                                  //       Container(
                                  //         height: 50,
                                  //         width: 50,
                                  //         color: Colors.black,
                                  //       ),
                                  //       Container(
                                  //         height: 50,
                                  //         width: 50,
                                  //         color: Colors.red,
                                  //       ),
                                  //     ],
                                  //   ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : const SizedBox())
        ],
      ),
    );
  }
}
