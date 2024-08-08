import 'package:get/get.dart';

class LandingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxBool isAgree = false.obs;

  void onPageChanged(bool agree) {
    isAgree.value = agree;
    update();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  LandingController();
}
