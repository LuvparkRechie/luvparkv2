import 'package:get/get.dart';

import 'controller.dart';

class WalletRechargeLoadPaymentBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletRechargeLoadPaymentController>(
        () => WalletRechargeLoadPaymentController());
  }
}
