import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/color_manager.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../data/models/params_model.dart';
import '../../bloc/setup_bloc.dart';
import '../../bloc/states.dart';

class SelectType extends StatelessWidget {
  SelectType(
      {super.key, required this.i, required this.paramsList, this.isUpdate});

  final int i;
  final List<ParamsModel> paramsList;
  final bool? isUpdate;
  @override
  Widget build(BuildContext context) {
    return isUpdate == true
        ? BlocConsumer<SetUpBloc, SetUpStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return Padding(
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
                      children: [
                        CustomText(
                          text:
                              SetUpBloc.get(context).dropValueList![i]?.value ??
                                  '',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.darkGrey,
                        ),
                      ],
                    ),
                  ),
                  expanded: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: paramsList[i].values!.length,
                    itemBuilder: (context, index) {
                      // print("iam in list");

                      // print(SetUpBloc.get(context).dropValueList![i]);
                      // print(SetUpBloc.get(context).dropValueList![i]?.id);

                      // print(paramsList[i].values![index].value);
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              shape: CircleBorder(),
                              // groupValue:
                              //     SetUpBloc.get(context).dropValueList![i]?.id,
                              value: paramsList[i].values![index].id ==
                                  SetUpBloc.get(context).dropValueList?[i]?.id,
                              onChanged: (value) {
                                if (value == true) {
                                  SetUpBloc.get(context).changeDropList(
                                      i,
                                      Value(
                                          id: paramsList[i].values![index].id,
                                          value: paramsList[i]
                                              .values![index]
                                              .value),
                                      paramsList[i].id);
                                } else {
                                  SetUpBloc.get(context)
                                      .changeDropList(i, null, null);
                                }
                              },
                            ),
                            CustomText(
                              text: paramsList[i].values![index].value ?? "",
                              color: Colors.black,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  collapsed: const SizedBox(),
                ),
              );
            })
        : BlocConsumer<SetUpBloc, SetUpStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return Padding(
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
                          text: SetUpBloc.get(context)
                                      .dropValueList![i]
                                      ?.value !=
                                  null
                              ? SetUpBloc.get(context).dropValueList![i]?.value
                              : paramsList[i].title.toString(),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.borderColor,
                        ),
                      ],
                    ),
                  ),
                  expanded: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: paramsList[i].values!.length,
                    itemBuilder: (context, index) {
                      // print("iam in list");

                      // print(SetUpBloc.get(context).dropValueList![i]);
                      // print(SetUpBloc.get(context).dropValueList![i]?.id);
                      // print('//////////////////////////');
                      // print(paramsList[i].values![index].id);
                      // print(SetUpBloc.get(context).dropValueList![i]?.id);
                      // print('//////////////////////////');
                      // print(paramsList[i].values![index].value);

                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              shape: CircleBorder(),
                              // groupValue:
                              //     SetUpBloc.get(context).dropValueList![i]?.id,
                              value: paramsList[i].values![index].id ==
                                  SetUpBloc.get(context).dropValueList?[i]?.id,
                              onChanged: (value) {
                                if (value == true) {
                                  SetUpBloc.get(context).changeDropList(
                                      i,
                                      Value(
                                          id: paramsList[i].values![index].id,
                                          value: paramsList[i]
                                              .values![index]
                                              .value),
                                      paramsList[i].id);
                                } else {
                                  SetUpBloc.get(context)
                                      .changeDropList(i, null, null);
                                }
                              },
                            ),
                            CustomText(
                              text: paramsList[i].values![index].value ?? "",
                              color: Colors.black,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  collapsed: const SizedBox(),
                ),
              );
            });

    //   Padding(
    //   padding: const EdgeInsetsDirectional
    //       .only(end: 0,top: 5,bottom: 5),
    //   child: DropdownButtonHideUnderline(
    //     child: DropdownButton<Value>(
    //       isExpanded: true,
    //       elevation: 0,
    //       icon: const Icon(
    //         Icons.keyboard_arrow_down_sharp,
    //         color: ColorManager.primaryColor,
    //       ),
    //       value: SetUpBloc.get(context)
    //           .dropValueList![i],
    //       items: paramsList[i].values!
    //           .map((Value paramValue) {
    //         return DropdownMenuItem<Value>(
    //           value: paramValue,
    //           child: Padding(
    //             padding: const EdgeInsetsDirectional
    //                 .only(end: 0,),
    //             child: Text(
    //               '${paramValue.value}',
    //               style: const TextStyle(
    //                   color: ColorManager
    //                       .primaryColor),
    //             ),
    //           ),
    //         );
    //       }).toList(),
    //       onChanged: (newValue) {
    //         SetUpBloc.get(context)
    //             .changeDropList(i, newValue,paramsList[i].id);
    //       },
    //       hint: Padding(
    //         padding:
    //         const EdgeInsetsDirectional.only(
    //             end: 0,),
    //         child: Text(
    //           paramsList[i].title ?? '',
    //           style: const TextStyle(
    //               color: ColorManager.primaryColor),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
