import 'dart:convert';

import 'package:get/get.dart';
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/functions/functions.dart';

class ProfileScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  ProfileScreenController();
  // ignore: prefer_typing_uninitialized_variables
  var userProfile;
  RxList userData = [].obs;
  RxString myName = "".obs;
  RxBool isLoading = true.obs;
  RxBool isNetConn = true.obs;
  @override
  // ignore: unnecessary_overrides
  void onInit() {
    super.onInit();

    getUserData();
  }

  void getUserBalance() async {
    Functions.getUserBalance(Get.context!, (dataBalance) async {
      isLoading.value = false;
      if (!dataBalance[0]["has_net"]) {
        isNetConn.value = false;
        return;
      } else {
        isNetConn.value = true;
        userData.value = dataBalance[0]["items"];
      }
    });
  }

  void getUserData() async {
    isLoading.value = true;
    isNetConn.value = true;
    String? userData = await Authentication().getUserData();
    final item = await Authentication().getUserData2();
    userProfile = item;
    if (jsonDecode(userData!)["first_name"] == null) {
      myName.value = "";
    } else {
      myName.value = jsonDecode(userData)["first_name"];
    }
    getUserBalance();
  }
}
