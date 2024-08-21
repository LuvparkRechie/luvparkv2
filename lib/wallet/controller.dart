import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  RxList logs = [].obs;
  RxList userData = [].obs;
  var userImage;
  RxString fname = "".obs;

  //FILTER VARIABLES
  final GlobalKey<FormState> formKeyFilter = GlobalKey<FormState>();
  final TextEditingController fromDate = TextEditingController();
  final TextEditingController toDate = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    DateTime timeNow = DateTime.now();
    toDate.text = timeNow.toString().split(" ")[0];
    fromDate.text =
        timeNow.subtract(const Duration(days: 29)).toString().split(" ")[0];
    getUserBalance();
  }

  Future<void> getUserBalance() async {
    userImage = await Authentication().getUserProfilePic();
    var uData = await Authentication().getUserData();
    var item = jsonDecode(uData!);
    fname.value =
        "${item['first_name'].toString()} ${item['last_name'].toString()}";
    Functions.getUserBalance(Get.context!, (dataBalance) async {
      // print("item $item");
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

  Future<void> applyFilter() async {
    if (formKeyFilter.currentState?.validate() ?? false) {
      final String startDate = fromDate.text;
      final String endDate = toDate.text;

      if (startDate.isNotEmpty && endDate.isNotEmpty) {
        print(
            "Filter applied with start date: $startDate and end date: $endDate");
        Get.back();
      } else {
        print("Please select both start and end dates.");
        Get.back();
      }
    }
  }

  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      if (isStartDate) {
        fromDate.text = pickedDate.toString().split(' ')[0];
      } else {
        toDate.text = pickedDate.toString().split(' ')[0];
      }
    }
  }

  Future<void> getLogs() async {
    final item = await Authentication().getUserData();
    String userId = jsonDecode(item!)['user_id'].toString();
    isLoading.value = true;
    // print("yawaaa ${item}");

    String subApi =
        "${ApiKeys.gApiSubFolderGetTransactionLogs}?user_id=$userId&tran_date_from=${fromDate.text}&tran_date_to=${toDate.text}";

    HttpRequest(api: subApi).get().then((response) {
      print(" ${subApi}");
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
