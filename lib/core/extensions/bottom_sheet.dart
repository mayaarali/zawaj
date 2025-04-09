import 'package:flutter/material.dart';
import 'package:zawaj/core/extensions/sizes.dart';

extension BottomSheetExtension on BuildContext {


  void getBottomSheet({required Widget child}) =>
      showModalBottomSheet(context: this,
          shape:  const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight:Radius.circular(30)
              ,topLeft:Radius.circular(30) )),
          constraints: BoxConstraints(minHeight: height*0.25,maxHeight: height*0.6),

          showDragHandle: true,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          builder: (context)=>child);
}