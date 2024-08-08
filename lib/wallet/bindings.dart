import 'package:get/get.dart';
import 'package:luvpark_get/wallet/controller.dart';

class WalletBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletController>(() => WalletController());
  }
}
