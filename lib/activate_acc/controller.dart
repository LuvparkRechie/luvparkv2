import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';

import '../http/api_keys.dart';
import '../http/http_request.dart';
import '../routes/routes.dart';

class ActivateAccountController extends GetxController {
  ActivateAccountController();
  String parameters = Get.arguments;
  RxBool isAgree = false.obs;
  RxBool isLoading = false.obs;
  RxString? password;
  TextEditingController pinController = TextEditingController();
  Duration countdownDuration = const Duration(minutes: 5);
  Duration duration = const Duration();
  bool isCountdown = false;
  Timer? timer;
  double? mediaQueryWidth;
  String twoDigets(int n) => n.toString().padLeft(2, '0');
  BuildContext? mainContext;

  bool isRequested = false;
  RxString inputPin = "".obs;
  bool isOtpValid = true;
  RxInt minutes = 5.obs;
  RxInt seconds = 0.obs;
  RxInt initialMinutes = 5.obs;
  RxBool isRunning = false.obs;

  @override
  void onInit() {
    pinController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      restartTimer();
    });
    super.onInit();
  }

  void onInputChanged(String value) {
    inputPin.value = value;

    if (pinController.text == inputPin.value.toString()) {
      isOtpValid = true;
    } else {
      isOtpValid = false;
    }
    update();
  }

  Future<void> startTimers() async {
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (timer) {
      if (minutes.value == 0 && seconds.value == 0) {
        timer.cancel(); // Stop the timer
        isRunning.value = false;
      } else if (seconds.value == 0) {
        minutes--;
        seconds.value = 59;
      } else {
        seconds--;
      }
    });

    isRunning.value = true;
  }

  void restartTimer() {
    if (timer!.isActive) {
      timer!.cancel();
    }
    resendFunction();
  }

  void resendFunction() {
    inputPin.value = "";
    CustomDialog().loadingDialog(Get.context!);
    var otpData = {
      "mobile_no": parameters.toString(),
      "reg_type": "REQUEST_OTP"
    };

    HttpRequest(api: ApiKeys.gApiSubFolderPutOTP, parameters: otpData)
        .put()
        .then((returnData) async {
      if (returnData == "No Internet") {
        inputPin.value = "";
        Get.back();
        CustomDialog().errorDialog(Get.context!, "Error",
            "Please check your internet connection and try again.", () {
          Get.back();
        });

        return;
      }
      if (returnData == null) {
        inputPin.value = "";
        Get.back();
        CustomDialog().errorDialog(Get.context!, "Error",
            "Error while connecting to server, Please try again.", () {
          Get.back();
        });

        return;
      }

      if (returnData["success"] == 'Y') {
        Get.back();

        inputPin.value = returnData["otp"];
        isRequested = true;

        resetTimer();
        CustomDialog().successDialog(Get.context!, "Success",
            "OTP has been sent to your registered mobile number.", "Okay", () {
          Get.back();
        });
      } else {
        inputPin.value = "";
        Get.back();
        CustomDialog().errorDialog(Get.context!, "LuvPark", returnData["msg"],
            () {
          Get.back();
        });
      }
    });
  }

  Future<void> verifyAccount() async {
    if (pinController.text.isEmpty) return;

    CustomDialog().loadingDialog(Get.context!);
    var otpData = {
      "mobile_no": parameters.toString(),
      "reg_type": "VERIFY",
      "otp": int.parse(pinController.text)
    };

    HttpRequest(api: ApiKeys.gApiSubFolderPutOTP, parameters: otpData)
        .put()
        .then((returnData) async {
      print("retdata$returnData");
      if (returnData == "No Internet") {
        Get.back();
        CustomDialog().errorDialog(Get.context!, "Error",
            'Please check your internet connection and try again.', () {
          Get.back();
        });

        return;
      }
      if (returnData == null) {
        Get.back();
        CustomDialog().errorDialog(Get.context!, "Error",
            "Error while connecting to server, Please try again.", () {
          Get.back();
        });

        return;
      }
      if (returnData["success"] == 'Y') {
        Get.back();
        // ignore: use_build_context_synchronously

        CustomDialog().successDialog(
          Get.context!,
          "Success",
          "Congratulations! Your account has been activated!",
          "Okay",
          () {
            Get.offAllNamed(Routes.login);
          },
        );
      } else {
        Get.back();
        CustomDialog().errorDialog(Get.context!, "Error",
            "Invalid OTP code. Please try again.. Please try again.", () {
          pinController.text = "";
          Get.back();
        });
      }
    });
  }

  void addTime() {
    final addSeconds = isCountdown ? -1 : 1;

    final seconds = duration.inSeconds + addSeconds;

    if (seconds == 0) {
      timer?.cancel();
      isCountdown = false;
    } else {
      duration = Duration(seconds: seconds);
    }
  }

  void resetTimer() {
    isCountdown = true;

    duration = countdownDuration;
  }

  @override
  void onClose() {
    timer!.cancel();
    super.onClose();
  }
}
