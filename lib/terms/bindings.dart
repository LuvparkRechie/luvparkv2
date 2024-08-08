import 'package:get/get.dart';
import 'package:luvpark_get/terms/controller.dart';

class TermsOfUseBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsOfUseController>(() => TermsOfUseController());
  }
}
