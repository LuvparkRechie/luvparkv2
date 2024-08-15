import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class WalletRechargeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  WalletRechargeController();
  Timer? _debounce;
  TextEditingController tokenAmount = TextEditingController();
  RxBool isActiveBtn = false.obs;
  RxBool isShowKeyboard = false.obs;
  RxInt? selectedPaymentType = 0.obs;
  var denoInd = 0.obs;
  var ndData = [].obs;
  final List<String> dataList = [
    "20",
    "30",
    "50",
    "100",
    "200",
    "250",
    "300",
    "500",
    "1000"
  ];

  @override
  void onInit() {
    generateBank();
    super.onInit();
  }

  Future<void> onTextChange() async {
    denoInd.value = -1;
    selectedPaymentType = null;
    if (tokenAmount.value.text.isEmpty ||
        tokenAmount.text.isEmpty ||
        double.parse(
                tokenAmount.text.replaceAll(",", "").replaceAll(".", "")) <=
            0) {
      isActiveBtn.value = false;
    } else {
      isActiveBtn.value = false;
    }
  }

  Future<void> pads() async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());

    // denoInd = index;
    // selectedPaymentType = index;
    // tokenAmount.text = value;
    // isActiveBtn = true;
  }

  Future<void> generateBank() async {}
  @override
  void onClose() {
    super.onClose();
  }

  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
