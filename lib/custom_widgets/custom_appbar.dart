import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';

class CustomAppbar extends StatelessWidget {
  final Function onTap;
  final String title;
  final Widget? action;
  final Color? bgColor;
  const CustomAppbar(
      {super.key,
      required this.onTap,
      required this.title,
      required this.action,
      this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor ?? Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    onTap();
                  },
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                  ),
                ),
                const CustomParagraph(
                  text: "Back",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: CustomTitle(
                text: title,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 15),
                child: action,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
