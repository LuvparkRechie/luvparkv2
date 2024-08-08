import 'package:flutter/material.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color? btnColor;
  final bool? loading;
  final Color? bordercolor;
  final Color? textColor;
  const CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.btnColor,
      this.bordercolor,
      this.textColor,
      this.loading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: btnColor ?? AppColor.primaryColor,
          border: Border.all(color: bordercolor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: loading == null
                ? CustomLinkLabel(
                    text: text,
                    textAlign: TextAlign.center,
                    color: textColor ?? Colors.white,
                  )
                : loading!
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : CustomLinkLabel(
                        text: text,
                        textAlign: TextAlign.center,
                        color: textColor ?? Colors.white,
                      ),
          ),
        ),
      ),
    );
  }
}
