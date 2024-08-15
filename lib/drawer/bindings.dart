import 'package:get/get.dart';
import 'package:luvpark_get/drawer/controller.dart';

class CustomDrawerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomDrawerController>(() => CustomDrawerController());
  }
}
