// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class PickImageDialoge extends StatefulWidget {
//
//
//   PickImageDialoge({super.key});
//
//
//
//   @override
//   State<PickImageDialoge> createState() => _PickImageDialogeState();
// }
//
// class _PickImageDialogeState extends State<PickImageDialoge> {
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       BlocConsumer<AuthBloc, AuthStates>(
//         listener: (context, state) {
//           if(state is ImageCamera||state is ImageGallery){
//             Navigator.pop(context);
//           }
//         },
//         builder: (context, state) =>
//             SimpleDialog(
//               title: Text(('Select...'),),
//               children: [
//
//                 SimpleDialogOption(
//                     child: Text(('Pick From Camera'),),
//                     onPressed: () {
//                       AuthBloc.get(context).pickFromCamera(context);
//                     }),
//                 SimpleDialogOption(
//                     child: Text(('Pick From Gallery'),),
//                     onPressed: () {
//                       AuthBloc.get(context).pickFromGallery(context);
//                     }),
//
//               ],
//             ),
//       );
//
//   }
//
//
// }