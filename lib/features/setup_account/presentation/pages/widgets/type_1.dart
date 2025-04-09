import 'dart:developer';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/setup_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/states.dart';

import '../../../../../core/constants/color_manager.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../data/models/params_model.dart';

class MultiSelectType extends StatefulWidget {
  const MultiSelectType(
      {super.key, required this.paramsModel, required this.i, this.isUpdate});
  final ParamsModel paramsModel;
  final int i;
  final bool? isUpdate;
  @override
  State<MultiSelectType> createState() => _MultiSelectTypeState();
}

class _MultiSelectTypeState extends State<MultiSelectType> {
  List<String> checkedItemValue = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('checkedItemValue');
    log(checkedItemValue.toString());
    log(checkedItemValue.length.toString());

    log("widget.i");
    log(widget.i.toString());
    log('SetUpBloc.get(context).isChecked => ${SetUpBloc.get(context).isChecked}');
    if (widget.isUpdate == true &&
        SetUpBloc.get(context).isChecked.isNotEmpty &&
        SetUpBloc.get(context).isChecked[widget.i] != null) {
      checkedItemValue = [];

      for (int i = 0;
          i < SetUpBloc.get(context).isChecked[widget.i]!.length;
          i++) {
        if (SetUpBloc.get(context).isChecked[widget.i]![i]!.value == true) {
          checkedItemValue.add(widget.paramsModel.values![i].value!);
        }
      }
    }
    return widget.isUpdate == true
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ExpandablePanel(
              theme: const ExpandableThemeData(
                expandIcon: Icons.edit_outlined,
                collapseIcon: Icons.keyboard_arrow_up,
                iconColor: ColorManager.primaryColor,
              ),
              header: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomText(
                        align: TextAlign.start,
                        text: checkedItemValue
                            .toString()
                            .replaceAll('[', '')
                            .replaceAll(']', ''),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.darkGrey,
                      ),
                    )
                  ],
                ),
              ),
              expanded: BlocConsumer<SetUpBloc, SetUpStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  log('////////////////////////checkedItemValue');
                  log(checkedItemValue.toString());
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.paramsModel.values!.length,
                    itemBuilder: (context, index) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: SetUpBloc.get(context)
                                    .isChecked[widget.i]![index]!
                                    .value ??
                                false,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  checkedItemValue.add(
                                      widget.paramsModel.values![index].value!);
                                  if (!SetUpBloc.get(context)
                                      .multiSelectList!
                                      .contains(ValueBody(
                                        paramId: widget.paramsModel.id,
                                        value: widget
                                            .paramsModel.values![index].value,
                                        valueId: widget
                                            .paramsModel.values![index].id,
                                      ))) {
                                    log('add multi select');
                                    SetUpBloc.get(context).multiSelectList!.add(
                                          ValueBody(
                                            paramId: widget.paramsModel.id,
                                            value: widget.paramsModel
                                                .values![index].value,
                                            valueId: widget
                                                .paramsModel.values![index].id,
                                          ),
                                        );
                                  }
                                } else {
                                  checkedItemValue.remove(
                                      widget.paramsModel.values![index].value!);
                                  SetUpBloc.get(context)
                                      .multiSelectList!
                                      .removeWhere((element) {
                                    return element?.valueId ==
                                        widget.paramsModel.values![index].id;
                                  });
                                }
                                SetUpBloc.get(context)
                                    .isChecked[widget.i]![index]!
                                    .value = value;
                              });
                            },
                          ),
                          CustomText(
                            text: widget.paramsModel.values![index].value ?? "",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.darkGrey,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              collapsed: const SizedBox(),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ExpandablePanel(
              theme: const ExpandableThemeData(
                iconColor: ColorManager.borderColor,
              ),
              header: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    CustomText(
                      text: checkedItemValue.toString() == '[]'
                          ? widget.paramsModel.title.toString()
                          : checkedItemValue
                              .toString()
                              .replaceAll('[', '')
                              .replaceAll(']', ''),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.darkGrey,
                    ),
                  ],
                ),
              ),
              expanded: BlocConsumer<SetUpBloc, SetUpStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.paramsModel.values!.length,
                    itemBuilder: (context, index) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: SetUpBloc.get(context)
                                    .isChecked[widget.i]![index]!
                                    .value ??
                                false,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  checkedItemValue.add(
                                      widget.paramsModel.values![index].value!);
                                  if (!SetUpBloc.get(context)
                                      .multiSelectList!
                                      .contains(ValueBody(
                                        paramId: widget.paramsModel.id,
                                        value: widget
                                            .paramsModel.values![index].value,
                                        valueId: widget
                                            .paramsModel.values![index].id,
                                      ))) {
                                    print('add multi select');
                                    SetUpBloc.get(context).multiSelectList!.add(
                                          ValueBody(
                                            paramId: widget.paramsModel.id,
                                            value: widget.paramsModel
                                                .values![index].value,
                                            valueId: widget
                                                .paramsModel.values![index].id,
                                          ),
                                        );
                                  }
                                } else {
                                  checkedItemValue.remove(
                                      widget.paramsModel.values![index].value!);
                                  SetUpBloc.get(context)
                                      .multiSelectList!
                                      .removeWhere((element) {
                                    return element?.valueId ==
                                        widget.paramsModel.values![index].id;
                                  });
                                }
                                SetUpBloc.get(context)
                                    .isChecked[widget.i]![index]!
                                    .value = value;
                              });
                            },
                          ),
                          CustomText(
                            text: widget.paramsModel.values![index].value ?? "",
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              collapsed: const SizedBox(),
            ),
          );
  }
}
