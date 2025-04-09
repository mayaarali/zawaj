import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/setup_bloc.dart';

import '../../../../../core/constants/color_manager.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../data/models/params_model.dart';

class TextNumberType extends StatelessWidget {
  const TextNumberType({
    super.key,
    Key? keyy,
    required this.i,
    required this.paramsList,
    required this.isNumber,
    this.isUpdate,
  });

  final int i;
  final List<ParamsModel> paramsList;
  final bool isNumber;
  final bool? isUpdate;

  @override
  Widget build(BuildContext context) {
    print('updaaaaaaaaaate proooofile');
    print(i);
    print(SetUpBloc.get(context).dropValueList!);
    print(SetUpBloc.get(context).dropValueList![i]);
    print(SetUpBloc.get(context).dropValueBodyList![i]);
    return isUpdate == true
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ExpandablePanel(
              theme: const ExpandableThemeData(
                expandIcon: Icons.edit_outlined,
                collapseIcon: Icons.keyboard_arrow_up,
                iconColor: ColorManager.primaryColor,
              ),
              header: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CustomText(
                      text: SetUpBloc.get(context).dropValueList![i] == null
                          ? ''
                          : SetUpBloc.get(context).dropValueList![i]!.value ??
                              '',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.borderColor,
                    ),
                  ),
                ],
              ),
              expanded: Column(
                children: [
                  TextField(
                    onChanged: (v) {
                      SetUpBloc.get(context).changeDropList(
                          i, Value(id: null, value: v), paramsList[i].id);
                    },
                    decoration: InputDecoration(
                        hintText: SetUpBloc.get(context).dropValueList![i] ==
                                null
                            ? ''
                            : SetUpBloc.get(context).dropValueList![i]!.value ??
                                ''),
                    // controller:controller ,
                    keyboardType:
                        isNumber ? TextInputType.number : TextInputType.text,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              collapsed: const SizedBox(),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ExpandablePanel(
              theme: const ExpandableThemeData(
                iconColor: ColorManager.borderColor,
              ),
              header: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CustomText(
                      text: paramsList[i].title,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.borderColor,
                    ),
                  ),
                ],
              ),
              expanded: Column(
                children: [
                  TextField(
                    onChanged: (v) {
                      SetUpBloc.get(context).changeDropList(
                          i, Value(id: null, value: v), paramsList[i].id);
                    },
                    decoration: InputDecoration(
                        hintText: SetUpBloc.get(context).dropValueList![i] ==
                                null
                            ? ''
                            : SetUpBloc.get(context).dropValueList![i]!.value ??
                                ''),
                    // controller:controller ,
                    keyboardType:
                        isNumber ? TextInputType.number : TextInputType.text,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              collapsed: const SizedBox(),
            ),
          );
  }
}
