import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletSendController extends GetxController
    with GetSingleTickerProviderStateMixin {
  WalletSendController();

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
  RxInt denoInd = 0.obs;
  RxString myBalance = "".obs;
  RxList<int> padNumbers = [10, 20, 30, 40, 50, 100, 200, 250].obs;
  void onPageChanged(bool agree) {
    update();
  }

  void getConsumersData() {}
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
