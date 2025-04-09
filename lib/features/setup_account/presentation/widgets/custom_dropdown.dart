// import 'package:flutter/material.dart';
//
// import '../../data/models/params_model.dart';
// class CustomDropDown extends StatelessWidget {
//    CustomDropDown(this.dropDownValue,{Key? key}) : super(key: key);
//     final dropDownValue;
//     List<ParamsModel>paramslist;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//
//         child:
//         DropdownButton(
//           value: 0,
//
//           icon: const Icon(Icons.keyboard_arrow_down),
//
//           // Array list of items
//           items: items.map((String items) {
//             return DropdownMenuItem(
//               value: items,
//               child: Text(items),
//             );
//           }).toList(),
//           // After selecting the desired option,it will
//           // change button value to selected value
//           onChanged: (int? newValue) {
//
//           },
//         ),
//
//     );
//   }
// }
