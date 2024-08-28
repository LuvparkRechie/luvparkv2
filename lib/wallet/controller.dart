import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/functions/functions.dart';
import 'package:luvpark_get/http/api_keys.dart';
import 'package:luvpark_get/http/http_request.dart';

class WalletController extends GetxController
    with GetSingleTickerProviderStateMixin {
  WalletController();
  late StreamController<void> _dataController;
  late StreamSubscription<void> dataSubscription;
  RxBool isLoading = true.obs;
  RxBool isNetConn = true.obs;
  bool isAllowToSync = true;

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
    _dataController = StreamController<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getUserBalance();
    });
  }

  void streamData() {
    dataSubscription = _dataController.stream.listen((data) {});
    fetchDataPeriodically();
  }

  void fetchDataPeriodically() async {
    dataSubscription = Stream.periodic(const Duration(seconds: 20), (count) {
      fetchData();
    }).listen((event) {});
  }

  Future<void> fetchData() async {
    await Future.delayed(const Duration(seconds: 5));
    if (isAllowToSync) {
      getUserBalance();
    }
  }

  Future<void> getUserBalance() async {
    userImage = await Authentication().getUserProfilePic();
    var uData = await Authentication().getUserData();
    var item = jsonDecode(uData!);
    fname.value =
        "${item['first_name'].toString()} ${item['last_name'].toString()}";
    Functions.getUserBalance(Get.context!, (dataBalance) async {
      if (!dataBalance[0]["has_net"]) {
        isLoading.value = false;
        isNetConn.value = false;
        isAllowToSync = false;
        return;
      } else {
        userData.value = dataBalance[0]["items"];
        getLogs();
      }
    });
  }

  Future<void> onRefresh() async {
    if (isLoading.value) return;
    isLoading.value = true;
    isNetConn.value = true;
    getUserBalance();
  }

  Future<void> applyFilter() async {
    FocusManager.instance.primaryFocus!.unfocus();
    if (fromDate.text.isEmpty || toDate.text.isEmpty) {
      return;
    } else {
      Get.back();
      getLogs();
    }
  }

  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    final DateTime today = DateTime.now();
    final DateTime firstDateLimit =
        today.subtract(const Duration(days: 29)); // Limit to the last 29 days

    DateTime? firstDate;
    DateTime? lastDate;

    if (isStartDate) {
      firstDate = firstDateLimit; // Allow selection starting from 29 days ago
      lastDate = today; // Prevent selecting dates after today
    } else {
      firstDate =
          DateTime.parse(fromDate.text); // Start date selected by the user
      lastDate = today; // Prevent selecting dates after today
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      final formattedDate = pickedDate.toString().split(' ')[0];
      if (isStartDate) {
        fromDate.text = formattedDate;
      } else {
        toDate.text = formattedDate;
      }
    }
  }

  Future<void> getLogs() async {
    final item = await Authentication().getUserData();
    String userId = jsonDecode(item!)['user_id'].toString();
    isLoading.value = true;

    String subApi =
        "${ApiKeys.gApiSubFolderGetTransactionLogs}?user_id=$userId&tran_date_from=${fromDate.text}&tran_date_to=${toDate.text}";

    HttpRequest(api: subApi).get().then((response) {
      if (response == "No Internet") {
        isAllowToSync = false;
        isLoading.value = false;
        isNetConn.value = false;
        CustomDialog().internetErrorDialog(Get.context!, () => Get.back());
        return;
      }
      if (response == null) {
        isLoading.value = true;
        isNetConn.value = true;
        isAllowToSync = false;
        CustomDialog().errorDialog(
          Get.context!,
          "luvpark",
          "Error while connecting to server, Please contact support.",
          () => Get.back(),
        );
        return;
      }

      if (response["items"].isNotEmpty) {
        isLoading.value = false;
        isNetConn.value = true;
        isAllowToSync = true;
        logs.value = response["items"];
        streamData();
      } else {
        isLoading.value = false;
        isNetConn.value = true;
        isAllowToSync = false;
        CustomDialog().customPopUp(
            Get.context!, "luvpark", "No data found", "", "Okay",
            showTwoButtons: false, onTapConfirm: () {
          Get.back();
        });
      }
    });
  }

  @override
  void onClose() {
    _dataController.close();
    dataSubscription.cancel();
    super.onClose();
  }
}
