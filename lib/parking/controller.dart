import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/functions/functions.dart';
import 'package:luvpark_get/http/api_keys.dart';
import 'package:luvpark_get/http/http_request.dart';
import 'package:luvpark_get/routes/routes.dart';

class ParkingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  bool? parameter = Get.arguments;
  late TabController tabController;
  TextEditingController searchCtrl = TextEditingController();
  late StreamController<void> _dataController;
  late StreamSubscription<void> _dataSubscription;
  PageController pageController = PageController();
  final GlobalKey tabBarKey = GlobalKey();
  RxInt currentPage = 0.obs;
  RxList resData = [].obs;
  RxBool hasNet = false.obs;
  RxDouble tabHeight = 0.0.obs;
  bool isAllowToSync = true;

  RxBool isLoading = false.obs;
  ParkingController();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 2);
    _dataController = StreamController<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      onRefresh();
    });
    streamData();
  }

  @override
  void onClose() {
    tabController.dispose();
    pageController.dispose();
    _dataController.close();
    searchCtrl.dispose();
    _dataSubscription.cancel();
    super.onClose();
  }

  void onTabTapped(int index) {
    currentPage.value = index;

    getReserveData(index == 0 ? "C" : "U");
  }

  Future<void> onRefresh() async {
    getReserveData(currentPage.value == 0 ? "C" : "U");
  }

  void streamData() {
    _dataSubscription = _dataController.stream.listen((data) {});
    fetchDataPeriodically();
  }

  void fetchDataPeriodically() async {
    _dataSubscription = Stream.periodic(const Duration(seconds: 20), (count) {
      fetchData();
    }).listen((event) {});
  }

  Future<void> fetchData() async {
    await Future.delayed(const Duration(seconds: 5));
    if (isAllowToSync) {
      onRefresh();
    }
  }

  //Get Reserve Data
  Future<void> getReserveData(String status) async {
    isLoading.value = true; // Start loading
    Functions.getUserBalance(Get.context!, (userData) async {
      if (!userData[0]["has_net"]) {
        isLoading.value = false;
        CustomDialog().errorDialog(Get.context!, "Error",
            "Please check your internet connection and try again.", () {
          Get.back();
        });
        return;
      }
      final id = await Authentication().getUserId();
      String api =
          "${currentPage.value == 1 ? ApiKeys.gApiSubFolderGetActiveParking : ApiKeys.gApiSubFolderGetReservations}?luvpay_id=$id";

      try {
        final returnData = await HttpRequest(api: api).get();

        if (returnData == "No Internet") {
          isLoading.value = false; // End loading
          isAllowToSync = false;
          CustomDialog().errorDialog(Get.context!, "Error",
              "Please check your internet connection and try again.", () {
            Get.back();
          });
          return;
        }
        isAllowToSync = true;
        if (returnData == null) {
          isLoading.value = false; // End loading
          CustomDialog().errorDialog(Get.context!, "Internet Error",
              "Error while connecting to server, Please contact support.", () {
            Get.back();
          });
          return;
        } else {
          isLoading.value = false;

          List itemData = returnData["items"];

          if (currentPage.value == 0) {
            resData.value = itemData.where((element) {
              return element["status"] == "C";
            }).toList();
          } else {
            resData.value = itemData.where((element) {
              return element["status"] == "U";
            }).toList();
          }
        }
      } finally {
        isLoading.value = false; // Ensure loading ends
      }
    });
  }

  // BTN details
  Future<void> getParkingDetails(dynamic data) async {
    int userId = await Authentication().getUserId();

    var dateInRelated = "";
    var dateOutRelated = "";
    dateInRelated = data["dt_in"];
    dateOutRelated = data["dt_out"];
    DateTime now = DateTime.now();
    DateTime resDate = DateTime.parse(data["reservation_date"].toString());

    Map<String, dynamic> parameters = {
      "client_id": userId,
      "park_area_id": data["park_area_id"],
      "vehicle_type_id": data["vehicle_type_id"],
      "vehicle_plate_no": data["vehicle_plate_no"],
      "dt_in": dateInRelated,
      "dt_out": dateOutRelated,
      "no_hours": data["no_hours"].toString(),
      "tran_type": "E",
    };

    dynamic args = {
      'spaceName': data["park_area_name"],
      'parkArea': data["park_area_name"],
      'startDate': data["dt_in"],
      'endDate': data["dt_out"],
      'startTime': dateInRelated.toString().split(" ")[1].toString(),
      'endTime': dateOutRelated.toString().split(" ")[1].toString(),
      'plateNo': data["vehicle_plate_no"],
      'hours': data["no_hours"].toString(),
      'amount': data["amount"].toString(),
      'refno': data["ticket_ref_no"].toString().toString(),
      'lat': double.parse(data["latitude"].toString()),
      'long': double.parse(data["longitude"].toString()),
      'canReserved': true,
      'isReserved': false,
      'isShowRate': false,
      'reservationId': data["reservation_id"],
      'address': data["address"],
      'isAutoExtend': data["is_auto_extend"] == null ? "N" : "Y",
      'isBooking': false,
      'paramsCalc': parameters,
      'status': data["status"].toString() == "C" ? "R" : "A",
      'can_cancel': int.parse(now.difference(resDate).inMinutes.toString()) <=
          int.parse(data["cancel_minutes"].toString()),
      'cancel_minute': data["cancel_minutes"],
      'onRefresh': () {
        onRefresh();
      }
    };

    Get.toNamed(Routes.bookingReceipt, arguments: args);
  }
}
