import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/features/notification/data/models/notificationModel.dart';

class NotificationBody extends StatelessWidget {
  const NotificationBody({super.key, required this.notificationModel});
  final NotificationModel notificationModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(
        //     color: ColorManager.primaryColor)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: CustomText(
                  align: TextAlign.start,
                  text: notificationModel.body,
                  fontSize: 16,
                  color: ColorManager.greyTextColor,
                  lines: 2,
                  //  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: [
                  CustomText(
                    text: notificationModel.time,
                    color: ColorManager.greyTextColor,
                  ),
                  CustomText(
                    text: notificationModel.date,
                    //color: ColorManager.greyTextColor,
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(),
        ],
      ),
    );
  }
}
