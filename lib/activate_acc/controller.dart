import 'package:get/get.dart';

class ActivateAccountController extends GetxController {
  RxBool isAgree = false.obs;

  void onPageChanged(bool agree) {
    isAgree.value = agree;
    update();
  }

  ActivateAccountController();
}
