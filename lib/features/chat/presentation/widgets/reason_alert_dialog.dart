import 'package:flutter/material.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/custom_text_field.dart';

class ReasonAlertDialog extends StatelessWidget {
  final Function(String) onSubmit;
  final String title;

  const ReasonAlertDialog({
    Key? key,
    required this.onSubmit,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _controller = TextEditingController();

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(child: CustomText(text: title)),
      content: Form(
        key: _formKey,
        child: SizedBox(
          height: 80,
          child: CustomTextField(
            controller: _controller,
            hintText: 'أدخل السبب هنا',
            maxLines: 5,
            validate: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال السبب.';
              }
              return null;
            },
          ),
        ),
      ),
      actions: <Widget>[
        CustomButton(
          onTap: () {
            if (_formKey.currentState?.validate() ?? false) {
              onSubmit(_controller.text);
              // Navigator.of(context).pop();
              // context.getSnackBar(
              //     snackText: 'تم ارسال الطلب بنجاح', isError: false);
            }
          },
          text: 'أرسال الطلب',
        ),
      ],
    );
  }
}
