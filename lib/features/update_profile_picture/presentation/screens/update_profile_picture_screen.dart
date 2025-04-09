import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/build_dialog.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zawaj/features/update_profile_picture/data/update_profile_picture_repository.dart';
import 'package:zawaj/features/update_profile_picture/domain/useCase/concrete_update_profile_picture_use_case.dart';
import 'package:zawaj/features/update_profile_picture/presentation/cubit/update_profile_picture_cubit.dart';

class UpdateProfilePictureScreen extends StatefulWidget {
  final List<String> pictures;

  const UpdateProfilePictureScreen({
    Key? key,
    required this.pictures,
  }) : super(key: key);

  @override
  _UpdateProfilePictureScreenState createState() =>
      _UpdateProfilePictureScreenState();
}

class _UpdateProfilePictureScreenState
    extends State<UpdateProfilePictureScreen> {
  late List<File> _imageFiles;
  late List<int> _updatedIndices;

  @override
  void initState() {
    super.initState();
    ProfileBloc.get(context).getMyProfile();

    _imageFiles = List.generate(
      widget.pictures.length,
      (index) => File(widget.pictures[index]),
    );
    _updatedIndices = [];
    _imageFiles = List.generate(
        widget.pictures.length, (index) => File(widget.pictures[index]));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> profileImages = List.generate(3, (index) {
      if (index < widget.pictures.length) {
        final String? imagePath = widget.pictures[index];
        if (imagePath != null && imagePath.isNotEmpty) {
          return buildProfileImage(index, File(imagePath), context);
        }
      }
      return buildPlaceholderContainer(context, index);
    });
    if (profileImages.length >= 3) {
      final itemAtIndex0 = profileImages.length > 0
          ? profileImages[0]
          : buildPlaceholderContainer(context, 0);
      final itemAtIndex1 = profileImages.length > 1
          ? profileImages[1]
          : buildPlaceholderContainer(context, 1);
      final itemAtIndex2 = profileImages.length > 2
          ? profileImages[2]
          : buildPlaceholderContainer(context, 2);

      profileImages.clear();
      profileImages.addAll([itemAtIndex0, itemAtIndex1, itemAtIndex2]);
    }
    return Scaffold(
      body: BlocProvider(
        create: (context) => UpdateProfilePictureCubit(
          ConcreteUpdateProfilePictureUseCase(UpdateProfilePictureRepository()),
        ),
        child: BlocConsumer<UpdateProfilePictureCubit, dynamic>(
          listener: (context, state) {
            if (state is UpdateProfilePictureError) {
              context.getSnackBar(snackText: 'لقد حدث خطأ', isError: true);
            } else if (state is UpdateProfilePictureSuccess) {
              context.getSnackBar(snackText: 'تم تحديث الصور الشخصية بنجاح');
              ProfileBloc.get(context).getMyProfile();
            }
          },
          builder: (context, state) {
            if (state is UpdateProfilePictureLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      CustomAppBar(
                        title: Strings.add_photos,
                        leading: InkWell(
                            onTap: () => buildDialog(
                                onTapEnter: () {
                                  MagicRouter.goBack();
                                },
                                buttonTitle: Strings.undersrtand,
                                title: Strings.why_photo,
                                desc: Strings.increase_watchers,
                                context: context),
                            child: const Icon(
                              Icons.info_outline,
                              color: ColorManager.primaryColor,
                            )),
                        isBack: true,
                      ),
                      Column(
                        children: [
                          if (profileImages.isNotEmpty)
                            profileImages[0]
                          else
                            buildPlaceholderContainer(context, 0),
                          if (profileImages.length > 1)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                profileImages.length > 1
                                    ? profileImages[1]
                                    : buildPlaceholderContainer(context, 1),
                                profileImages.length > 2
                                    ? profileImages[2]
                                    : buildPlaceholderContainer(context, 2),
                              ],
                            ),
                        ],
                      ),
                      CustomButton(
                        onTap: () {
                          //_updateProfilePictures(context);
                          //if (_updatedIndices.isNotEmpty) {
                          _updateProfilePictures(context);
                          // }
                          // else {
                          //   context.getSnackBar(
                          //     snackText: 'يجب إضافة صورة واحدة على الأقل ',
                          //   );
                          // }
                        },
                        text: Strings.update_photos,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildImageList(BuildContext context) {
    return Column(
      children: _imageFiles.asMap().entries.map((entry) {
        final index = entry.key;
        final file = entry.value;
        return buildProfileImage(index, file, context);
      }).toList(),
    );
  }

  Widget buildProfileImage(int index, File imageFile, BuildContext context) {
    final bool imageUpdated = _updatedIndices.contains(index);
    final bool isFirstImage = index == 0;
    final String? imagePath = widget.pictures[index];

    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: InkWell(
        onTap: () {
          _pickImage(context, index);
        },
        child: Stack(
          children: [
            Column(
              children: [
                if (imagePath == null || imagePath.isEmpty)
                  Container(
                    color: Colors.grey.shade200,
                    height: isFirstImage
                        ? context.height * 0.5
                        : context.height * 0.3,
                    width: isFirstImage ? context.width : context.width * 0.4,
                    child: isFirstImage
                        ? const Icon(Icons.add_circle_outline,
                            color: Colors.white)
                        : const Icon(Icons.add_circle_outline,
                            color: Colors.black),
                  )
                else if (imageUpdated)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      _imageFiles[index],
                      height: isFirstImage
                          ? context.height * 0.5
                          : context.height * 0.3,
                      width: isFirstImage ? context.width : context.width * 0.4,
                      fit: BoxFit.fill,
                    ),
                  )
                else if (imagePath != null && imagePath.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: '${EndPoints.BASE_URL_image}$imagePath',
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: isFirstImage
                              ? context.width
                              : context.width * 0.4,
                          height: isFirstImage
                              ? context.height * 0.5
                              : context.height * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      height: isFirstImage
                          ? context.height * 0.5
                          : context.height * 0.3,
                      width: isFirstImage ? context.width : context.width * 0.4,
                      fit: BoxFit.fill,
                    ),
                  ),
                const SizedBox(height: 20.0),
              ],
            ),
            if (imagePath != null && imagePath.isNotEmpty)
              Positioned(
                top: 10,
                right: 5,
                left:
                    isFirstImage ? context.width * 0.75 : context.width * 0.32,
                child: InkWell(
                  onTap: () {
                    _removeImage(context, index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorManager.primaryColor,
                        width: 2.0,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 15.0,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.close,
                        color: ColorManager.primaryColor,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Future<void> _pickImage(BuildContext context, int index) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       if (index >= widget.pictures.length) {
  //         widget.pictures.add("");
  //         _imageFiles.add(File(""));
  //       }
  //       widget.pictures[index] = pickedFile.path;
  //       _imageFiles[index] = File(pickedFile.path);

  //       if (!_updatedIndices.contains(index)) {
  //         _updatedIndices.add(index);
  //       }
  //     });
  //   }
  // }
  Future<void> _pickImage(BuildContext context, int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Check file size
      int maxSize = 5 * 1024 * 1024; // 5 MB in bytes
      if (imageFile.lengthSync() > maxSize) {
        context.getSnackBar(
            snackText: 'حجم الصورة يجب ان لايتعدى 5 ميجابايت', isError: true);

        return;
      }

      setState(() {
        if (index >= widget.pictures.length) {
          widget.pictures.add("");
          _imageFiles.add(File(""));
        }
        widget.pictures[index] = pickedFile.path;
        _imageFiles[index] = imageFile;

        if (!_updatedIndices.contains(index)) {
          _updatedIndices.add(index);
        }
      });
    }
  }

  Future<void> _updateProfilePictures(BuildContext context) async {
    final cubit = context.read<UpdateProfilePictureCubit>();

    final updatedImageFiles =
        _updatedIndices.map((index) => _imageFiles[index]).toList();

    final updatedExistingImagePaths = widget.pictures
        .where(
            (path) => !_updatedIndices.contains(widget.pictures.indexOf(path)))
        .toList();

    List checkOldList = [];
    updatedExistingImagePaths.forEach((e) {
      if (e != '') {
        checkOldList.add(e);
      }
    });
    if (updatedImageFiles.isNotEmpty || checkOldList.isNotEmpty
        //||updatedExistingImagePaths[0].trim()==''
        ) {
      try {
        await cubit.updateProfilePictures(
          imageFiles: updatedImageFiles,
          existingImagePaths: updatedExistingImagePaths,
        );
      } catch (e) {
        context.getSnackBar(
          snackText: 'Failed to update profile picture',
          isError: true,
        );
      }
    } else {
      context.getSnackBar(
        isError: true,
        snackText: 'يجب إضافة صورة واحدة على الأقل ',
      );
    }
  }

  Widget buildPlaceholderContainer(BuildContext context, int index) {
    final bool isFirstImage = index == 0;

    return InkWell(
      onTap: () {
        _pickImage(context, index);
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10)),
            height: isFirstImage ? context.height * 0.5 : context.height * 0.3,
            width: isFirstImage ? context.width : context.width * 0.4,
            child: const Icon(Icons.add_circle_outline, color: Colors.white),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  void _removeImage(BuildContext context, int index) {
    setState(() {
      widget.pictures[index] = ""; // Clear the path
      _imageFiles[index] = File(""); // Clear the file
      _updatedIndices.remove(index); // Remove from updated indices
    });
  }
}
