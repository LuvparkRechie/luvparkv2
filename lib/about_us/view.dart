import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/about_us/index.dart';

class AboutUs extends GetView<AboutUsController> {
  const AboutUs({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(AboutUsController());
    final AboutUsController ct = Get.put(AboutUsController());
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));
    return PopScope(
      canPop: true, //!ct.isLoadingAmen.value && !ct.isLoadingRoute.value,
      child: Scaffold(
        body: Container(),
      ),
    );
  }
}
