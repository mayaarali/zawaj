import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/features/profile/presentation/pages/verification/data/repos/verify_repositiry.dart';
part 'verify_event.dart';
part 'verify_state.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  static VerifyBloc get(context) => BlocProvider.of(context);
  VerifyRepositortyImp verifyRepositortyImp;
  String? image1;
  String? image2;
  VerifyBloc({
    required this.verifyRepositortyImp,
  }) : super(VerifyInitial()) {
    on<Verification>((event, emit) async {
      emit(VerifyLoading());
      if (image1 == null) {
        emit(VerifyFailure(message: Strings.twoImages));
        return;
      }
      var response = await verifyRepositortyImp.verification(
        image1: image1!,
        image2: image2!,
      );
      response.fold((failure) {
        emit(VerifyFailure(message: failure));
      }, (message) {
        emit(VerifySuccess(message: message));
      });
    });
  }

  void selectFromGallery(BuildContext context, index) async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    if (pickedFile != null) {
      XFile? file = pickedFile;
      if (index == 0) {
        image1 = file.path;
        emit(AddImages());
      } else {
        image2 = file.path;
        emit(AddImages());
      }
      //  Navigator.pop(context);
    }

//     await InstaAssetPicker.pickAssets(
//         maxAssets: 1,
//         context,
//         limitedPermissionOverlayPredicate: (PermissionState state) =>
//             false, // here return whether to show the limited access screen or not based on the permission state
//         cropDelegate: const InstaAssetCropDelegate(
//             preferredSize: 1080, cropRatios: [1 / 1, 4 / 5]),
//         onCompleted: (value) {
//           value.listen((event) async {
//             print('in instaaaaaa packaaaage');

//             if (event.croppedFiles.isNotEmpty) {
//               if (index == 0) {
//                 print(event.croppedFiles[0].path);
//                 image1 = event.croppedFiles[0].path;
//                 emit(AddImages());
//               } else {
//                 print(event.croppedFiles[0].path);
//                 image2 = event.croppedFiles[0].path;
//                 emit(AddImages());
//               }
//             }

//             if (event.selectedAssets.isNotEmpty) {
//               File? file = await event.selectedAssets[0].file;
//               if (index == 0) {
//                 image1 = file!.path;
//                 //  image2 = file!.path;
//               }
//               emit(AddImages());
//             }
// /*
//             if (event.selectedAssets.isNotEmpty) {
//               File? file = await event.selectedAssets[0].file;
//               //File? file = await event.selectedAssets[0].file;
//               image1 = file!.path;
//               // image2 = file!.path;
//               emit(AddImages());
//             } else {}*/
//           });
//           print(image1);
//           print(image2);
//           print("selectedImages");

//           Navigator.pop(context);
//         });
  }

  removeImage(index) {
    if (index == 0) {
      image1 = null;
    }
    if (index == 1) {
      image2 = null;
    }
    emit(AddImages());
  }
  /*
  void selectFromGallery(BuildContext context) async {
    List<AssetEntity>? assets = await AssetPicker.pickAssets(
      context,
      //   maxAssets: 2,
    );

    if (assets!.isEmpty) return;

    AssetEntity firstAsset = assets.first;
    File? firstFile = await firstAsset.file;
    image1 = firstFile?.path;

    if (assets.length > 1) {
      AssetEntity secondAsset = assets[1];
      File? secondFile = await secondAsset.file;
      image2 = secondFile?.path;
    }

    emit(AddImages());
  }

  void removeImage(int index) {
    if (index == 0) {
      image1 = null;
    } else if (index == 1) {
      image2 = null;
    }

    emit(AddImages());
  }
  */
}
