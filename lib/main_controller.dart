import 'dart:convert';

import 'package:get/get.dart';
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/login/index.dart';
import 'package:luvpark_get/routes/routes.dart';

class MainController extends GetxController {
  var initialRoute = RxString('');

  RxBool isLoad = true.obs;

  @override
  void onInit() {
    super.onInit();
    _determineInitialRoute();
  }

  Future<void> _determineInitialRoute() async {
    final data = await Authentication().getUserLogin();
    final uPass = await Authentication().getPasswordBiometric();

    if (data != null) {
      final logData = jsonDecode(data);
      final LoginScreenController lgCt = Get.find<LoginScreenController>();

      lgCt.getAccountStatus(Get.context, logData["mobile_no"], (obj) {
        final items = obj[0]["items"];
        if (items.isEmpty) {
          isLoad.value = false;
          return;
        }
        if (items[0]["is_active"] == "N") {
          CustomDialog().confirmationDialog(
              Get.context!,
              "Information",
              "Your account is currently inactive. Would you like to activate it now?",
              "Yes",
              "Cancel", () {
            Get.back();
            isLoad.value = false;
            initialRoute.value = Routes.activate;
          }, () {
            Get.back();
          });
        } else {
          Map<String, dynamic> postParam = {
            "mobile_no": logData["mobile_no"],
            "pwd": uPass,
          };

          lgCt.postLogin(Get.context, postParam, (data) {
            isLoad.value = false;
            if (data[0]["items"].isNotEmpty) {
              initialRoute.value = Routes.map;
            }
          });
        }
      });
    } else {
      isLoad.value = false;
      initialRoute.value = Routes.onboarding;
    }
  }
}
