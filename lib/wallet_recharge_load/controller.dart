import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class WalletRechargeLoadController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final String tokenAmount =
      Get.arguments; // from wallet recharge screen tokenAmount
  WalletRechargeLoadController();
  final GlobalKey<FormState> page1Key = GlobalKey<FormState>();
  final TextEditingController mobileNo = TextEditingController();
  final TextEditingController rname = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // Nullable integer
  Rxn<int> selectedBankType = Rxn<int>();
  final List<dynamic> bankPartner = [
    {
      "name": "U-Bank",
      "value": "UB",
      "img_url": "assets/images/ubank.png",
    },
  ];
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> onSelectBank(int index) async {
    selectedBankType.value = index;
  }

  Future<void> generateBank() async {}

  void onPay() {}
  @override
  void onClose() {
    super.onClose();
  }
}
