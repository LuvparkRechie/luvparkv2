import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../custom_widgets/alert_dialog.dart';
import '../http/api_keys.dart';
import '../http/http_request.dart';

class WalletOtpController extends GetxController {
  WalletOtpController();
  List paramArgs = Get.arguments;
  TextEditingController pinController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isInternetConn = true.obs;
  RxBool isOtpValid = true.obs;
  RxBool isRunning = false.obs;
  RxBool isCanSend = false.obs;
  Timer? timer;
  RxString inputPin = "".obs;
  RxInt minutes = 5.obs;
  RxInt seconds = 0.obs;
  RxInt initialMinutes = 5.obs;

  @override
  void onInit() {
    pinController = TextEditingController();
    startTimers();
    super.onInit();
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

  void onInputChanged(String value) {
    inputPin.value = value;

    if (pinController.text == paramArgs[0]["otp"].toString()) {
      isOtpValid.value = true;
    } else {
      isOtpValid.value = false;
    }
    update();
  }

  void restartTimer() {
    if (timer!.isActive) {
      timer!.cancel();
    }
    resendFunction();
  }

  Future<void> resendFunction() async {
    isLoading.value = true;
    isInternetConn.value = true;
    var otpData = {
      "mobile_no": paramArgs[0]["mobile_no"],
      "reg_type": "REQUEST_OTP"
    };
    HttpRequest(api: ApiKeys.gApiSubFolderPutOTP, parameters: otpData)
        .put()
        .then((otpData) {
      if (otpData == "No Internet") {
        isInternetConn.value = false;
        isLoading.value = false;
        CustomDialog().internetErrorDialog(Get.context!, () {
          Get.back();
        });
        return;
      }
      if (otpData == null) {
        isInternetConn.value = true;
        isLoading.value = false;

        CustomDialog().serverErrorDialog(Get.context!, () {
          Get.back();
        });
        return;
      }
      if (otpData["success"] == 'Y') {
        isInternetConn.value = true;
        isLoading.value = false;
        paramArgs = paramArgs.map((e) {
          e["otp"] = int.parse(otpData["otp"]);
          return e;
        }).toList();
        inputPin.value = "";
        minutes.value = initialMinutes.value;
        seconds.value = 0;
        isRunning.value = false;
        startTimers();
        CustomDialog().successDialog(Get.context!, "Success",
            "OTP has been sent to your registered mobile number.", "Okay", () {
          Get.back();
        });
      } else {
        isInternetConn.value = true;
        isLoading.value = false;
        CustomDialog().errorDialog(Get.context!, "luvpark", otpData["msg"], () {
          Get.back();
        });
      }
    });
  }

  void onVerify() {
    // isLoading.value = true;
    // if (paramArgs[0]['otp'] == int.parse(inputPin.value)) {
    //   var otpData = {
    //     "mobile_no": paramArgs[0]["mobile_no"],
    //     "reg_type": "VERIFY",
    //     "otp": int.parse(inputPin.value)
    //   };

    //   HttpRequest(api: ApiKeys.gApiSubFolderPutOTP, parameters: otpData)
    //       .put()
    //       .then((returnData) async {
    //     if (returnData == "No Internet") {
    //       isLoading.value = false;
    //       CustomDialog().internetErrorDialog(Get.context!, () {
    //         Get.back();
    //       });
    //       return;
    //     }
    //     if (returnData == null) {
    //       isLoading.value = false;
    //       CustomDialog().serverErrorDialog(Get.context!, () {
    //         Get.back();
    //       });
    //       return;
    //     }
    //     if (returnData["success"] == 'Y') {
    //       final LoginScreenController lct = Get.put(LoginScreenController());
    //       timer!.cancel();

    //       Map<String, dynamic> postParam = {
    //         "mobile_no": paramArgs[0]["mobile_no"],
    //         "pwd": paramArgs[0]["new_pass"],
    //       };

    //       lct.postLogin(Get.context, postParam, (data) {
    //         isLoading.value = false;
    //         if (data[0]["items"].isNotEmpty) {
    //           FocusManager.instance.primaryFocus?.unfocus();
    //           Navigator.of(Get.context!).pushReplacement(
    //             MaterialPageRoute(
    //               builder: (context) => const SuccessRegistration(),
    //             ),
    //           );
    //         }
    //       });
    //     } else {
    //       isLoading.value = false;
    //       CustomDialog().errorDialog(Get.context!, "luvpark", returnData["msg"],
    //           () {
    //         Get.back();
    //       });
    //     }
    //   });
    // } else {
    //   isLoading.value = false;
    //   CustomDialog().errorDialog(
    //       Get.context!, "luvpark", "Invalid OTP code. Please try again.", () {
    //     Get.back();
    //   });
    // }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
