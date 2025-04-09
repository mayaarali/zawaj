import 'package:flutter/material.dart';
import '../blocs/language/language_cubit.dart';
import 'drop_down_widget.dart';

// ignore: must_be_immutable
class MyDropDownWidget extends StatefulWidget {
  MyDropDownWidget({super.key, required this.isLanguage});
  bool isLanguage;
  @override
  State<MyDropDownWidget> createState() => _MyWidgetState();
}

bool isTapped = false;
List language = ["English", "العربيه"];
List icons = ["En", "Ar"];
List countries = ["Egypt", "Alexandria"];
List countriesImage = ["En", "Ar"];
String selectedLanguage = language[1];
String selectedIcon = icons[1];
String selectedCountry = countries[1];
String selectedFlag = countriesImage[1];

class _MyWidgetState extends State<MyDropDownWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      InkWell(
        onTap: () {
          setState(() {
            isTapped = !isTapped;
            debugPrint(isTapped.toString());
          });
        },
        child: dropDownWidget(
            size: size,
            border: true,
            withOutArrow: false,
            isLanguge: widget.isLanguage,
            title: widget.isLanguage ? selectedLanguage : selectedCountry,
            icon: widget.isLanguage
                ? Text(selectedIcon.toString())
                : Image.network(
                        "https://th.bing.com/th/id/OIP.87a1JiiKTTx9BwkP5dyNsAHaEo?pid=ImgDet&rs=1")
                    .image),
      ),
      SizedBox(
        height: size.height * 0.01,
      ),
      isTapped
          ? Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xffD8D8D8)),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(widget.isLanguage
                          ? () {
                              selectedLanguage = language[0];
                              selectedIcon = icons[0];
                              LanguageCubit.get(context).isSelected(context, true);
                            }
                          : () {
                              selectedCountry = countries[0];
                              selectedFlag = countriesImage[0];
                            });
                    },
                    child: dropDownWidget(
                        isLanguge: widget.isLanguage,
                        size: size,
                        border: false,
                        withOutArrow: true,
                        title: widget.isLanguage ? language[0] : countries[0],
                        icon: widget.isLanguage
                            ? Text(icons[0])
                            : Image.network(
                                    "https://th.bing.com/th/id/OIP.87a1JiiKTTx9BwkP5dyNsAHaEo?pid=ImgDet&rs=1")
                                .image),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () {
                      setState(widget.isLanguage
                          ? () {
                              selectedLanguage = language[1];
                              selectedIcon = icons[1];
                              LanguageCubit.get(context).isSelected(context, false);
                            }
                          : () {
                              selectedCountry = countries[1];
                              selectedFlag = countriesImage[1];
                            });
                    },
                    child: dropDownWidget(
                        isLanguge: widget.isLanguage,
                        size: size,
                        border: false,
                        withOutArrow: true,
                        title: widget.isLanguage ? language[1] : countries[1],
                        icon: widget.isLanguage
                            ? Text(icons[1])
                            : Image.network(
                                    "https://th.bing.com/th/id/OIP.87a1JiiKTTx9BwkP5dyNsAHaEo?pid=ImgDet&rs=1")
                                .image),
                  ),
                ],
              ))
          : const SizedBox(
              height: 0,
            ),
    ]);
  }
}
