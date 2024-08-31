import 'dart:convert';

import 'package:get/get.dart';
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/functions/functions.dart';

class MyAccountScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  MyAccountScreenController();
  RxList userData = [].obs;
  RxString myName = "".obs;
  RxString myprofile = "".obs;
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
    final profilepic = await Authentication().getUserProfilePic();
    final data = await Authentication().getUserData2();
    myprofile.value = profilepic;
    userData.add(data);
  }
}
