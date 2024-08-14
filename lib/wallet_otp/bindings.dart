import 'package:get/get.dart';

import 'controller.dart';

class WalletOtpBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletOtpController>(() => WalletOtpController());
  }
}
