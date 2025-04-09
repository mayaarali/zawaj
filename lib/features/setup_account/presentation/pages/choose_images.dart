import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/extensions/colored_print.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/add_image_box.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/payment/presentation/pages/payment_possibilities.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zawaj/features/profile/presentation/pages/verification/presentation/verifing_request_sent_screen.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/event.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/setup_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/pages/gender_screen.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../bloc/states.dart';

class ChooseImages extends StatefulWidget {
  ChooseImages({super.key});

  @override
  State<ChooseImages> createState() => _ChooseImagesState();
}

class _ChooseImagesState extends State<ChooseImages> {
  @override
  void initState() {
    SetUpBloc.get(context).selectedImages = [null];
    //SetUpBloc.get(context).selectedImages = List.filled(1, null);
    super.initState();
  }

  String? selectedOption;
  bool showErrorTextOfImage = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetUpBloc, SetUpStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return CustomScaffold(
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(Dimensions.defaultPadding),
              child: state is LoadingSetUp
                  ? const LoadingCircle()
                  : CustomButton(
                      text: Strings.next,
                      onTap: () async {
                        List images = [];
                        for (int i = 0;
                            i < SetUpBloc.get(context).selectedImages.length;
                            i++) {
                          if (SetUpBloc.get(context).selectedImages[i] !=
                              null) {
                            images.add(await MultipartFile.fromFile(
                                SetUpBloc.get(context).selectedImages[i]!));
                          }
                        }

                        if (images.isEmpty) {
                          setState(() {
                            showErrorTextOfImage = true;
                          });
                        } else {
                          SetUpBloc.get(context)
                              .setUpMap
                              .addEntries({"ImagesPath": images}.entries);

                          context.printGreen(SetUpBloc.get(context).setUpMap);
                          //MagicRouter.navigateTo(SetPersonalData())
                          SetUpBloc.get(context).add(PostSetUpEvent());
                        }
                      }),
            ),
            isFullScreen: true,
            child: BlocConsumer<SetUpBloc, SetUpStates>(
              listener: (BuildContext context, SetUpStates state) {
                if (state is SuccessSetUp) {
                  // SetUpBloc.get(context).add(PostSetUpEvent());
                  // MagicRouter.navigateAndPopAll(
                  //     const VerificationRequestSent());
                  MagicRouter.navigateAndPopAll(const PayementPossibility(
                    isFromProfileScreen: false,
                  ));
                  //(const YourProfileIsComplete());
                }
                //SetUpBloc.get(context).add(PostSetUpEvent());
              },
              builder: (BuildContext context, SetUpStates state) =>
                  SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomAppBar(
                      title: Strings.my_photos,
                      isBack: true,
                    ),
                    const CustomStepper(
                      pageNumber: 2,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Center(
                      child: CustomText(
                        text: Strings.the_importance_of_the_image,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: context.height * 0.035,
                    ),
                    const CustomText(
                      text: Strings.real_photo_description,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: context.height * 0.015,
                    ),

                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: SetUpBloc.get(context).selectedImages.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (SetUpBloc.get(context).selectedImages.length >= 3 &&
                            index == 3) {
                          return null;
                        }
                        if (index ==
                                SetUpBloc.get(context).selectedImages.length -
                                    1 &&
                            SetUpBloc.get(context).selectedImages[index] !=
                                null) {
                          SetUpBloc.get(context).selectedImages.add(null);
                        }
                        return AddImageBox(
                          context.height,
                          context.width,
                          SetUpBloc.get(context).selectedImages[index],
                          () {
                            SetUpBloc.get(context).removeImage(index);
                          },
                          () {
                            SetUpBloc.get(context)
                                .selectFromGallery(context, index);
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    showErrorTextOfImage == false
                        ? const SizedBox()
                        : const CustomText(
                            text: 'يرجى اضافة صورة واحدة على الأقل'),
                    const SizedBox(
                      height: 30,
                    ),

                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     RadioListTile(
                    //       dense: true,
                    //       contentPadding: EdgeInsets.zero,
                    //       title: const CustomText(
                    //         text: 'عرض صوري لجميع المستخدمين',
                    //         align: TextAlign.start,
                    //         fontSize: 15,
                    //       ),
                    //       value: 'Option 1',
                    //       groupValue: selectedOption,
                    //       onChanged: (value) {
                    //         setState(() {
                    //           selectedOption = value;
                    //         });
                    //       },
                    //     ),
                    //     RadioListTile(
                    //       dense: true,
                    //       contentPadding: EdgeInsets.zero,
                    //       title: const CustomText(
                    //         text: 'عرض حسب الطلب',
                    //         align: TextAlign.start,
                    //         fontSize: 15,
                    //       ),
                    //       value: 'Option 2',
                    //       groupValue: selectedOption,
                    //       onChanged: (value) {
                    //         setState(() {
                    //           selectedOption = value;
                    //         });
                    //       },
                    //     ),
                    //     const SizedBox(height: 20),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     Radio(
                    //       visualDensity: const VisualDensity(
                    //           horizontal: VisualDensity.minimumDensity,
                    //           vertical: VisualDensity.minimumDensity),
                    //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //       value: 'Option 1',
                    //       groupValue: selectedOption,
                    //       onChanged: (value) {
                    //         setState(() {
                    //           selectedOption = value;
                    //         });
                    //       },
                    //     ),
                    //     const SizedBox(width: 10),
                    //     const CustomText(
                    //       text: 'عرض صوري لجميع المستخدمين',
                    //       align: TextAlign.start,
                    //       fontSize: 15,
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 20),
                    // Row(
                    //   children: [
                    //     Radio(
                    //       visualDensity: const VisualDensity(
                    //           horizontal: VisualDensity.minimumDensity,
                    //           vertical: VisualDensity.minimumDensity),
                    //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //       value: 'Option 2',
                    //       groupValue: selectedOption,
                    //       onChanged: (value) {
                    //         setState(() {
                    //           selectedOption = value;
                    //         });
                    //       },
                    //     ),
                    //     const SizedBox(width: 10),
                    //     const CustomText(
                    //       text: 'عرض حسب الطلب',
                    //       align: TextAlign.start,
                    //       fontSize: 15,
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 20),
                    // CustomButton(
                    //     text: Strings.next,
                    //     onTap: () async {
                    //       List images = [];
                    //       for (int i = 0;
                    //           i < SetUpBloc.get(context).selectedImages.length;
                    //           i++) {
                    //         if (SetUpBloc.get(context).selectedImages[i] != null) {
                    //           images.add(await MultipartFile.fromFile(
                    //               SetUpBloc.get(context).selectedImages[i]!));
                    //         }
                    //       }

                    //       if (images.isEmpty || images.length < 3) {
                    //         setState(() {
                    //           showErrorTextOfImage = true;
                    //         });
                    //         // context.getSnackBar(
                    //         //     snackText: 'يجب إضافة صورة واحدة على الأقل ',
                    //         //     isError: true);
                    //       } else {
                    //         SetUpBloc.get(context)
                    //             .setUpMap
                    //             .addEntries({"ImagesPath": images}.entries);

                    //         context.printGreen(SetUpBloc.get(context).setUpMap);
                    //         //MagicRouter.navigateTo(SetPersonalData())
                    //         SetUpBloc.get(context).add(PostSetUpEvent());
                    //       }
                    //     }),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
