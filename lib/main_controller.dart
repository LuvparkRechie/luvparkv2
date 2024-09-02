import 'dart:async';

import 'package:get/get.dart';
import 'package:luvpark_get/auth/authentication.dart';

import 'notification_controller.dart';

@pragma('vm:entry-point')
Future<void> backgroundFunc() async {
  int counter = 0;

  Timer.periodic(const Duration(seconds: 10), (timer) async {
    var akongId = await Authentication().getUserId();

    if (akongId == 0) return;
    await getParkingTrans(counter);

    await getMessNotif();
  });
}

class MainController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    backgroundFunc();
  }
}
