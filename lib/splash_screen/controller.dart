import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/login/controller.dart';
import 'package:luvpark_get/routes/routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void onInit() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = CurvedAnimation(
        parent: _controller, curve: Curves.fastEaseInToSlowEaseOut);

    _controller.forward();
    determineInitialRoute();
    super.onInit();
  }

  Future<void> determineInitialRoute() async {
    final data = await Authentication().getUserLogin();
    final uPass = await Authentication().getPasswordBiometric();

    if (data != null) {
      final logData = jsonDecode(data);
      final LoginScreenController lgCt = Get.find<LoginScreenController>();
      lgCt.getAccountStatus(Get.context, logData["mobile_no"], (obj) {
        final items = obj[0]["items"];

        if (items.isEmpty) {
          return;
        }
        if (items[0]["is_active"] == "N") {
          CustomDialog().confirmationDialog(
              Get.context!,
              "Information",
              "Your account is currently inactive. Would you like to activate it now?",
              "Yes",
              "Cancel", () {
            Get.back();
            Get.offAll(() => Routes.activate);
          }, () {
            Get.back();
          });
        } else {
          Map<String, dynamic> postParam = {
            "mobile_no": logData["mobile_no"],
            "pwd": uPass,
          };
          lgCt.postLogin(Get.context, postParam, (data) {
            if (data[0]["items"].isNotEmpty) {
              Get.toNamed(Routes.map);
            }
          });
        }
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Get.toNamed(Routes.onboarding);
      });
    }
  }

  @override
  void onClose() {
    _controller.dispose();
    super.onClose();
  }

  SplashController();
}
