import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class WalletRechargeLoadController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final String tokenAmount =
      Get.arguments; // from wallet recharge screen tokenAmount
  WalletRechargeLoadController();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> generateBank() async {}
  @override
  void onClose() {
    super.onClose();
  }
}
