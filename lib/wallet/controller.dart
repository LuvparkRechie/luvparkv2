import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/functions/functions.dart';
import 'package:luvpark_get/http/api_keys.dart';
import 'package:luvpark_get/http/http_request.dart';

class WalletController extends GetxController
    with GetSingleTickerProviderStateMixin {
  WalletController();
  RxBool isLoading = true.obs;
  RxBool isNetConn = true.obs;
  RxString toDate = "".obs;
  RxString fromDate = "".obs;
  RxList logs = [].obs;
  RxList userData = [].obs;
  var userImage;

  @override
  void onInit() {
    // fetchData();
    DateTime timeNow = DateTime.now();
    super.onInit();
    toDate.value = timeNow.toString().split(" ")[0];
    fromDate.value =
        timeNow.subtract(const Duration(days: 29)).toString().split(" ")[0];
    getUserBalance();
  }

  // void fetchData() async {
  //   // Simulate network call
  //   isLoading.value = true;
  //   await Future.delayed(Duration(seconds: 2));
  //   // Update data
  //   logs.value =
  //       await fetchLogs(); // Replace with your actual data fetching method
  //   userData.value =
  //       await fetchUserData(); // Replace with your actual data fetching method
  //   isLoading.value = false;
  // }

  // void refresh() {
  //   fetchData();
  // }

  Future<void> getUserBalance() async {
    userImage = await Authentication().getUserProfilePic();
    Functions.getUserBalance(Get.context!, (dataBalance) async {
      if (!dataBalance[0]["has_net"]) {
        isLoading.value = false;
        isNetConn.value = false;
        return;
      } else {
        userData.value = dataBalance[0]["items"];
        getLogs();
      }
    });
  }

  Future<void> onRefresh() async {
    isLoading.value = true;
    getLogs();
    getUserBalance();
  }

  Future<void> getLogs() async {
    final item = await Authentication().getUserData();
    String userId = jsonDecode(item!)['user_id'].toString();
    isLoading.value = true;
    String? userData = await Authentication().getUserData();

    // print("yawaaa $item");

    String subApi =
        "${ApiKeys.gApiSubFolderGetTransactionLogs}?user_id=$userId&tran_date_from=$fromDate&tran_date_to=$toDate";

    HttpRequest(api: subApi).get().then((response) {
      if (response == "No Internet") {
        isLoading.value = false;
        isNetConn.value = false;
        CustomDialog().internetErrorDialog(Get.context!, () => Get.back());
        return;
      }
      if (response == null) {
        isLoading.value = true;
        isNetConn.value = true;
        CustomDialog().errorDialog(
          Get.context!,
          "Error",
          "Error while connecting to server, Please contact support.",
          () => Get.back(),
        );
        return;
      }

      if (response["items"].isNotEmpty) {
        isLoading.value = false;
        isNetConn.value = true;
        logs.value = response["items"];

        // print("items ${response["items"]}");
      } else {
        isLoading.value = false;
        isNetConn.value = true;
        CustomDialog().errorDialog(
          Get.context!,
          "luvpark",
          "No amenities found in this area.",
          () => Get.back(),
        );
      }
    });
  }
}
