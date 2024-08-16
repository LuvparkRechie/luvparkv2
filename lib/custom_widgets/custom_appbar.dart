import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';

class CustomAppbar extends StatelessWidget {
  final Function? onTap;
  final String? title;
  final List<Widget>? action;
  final Color? bgColor;
  const CustomAppbar({
    super.key,
    this.onTap,
    this.title,
    this.action,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.3,
      centerTitle: true,
      backgroundColor: bgColor ?? Colors.white,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      leading: InkWell(
        onTap: () {
          // defaultBack
          if (onTap == null) {
            Get.back();
            return;
          }
          onTap!();
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.chevron_left,
              color: Colors.black,
            ),
            CustomParagraph(
              text: "Back",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
      leadingWidth: 100,
      title: title == null
          ? null
          : CustomTitle(
              text: title!,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
      actions: action,
    );
  }
}
