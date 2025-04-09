import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/validator/validator.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/setup_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/states.dart';
import 'package:zawaj/features/setup_account/presentation/pages/set_personal_data.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/custom_text.dart';
import 'custom_expandable_panel.dart';

class MainParam extends StatelessWidget {
  const MainParam(
      {super.key,
      required this.weightController,
      required this.heightController,
      this.isUpdate});
  final TextEditingController weightController;
  final TextEditingController heightController;
  final bool? isUpdate;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetUpBloc, SetUpStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: [
            isUpdate == true
                ? const SizedBox(
                    height: 0,
                  )
                : MaritalStatusDropdownButton(
                    context: context,
                  ),
            const SizedBox(
              height: 20,
            ),
            isUpdate == true
                ? const SizedBox(
                    height: 0,
                  )
                : ReligionDropdownButton(
                    isUpdate: isUpdate ?? false,
                    context: context,
                  ),
            const SizedBox(
              height: 20,
            ),
            isUpdate == true
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(text: Strings.theHeight),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomExpandedPanel(
                        isUpdate: isUpdate,
                        header: CustomText(
                          text: heightController.text,
                          color: ColorManager.darkGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        expanded: Column(
                          children: [
                            TextField(
                              onChanged: (value) {
                                SetUpBloc.get(context)
                                    .changeControllers(value, true);
                              },

                              //  controller: heightController,
                              keyboardType: TextInputType.numberWithOptions(),

                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3),
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]')),
                              ],

                              decoration: const InputDecoration(
                                hintText: "",
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const CustomText(text: Strings.weight),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomExpandedPanel(
                        isUpdate: isUpdate,
                        header: CustomText(
                          text: weightController.text,
                          fontSize: 16,
                          color: ColorManager.darkGrey,
                          fontWeight: FontWeight.bold,
                        ),
                        expanded: Column(
                          children: [
                            TextField(
                              onChanged: (value) {
                                SetUpBloc.get(context)
                                    .changeControllers(value, false);
                              },

                              // controller: weightController,
                              keyboardType: TextInputType.numberWithOptions(),

                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3),
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]')),
                              ],

                              decoration: const InputDecoration(hintText: ""),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: CustomExpandedPanel(
                          header: const CustomText(
                            text: Strings.height,
                            color: ColorManager.borderColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          expanded: Column(
                            children: [
                              TextFormField(
                                validator: (v) =>
                                    Validator.validateParamsRange(v),
                                controller: heightController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(3),
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]')),
                                ],
                                decoration: const InputDecoration(hintText: ""),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomExpandedPanel(
                          header: const CustomText(
                            text: Strings.weight,
                            fontSize: 16,
                            color: ColorManager.borderColor,
                            fontWeight: FontWeight.bold,
                          ),
                          expanded: Column(
                            children: [
                              TextFormField(
                                validator: (v) {
                                  return Validator.validateParamsRange(v);
                                },
                                style: TextStyle(),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(3),
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]')),
                                ],
                                controller: weightController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(hintText: ""),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
          ],
        );
      },
    );
  }
}
