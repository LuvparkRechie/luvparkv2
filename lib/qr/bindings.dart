import 'package:get/get.dart';

import 'package:luvpark_get/qr/controller.dart';

class QrWalletBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrWalletController>(() => QrWalletController());
  }
}
