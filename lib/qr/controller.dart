import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QrWalletController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxBool isAgree = false.obs;
  late TabController tabController;

  // void onPageChanged(bool agree) {
  //   isAgree.value = agree;
  //   update();
  // }

  @override
  void onInit() {
    tabController = TabController(vsync: this, length: 2);
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();

    super.onClose();
  }

  QrWalletController();
}
