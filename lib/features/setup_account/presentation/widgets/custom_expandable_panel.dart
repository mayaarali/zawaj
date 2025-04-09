import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';

class CustomExpandedPanel extends StatelessWidget {
  const CustomExpandedPanel(
      {super.key, required this.header, required this.expanded, this.isUpdate});
  final Widget expanded;
  final Widget header;
  final bool?isUpdate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.buttonRadius),
              border: Border.all(color: ColorManager.borderColor)),
          child: ExpandablePanel(
            theme:
                 ExpandableThemeData(iconColor: isUpdate==true?ColorManager.primaryColor:ColorManager.borderColor,expandIcon: isUpdate==true?Icons.edit_outlined: Icons.keyboard_arrow_down,collapseIcon:Icons.keyboard_arrow_up ),
            header: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  header,
                ],
              ),
            ),
            collapsed: const SizedBox(),
            expanded: expanded,
          )),
    );
  }
}
