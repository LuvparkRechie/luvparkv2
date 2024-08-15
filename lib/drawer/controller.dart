import 'dart:convert';

import 'package:get/get.dart';
import 'package:luvpark_get/auth/authentication.dart';

class CustomDrawerController extends GetxController {
  CustomDrawerController();

  var userdata;

  @override
  void onInit() {
    super.onInit();
    getAccountData();
  }

  void getAccountData() async {
    final item = await Authentication().getUserData();
    userdata = jsonDecode(item!);

    print(userdata);
  }
}
