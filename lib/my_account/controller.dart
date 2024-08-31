import 'dart:convert';

import 'package:get/get.dart';
import 'package:luvpark_get/auth/authentication.dart';

class MyAccountScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  MyAccountScreenController();
  var userProfile;
  RxList userData = [].obs;
  RxString myName = "".obs;
  RxBool isLoading = true.obs;
  RxBool isNetConn = true.obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  void getUserData() async {
    isLoading.value = true;
    isNetConn.value = true;
    String? userData = await Authentication().getUserData();
    final item = await Authentication().getUserData2();
    userProfile.value = item; // Update observable map

    if (jsonDecode(userData!)["first_name"] == null) {
      myName.value = "";
    } else {
      myName.value = jsonDecode(userData)["first_name"];
    }
  }
}
