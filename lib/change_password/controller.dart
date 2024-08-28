import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/variables.dart';

class ChangePasswordController extends GetxController
    with GetSingleTickerProviderStateMixin {
  ChangePasswordController();

  final GlobalKey<FormState> formKeyChangePass = GlobalKey<FormState>();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  RxBool isShowOldPass = false.obs;
  RxBool isShowNewPass = false.obs;
  RxInt passStrength = 0.obs;

  @override
  void onInit() {
    oldPassword = TextEditingController();
    newPassword = TextEditingController();
    super.onInit();
  }

  void onToggleOldPass(bool isShow) {
    isShowOldPass.value = isShow;
    update();
  }

  void onToggleNewPass(bool isShow) {
    isShowNewPass.value = isShow;
    update();
  }

  void onPasswordChanged(String value) {
    passStrength.value = Variables.getPasswordStrength(value);
    update();
  }

  @override
  void onClose() {
    super.onClose();
    formKeyChangePass.currentState!.reset();
  }
}
