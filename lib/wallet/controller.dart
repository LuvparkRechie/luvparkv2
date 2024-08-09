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
  



  @override
  void onInit() { 
    DateTime timeNow = DateTime.now();
    super.onInit();
    toDate.value = timeNow.toString().split(" ")[0];
    fromDate.value =
        timeNow.subtract(const Duration(days: 29)).toString().split(" ")[0];
    // getUserBalance();
    getLogs();
  }

  // // Future<void> getUserBalance() async {
  // //   Functions.getUserBalance(Get.context!, (dataBalance) async {
  // //     userBal.value = dataBalance[0]["items"];
  // //     if (!dataBalance[0]["has_net"]) {
  // //       netConnected.value = false;
  // //       isLoading.value = false;
  // //       isLoadingMap.value = false;
  // //     } else {
  // //       isLoading.value = false;
  // //       if (isSearch) {
  // //         getNearest(dataBalance[0]["items"], searchCoordinates);
  // //       } else {
  // //         List ltlng = await Functions.getCurrentPosition();
  // //         LatLng coordinates = LatLng(ltlng[0]["lat"], ltlng[0]["long"]);
  // //         getNearest(dataBalance[0]["items"], coordinates);
  // //       }
  // //     }
  // //   });
  // }

  Future<void> getLogs() async {
    final item = await Authentication().getUserData();
    String userId = jsonDecode(item!)['user_id'].toString();
    isLoading.value = true;
    // print("yawaaa");

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
