import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/custom_widgets/page_loader.dart';
import 'package:luvpark_get/http/api_keys.dart';
import 'package:luvpark_get/http/http_request.dart';

import '../custom_widgets/alert_dialog.dart';
import '../functions/functions.dart';

class WalletSendController extends GetxController
    with GetSingleTickerProviderStateMixin {
  WalletSendController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController recipient = TextEditingController();
  final TextEditingController tokenAmount = TextEditingController();
  final TextEditingController message = TextEditingController();
  final TextEditingController sub = TextEditingController();
  final GlobalKey contentKey = GlobalKey();
  RxBool isLpAccount = false.obs;
  RxBool isLoading = true.obs;
  RxBool isBtnDisabled = true.obs;
  RxBool isInternetConn = true.obs;
  RxBool isValidNumber = false.obs;
  RxList userData = [].obs;
  RxList logs = [].obs;
  RxInt denoInd = 0.obs;
  RxDouble amountBalance = 0.0.obs;
  RxString myBalance = "".obs;
  RxInt indexbtn = 0.obs;
  RxList<int> padNumbers = [10, 20, 30, 40, 50, 100, 200, 250].obs;
  void onPageChanged(bool agree) {
    update();
  }

  Future<void> onTextChange() async {
    denoInd.value = -1;

    if (recipient.value.text.isEmpty ||
        tokenAmount.text.isEmpty ||
        double.parse(
                tokenAmount.text.replaceAll(",", "").replaceAll(".", "")) <=
            0) {
      isBtnDisabled.value = true;
    } else {
      isBtnDisabled.value = false;
    }
  }

  Future<void> getConsumersData() async {
    Functions.getUserBalance(Get.context!, (dataBalance) async {
      if (!dataBalance[0]["has_net"]) {
        isLoading.value = false;
        isInternetConn.value = false;
        return;
      } else {
        userData.value = dataBalance[0]["items"];
        getLogs();
      }
    });
  }

  Future<void> getVerifiedAcc() async {
    // PageLoader();
    // var params =
    //     "${ApiKeys.gApiSubFolderVerifyNumber}?mobile_no=63${recepient.text.toString().replaceAll(" ", "")}";
    // HttpRequest(
    //   api: params,
    // ).get().then((returnData) async {
    //   if (returnData == "No Internet") {
    //     Navigator.pop(context);
    //     setState(() {
    //       isLpAccount = false;
    //     });
    //     showAlertDialog(context, "Error",
    //         "Please check your internet connection and try again", () {
    //       Navigator.pop(context);
    //     });

    //     return;
    //   }

    //   if (returnData == null) {
    //     Navigator.pop(context);
    //     setState(() {
    //       isLpAccount = false;
    //     });
    //     showAlertDialog(context, "Error",
    //         "Error while connecting to server, Please contact support.", () {
    //       Navigator.pop(context);
    //     });
    //   }

    //   if (returnData["items"][0]["is_valid"] == "Y") {
    //     Navigator.of(context).pop();
    //     DbProvider().getAuthTransaction().then((enableBioTrans) async {
    //       if (enableBioTrans) {
    //         biometricTransaction();
    //       } else {
    //         sendOtp();
    //       }
    //     });
    //   } else {
    //     Navigator.pop(context);
    //     setState(() {
    //       isLpAccount = false;
    //     });
    //     showAlertDialog(context, "Error", returnData["items"][0]["msg"], () {
    //       Navigator.pop(context);
    //     });
    //   }
    // });
  }

  Future<void> onContinue() async {
    FocusManager.instance.primaryFocus!.unfocus();
    if (isBtnDisabled.value) {
      CustomDialog().errorDialog(Get.context!, "Attention",
          "Please ensure that you have filled out the provided form before we can proceed.",
          () {
        Get.back();
      });
      return;
    }
  }

  Future<void> getLogs() async {
    myBalance.value = "";
    final item = await Authentication().getUserData();
    String userId = jsonDecode(item!)['user_id'].toString();

    isLoading.value = true;

    String subApi = "${ApiKeys.gApiSubFolderGetBalance}?user_id=$userId";

    HttpRequest(api: subApi).get().then((response) {
      // print("object $response");
      if (response == "No Internet") {
        isLoading.value = false;
        isInternetConn.value = false;
        CustomDialog().internetErrorDialog(Get.context!, () => Get.back());
        return;
      }
      if (response == null) {
        isLoading.value = true;
        isInternetConn.value = true;
        CustomDialog().errorDialog(
          Get.context!,
          "Error",
          "Error while connecting to server, Please contact support.",
          () => Get.back(),
        );
        return;
      }

      if (response["items"].isNotEmpty) {
        isLoading.value = false;
        isInternetConn.value = true;
        logs.value = response["items"];

        // print("items ${response["items"]}");
      } else {
        isLoading.value = false;
        isInternetConn.value = true;
        CustomDialog().errorDialog(
          Get.context!,
          "luvpark",
          "No amenities found in this area.",
          () => Get.back(),
        );
      }
    });
  }

  Future<void> onBtnChange(int value) async {
    tokenAmount.text = value.toString();
    indexbtn.value = value;
  }

  @override
  void onInit() {
    getConsumersData();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
