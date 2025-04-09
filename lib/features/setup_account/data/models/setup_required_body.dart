import 'package:zawaj/features/setup_account/data/models/params_model.dart';

class SetupRequiredBody {
  int? searchGender;

  bool? isSmoking;
  int? maxAge;
  int? minAge;
  int? maxWeight;
  int? minWeight;
  int? maxHeight;
  int? minHeight;
  List<ValueBody>? selectionModel;
  SetupRequiredBody({
    required this.searchGender,
    required this.maxAge,
    required this.minAge,
    required this.selectionModel,
    required this.isSmoking,
    required this.maxHeight,
    required this.maxWeight,
    required this.minHeight,
    required this.minWeight,
  });

  Map<String, dynamic> toJson() => {
        "SearchGender": searchGender,
        "MinAge": minAge,
        "MaxAge": maxAge,
        "MinWeight": minWeight,
        "MaxWeight": maxWeight,
        "MinHeight": minHeight,
        "MaxHeight": maxHeight,
        // "Height": height,
        // "Weight": weight,
        "IsSmoking": isSmoking,
        "selectionModel": selectionModel == null
            ? []
            : List<dynamic>.from(selectionModel!.map((x) => x.toJson())),
      };
}

// class ValueListBody {
//   int? parameterId;
//   int? valueId;
//   String? valueName;

//   ValueListBody({
//     this.parameterId,
//     this.valueId,
//     this.valueName,
//   });

//   Map<String, dynamic> toJson() => {
//     "parameterId": parameterId,
//     "valueId": valueId,
//     "value": valueName,
//   };
// }
