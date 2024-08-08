import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController
    with GetSingleTickerProviderStateMixin {
  OtpController();
  final paramArgs = Get.arguments;
  TextEditingController pinController = TextEditingController();
  RxBool isShowPass = false.obs;
  RxBool isLoading = false.obs;
  RxBool isOtpValid = false.obs;
  RxString inputPin = "".obs;

  bool isOtp = false;
  bool isInternetConnected = true;

  void toggleLoading(bool value) {
    isLoading.value = value;
  }

  void onInputChanged(String value) {
    inputPin.value = value;
    print("inputPin.value ${inputPin.value}");
    if (pinController.text == paramArgs[0]["otp"].toString()) {
      isOtpValid.value = true;
    } else {
      isOtpValid.value = false;
    }
    update();
  }

  void onChangedBool(bool isValid) {}

  @override
  void onInit() {
    pinController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
