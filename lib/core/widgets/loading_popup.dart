import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/color_manager.dart';

class LoadingPopUp extends StatelessWidget {
  const LoadingPopUp({Key? key, this.globalKey}) : super(key: key);
  final globalKey;
  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            surfaceTintColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoActivityIndicator(
                    color: ColorManager.primaryColor,
                  ), // Loading indicator
                  SizedBox(height: 20),
                  Text(
                    'تحميل ...',
                    style: TextStyle(color: ColorManager.primaryTextColor),
                  ), // Text indicating loading
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
