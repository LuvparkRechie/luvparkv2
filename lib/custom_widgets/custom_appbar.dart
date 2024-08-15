import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';

class CustomAppbar extends StatelessWidget {
  final Function? onTap;
  final String title;
  final List<Widget>? action;
  final Color? bgColor;
  const CustomAppbar({
    super.key,
    this.onTap,
    required this.title,
    this.action,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: bgColor ?? Colors.white,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
            onPressed: () {
              //defaultBack
              if (onTap == null) {
                Get.back();
                return;
              }
              onTap!();
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
      leadingWidth: 100,
      title: CustomTitle(
        text: title,
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: Colors.black,
      ),
      actions: action,
    );
  }
}
