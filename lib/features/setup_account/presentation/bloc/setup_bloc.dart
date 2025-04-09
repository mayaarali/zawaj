import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/features/setup_account/data/models/area_model.dart';
import 'package:zawaj/features/setup_account/data/models/city_model.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/event.dart';

import '../../data/models/params_model.dart';
import '../../data/repository/setup_repository.dart';
import 'states.dart';

class SetUpBloc extends Bloc<SetUpEvent, SetUpStates> {
  SetUpRepositoryImp setupRepositoryImp;

  static SetUpBloc get(context) => BlocProvider.of(context);
  List<String> checkedItemValue = [];
  TextEditingController controllerName = TextEditingController();
  RangeValues selectedAgeRange = const RangeValues(17, 40);
  RangeValues weightRange = const RangeValues(0, 1);
  RangeValues heightRange = const RangeValues(0, 1);
  var birthDropValue;
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController minHeightRequiredController = TextEditingController();
  TextEditingController minWeightRequiredController = TextEditingController();
  List<ParamsModel> parms = [];
  SetUpBloc({required this.setupRepositoryImp}) : super(InitStates()) {
    on<PostSetUpEvent>((event, emit) async {
      emit(LoadingSetUp());
      var response = await setupRepositoryImp.postSetup(setUpMap);
      response.fold((failure) {
        emit(FailedSetUp(message: failure));
      }, (message) {
        selectedImages = List.filled(3, null);
        emit(SuccessSetUp());
      });
    });

    on<UpdateSetUpEvent>((event, emit) async {
      emit(LoadingRequiredSetUp());
      var response = await setupRepositoryImp.updateSetup(setUpMap);
      response.fold((failure) {
        emit(FailedRequiredSetUp(message: failure));
      }, (message) {
        selectedImages = List.filled(3, null);
        emit(SuccessRequiredSetUp());
      });
    });
    on<UpdatePertnerEvent>((event, emit) async {
      emit(LoadingRequiredSetUp());
      var response =
          await setupRepositoryImp.updatePartner(event.setupRequiredBody);
      response.fold((failure) {
        emit(FailedUpdatePartner(message: failure));
      }, (message) {
        emit(SuccessRequiredSetUp());
      });
    });

    on<PostSetUpRequiredEvent>((event, emit) async {
      emit(LoadingRequiredSetUp());
      var response =
          await setupRepositoryImp.postRequired(event.setupRequiredBody);
      response.fold((failure) {
        emit(FailedRequiredSetUp(message: failure));
      }, (message) {
        defaultSetUpMap();
        emit(SuccessRequiredSetUp());
      });
    });
  }

  Map<String, dynamic> setUpMap = {
    "Religion": null,
    "Gender": 0,
    "SearchGender": 1,
    "Name": "",
    "BirthDay": null,
    "MaritalStatus": null,
    "CityId": null,
    "AreaId": null,
    "Height": 0,
    "Weight": 0,
    "IsSmoking": false,
    "MaxAge": 1,
    "MinAge": 1,
  };
  final bool isMale = false;
  List<String?> selectedImages = List.filled(3, null);
  List<List<Checked?>?> isChecked = [];

  defaultSetUpMap() {
    setUpMap = {
      "Religion": null,
      "Gender": 0,
      "SearchGender": 1,
      "Name": "",
      "BirthDay": null,
      "MaritalStatus": null,
      "CityId": null,
      "AreaId": null,
      "Height": null,
      "Weight": null,
      "IsSmoking": false,
      "MaxAge": 0,
      "MinAge": 0,
    };
  }

  changeMapValue({key, value}) {
    setUpMap[key] = value;
    print('changeMapValue$key $value');
    print(setUpMap);

    emit(MapValueStates());
  }

  removeImage(index) {
    selectedImages[index] = null;
    emit(SetUpImages());
  }

  cropImage(index) async {
    // selectedImages[index] = null;
    if (selectedImages.isNotEmpty) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: selectedImages[index]!,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '',
            toolbarColor: ColorManager.primaryColor,
            toolbarWidgetColor: Colors.white,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
          ),
          IOSUiSettings(
            title: '',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              // IMPORTANT: iOS supports only one custom aspect ratio in preset list
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        selectedImages[index] = croppedFile.path;
        emit(SetUpImages());
      }
    }

    //  emit(SetUpImages());
  }

  changeAgeRangeValue(values, {isWeight = false, isHeight = false}) {
    if (isHeight) {
      heightRange = values;
    } else if (isWeight) {
      weightRange = values;
    } else {
      selectedAgeRange = values;
    }

    emit(MapValueStates());
  }

  void selectFromGallery(BuildContext context, int index) async {
    await InstaAssetPicker.pickAssets(
        maxAssets: 1,
        context,
        limitedPermissionOverlayPredicate: (PermissionState state) => false,
        cropDelegate: const InstaAssetCropDelegate(
            preferredSize: 1080, cropRatios: [1 / 1, 4 / 5]),
        onCompleted: (value) {
          value.listen((event) async {
            print('in instaaaaaa packaaaage');

            if (event.croppedFiles.isNotEmpty) {
              ///Cropped///
              print(event.croppedFiles[0].path);
              selectedImages[index] = event.croppedFiles[0].path;
              emit(SetUpImages());
              // selectedImages.add(event.croppedFiles[0].path);
              // event.croppedFiles.forEach((element) {
              //   selectedImages[index]=element.path;
              //
              //
              // });
            }
            if (event.selectedAssets.isNotEmpty) {
              File? file = await event.selectedAssets[0].file;
              selectedImages[index] = file!.path;
              emit(SetUpImages());
            } else {}
          });
          print('${selectedImages.length}');
          print(selectedImages);
          print("selectedImages");

          Navigator.pop(context);
        });
  }

  List<ValueBody?>? dropValueBodyList = [];
  List<ValueBody?>? multiSelectList = [];
  List<Value?>? dropValueList = [];
  List<String?> textParams = [];
  fillSetupCollectList(List<ParamsModel> paramsList, {isUpdate = false}) {
    multiSelectList = [];
    print('fillSetupCollectList');
    dropValueBodyList = List.filled(paramsList.length, null);
    dropValueList = List.filled(paramsList.length, null);
    isChecked = List.filled(paramsList.length, null);
    textParams = List.filled(paramsList.length, null);
    log(isChecked.length.toString());
    log("isChecked.length");

    for (int i = 0; i < paramsList.length; i++) {
      if (paramsList[i].type == 1) {
        isChecked[i] = List.filled(paramsList[i].values!.length, null);

        for (int i2 = 0; i2 < paramsList[i].values!.length; i2++) {
          // isChecked[i]!.add(Checked(value:false ,index:element.id));

          isChecked[i]![i2] =
              Checked(value: false, index: paramsList[i].values![i2].id);
        }

        isChecked[i]!.forEach((element) {
          print('in blooooc len1 is ==>${element!.value} ${element!.index}');
        });
      }
    }
    log('in blooooc len is ==>$isChecked');
    emit(MapValueStates());
  }

  changeDropList(index, Value? value, paramId) {
    if (value == null) {
      dropValueList![index] = null;
      dropValueBodyList![index] = null;
    } else {
      dropValueList![index] = value;
      dropValueBodyList![index] =
          ValueBody(paramId: paramId, value: value!.value, valueId: value.id);
    }

    emit(MapValueStates());
  }

  CityModel? cityDropModel;
  changeDropListCity(value) {
    cityDropModel = value;
    areaDropModel = null;
    emit(MapValueStates());
  }

  AreaModel? areaDropModel;
  changeDropListArea(value) {
    areaDropModel = value;
    emit(MapValueStates());
  }

  DateTime selectedDate = DateTime(
      DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);
  bool selectedDone = false;
  DateTime laastdate = DateTime(
      DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);

  selectDatee(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      keyboardType: TextInputType.datetime,
      locale: const Locale('ar'),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: const TextTheme(
              bodyLarge: TextStyle(fontSize: 15.0, color: Colors.black),
            ),
          ),
          child: child!,
        );
      },
      confirmText: 'حسنآ',
      cancelText: 'الغاء',
      helpText: 'تحديد التاريخ',
      barrierLabel: 'أدخل التاريخ',
      fieldLabelText: 'أدخل التاريخ',
      errorFormatText: 'تنسيق التاريخ غير صالح',
      errorInvalidText: 'تاريخ غير صالح',
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: laastdate,
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      selectedDone = true;
      changeMapValue(key: "BirthDay", value: selectedDate);
    }

    emit(SelectDateeState());
  }

  changeControllers(value, bool isHeight) {
    if (isHeight) {
      heightController.text = value;
    } else {
      weightController.text = value;
    }
  }
}
