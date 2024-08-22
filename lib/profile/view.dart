import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_appbar.dart';
import 'package:luvpark_get/profile/controller.dart';

class Profile extends GetView<ProfileScreenController> {
  const Profile({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(ProfileScreenController());
    //final ProfileScreenController ct = Get.put(ProfileScreenController());
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: AppColor.bodyColor,
      appBar: const CustomAppbar(title: "My Profile"),
      body: Container(),
    );
  }
}
