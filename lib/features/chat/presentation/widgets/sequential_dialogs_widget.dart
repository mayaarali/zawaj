import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/widgets/custom_text.dart';

class SequentialInstructionsDialogs extends StatefulWidget {
  @override
  _SequentialInstructionsDialogsState createState() =>
      _SequentialInstructionsDialogsState();
}

class _SequentialInstructionsDialogsState
    extends State<SequentialInstructionsDialogs> {
  bool _dialogsShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dialogsShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSequentialDialogs(context);
      });
    }
  }

  void _showSequentialDialogs(BuildContext context) {
    int currentIndex = 0;
    List<String> points = [
      "1. إذا كنت ذكرًا أم أنثى، عليك التعهد بإعلام أهلك حول رغبتك في إستخدام التطبيق من أجل التعارف الامن والمشروع.",
      "2. خدمة المراسلة سوف تكون مع مشترك / مشتركة واحدة فقط، وسيتمّ حجب إمكانيّة التّواصل مع مشتركين آخرين في التّطبيق.",
      "3. خدمة المراسلة ستكون مفتوحة لمدّة أسبوعين فقط مع إمكانيّة تمديد الفترة لأسبوع إضافيّ، بناءً على طلب أحد المشتركين، وبعد مصادقة إدارة التّطبيق."
    ];

    void showNextDialog() {
      if (currentIndex < points.length) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ImageManager.heartLogo,
                  ),
                  const CustomText(
                    text: "عزيزي المشترك",
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  const CustomText(
                      text: " عليك المصادقة على الأمور التالية:", fontSize: 16),
                ],
              ),
              content: CustomText(
                align: TextAlign.start,
                text: points[currentIndex],
                color: Colors.black,
              ),
              actions: <Widget>[
                if (currentIndex > 0)
                  TextButton(
                    onPressed: () {
                      currentIndex--;
                      Navigator.of(context).pop();
                      showNextDialog();
                    },
                    child: const CustomText(text: "السابق"),
                  ),
                TextButton(
                    onPressed: () {
                      if (currentIndex < points.length - 1) {
                        currentIndex++;
                        Navigator.of(context).pop();
                        showNextDialog();
                      } else {
                        Navigator.of(context).pop();
                        setState(() {
                          _dialogsShown = true;
                        });
                      }
                    },
                    child: CustomText(
                        text: currentIndex < points.length - 1
                            ? "التالي"
                            : "فهمت")),
              ],
            );
          },
        ).then((_) {
          setState(() {
            _dialogsShown = true;
          });
        });
      }
    }

    showNextDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
