// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/edit_image_and_name/presentation/logic/edit_image_and_name_cubit.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/widgets/custom_expandable_panel.dart';

import '../../../../core/validator/validator.dart';

class EditImageAndNameScreen extends StatefulWidget {
  const EditImageAndNameScreen({
    super.key,
    required this.pictures,
    required this.name,
  });

  final List<String> pictures;
  final String name;

  @override
  State<EditImageAndNameScreen> createState() => _EditImageAndNameScreenState();
}

class _EditImageAndNameScreenState extends State<EditImageAndNameScreen> {
  final TextEditingController editNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile> newImages = [];
  Map<int, XFile> replacedImages = {};
  bool showErrorTextOfImage = false;

  @override
  void initState() {
    super.initState();
    ProfileBloc.get(context).getMyProfile();
    editNameController.text = '';
  }

  Future<void> _pickImage({int? replaceIndex}) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      int maxSize = 5 * 1024 * 1024;

      if (imageFile.lengthSync() > maxSize) {
        context.getSnackBar(
          snackText: 'حجم الصورة يجب ان لايتعدى 5 ميجابايت',
          isError: true,
        );
        return;
      }

      setState(() {
        if (replaceIndex != null) {
          if (replaceIndex < widget.pictures.length) {
            replacedImages[replaceIndex] = pickedFile;
          } else if (replaceIndex < widget.pictures.length + newImages.length) {
            newImages[replaceIndex - widget.pictures.length] = pickedFile;
          }
        } else {
          newImages.add(pickedFile);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditImageAndNameCubit(Dio()),
      child: BlocConsumer<EditImageAndNameCubit, EditImageAndNameState>(
        listener: (context, state) {
          if (state is EditImageAndNameUpdated) {
            ProfileBloc.get(context).getMyProfile();
            context.getSnackBar(snackText: 'تم التحديث بنجاح');
          } else if (state is EditImageAndNameLoading) {
            const Center(child: CircularProgressIndicator());
          } else if (state is EditImageAndNameError) {
            context.getSnackBar(snackText: 'لقد حدث خطأ', isError: false);
          } else if (state is EditImageAndNameImageReplaced) {
            ProfileBloc.get(context).getMyProfile();

            replacedImages[state.index] = state.image;
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: CustomScaffold(
              isFullScreen: true,
              bottomNavigationBar: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: CustomButton(
                  onTap: widget.pictures.length + newImages.length == 0
                      ? null
                      : () {
                          final name = editNameController.text.isEmpty
                              ? ProfileBloc.get(context).profileData?.name
                              : editNameController.text;
                          final existingImages = widget.pictures;
                          context.read<EditImageAndNameCubit>().updateProfile(
                                name!,
                                newImages,
                                existingImages,
                                replacedImages,
                              );
                        },
                  text: Strings.saveChnages,
                ),
              ),
              child: BlocConsumer<EditImageAndNameCubit, EditImageAndNameState>(
                listener: (context, state) {
                  if (state is EditImageAndNameUpdated) {
                    ProfileBloc.get(context).getMyProfile();
                  }
                },
                builder: (context, state) {
                  if (state is EditImageAndNameLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final totalImages = widget.pictures.length + newImages.length;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomAppBar(
                          title: Strings.imageAndName,
                          isBack: true,
                          isSettingIcon: true,
                        ),
                        const CustomText(
                          text: Strings.nameIsTriple,
                          color: ColorManager.primaryColor,
                        ),
                        const SizedBox(height: 10),
                        CustomExpandedPanel(
                          isUpdate: true,
                          header: Expanded(
                            child: CustomText(
                              lines: 2,
                              textOverFlow: TextOverflow.fade,
                              text: editNameController.text == ''
                                  ? ProfileBloc.get(context).profileData?.name
                                  : editNameController.text,
                              color: ColorManager.borderColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          expanded: Column(
                            children: [
                              TextFormField(
                                validator: (v) => Validator.isNameValid(v),
                                controller: editNameController,
                                keyboardType: TextInputType.text,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[a-zA-Z\u0621-\u064a- ]")),
                                ],
                                maxLength: 40,
                                decoration: const InputDecoration(
                                  hintText: "",
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 35),
                        const CustomText(
                          text: Strings.add_new_photos,
                          color: ColorManager.primaryColor,
                        ),
                        const SizedBox(height: 10),
                        GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount:
                              (widget.pictures.length + newImages.length < 3)
                                  ? widget.pictures.length +
                                      newImages.length +
                                      1
                                  : widget.pictures.length + newImages.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (index < widget.pictures.length) {
                              return _buildImageItem(
                                context,
                                replaceIndex: index,
                                imageUrl: EndPoints.BASE_URL_image +
                                    widget.pictures[index],
                              );
                            } else if (index <
                                widget.pictures.length + newImages.length) {
                              final newImageIndex =
                                  index - widget.pictures.length;
                              return _buildImageItem(
                                context,
                                replaceIndex:
                                    newImageIndex + widget.pictures.length,
                                imageFile: File(newImages[newImageIndex].path),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () => _pickImage(),
                                child: DottedBorder(
                                  color: ColorManager.primaryColor,
                                  strokeWidth: 2,
                                  dashPattern: const [6],
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(8),
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: double.infinity,
                                        width: double.infinity,
                                        child: Center(
                                          child: Image.asset(
                                            ImageManager.addImageDefult,
                                            width: context.width * 0.15,
                                            height: context.height * 0.2,
                                          ),
                                        ),
                                      ),
                                      const Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Icon(
                                          Icons.add_circle_outline,
                                          color: Color(0xffB9B9B9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                        widget.pictures.length + newImages.length == 0
                            ? const CustomText(
                                text: 'يرجى اضافة صورة على الأقل')
                            : const SizedBox(),
                        const SizedBox(height: 30),
                        const CustomText(text: 'سيتم فحص الصور قبل نشرها'),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageItem(BuildContext context,
      {required int replaceIndex, String? imageUrl, File? imageFile}) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: replacedImages.containsKey(replaceIndex)
              ? Image.file(
                  File(replacedImages[replaceIndex]!.path),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                )
              : (imageFile != null
                  ? Image.file(
                      imageFile,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : (imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (context, url) => const LoadingCircle(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container())), // Handle if no image or URL is available
        ),
        Positioned(
          top: 2,
          left: 2,
          child: GestureDetector(
            onTap: () {
              setState(() {
                replacedImages.remove(replaceIndex);
                if (replaceIndex < widget.pictures.length) {
                  widget.pictures.removeAt(replaceIndex);
                } else {
                  newImages.removeAt(replaceIndex - widget.pictures.length);
                }
              });
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
                radius: 10.0,
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
        Positioned(
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: InkWell(
              onTap: () => _pickImage(replaceIndex: replaceIndex),
              child: Image.asset(
                ImageManager.galleryEdit,
                width: 30,
                height: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
