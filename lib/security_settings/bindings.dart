import 'package:get/get.dart';
import 'package:luvpark_get/security_Settings/controller.dart';

class SecuritySettingsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SecuritySettingsController>(() => SecuritySettingsController());
  }
}
