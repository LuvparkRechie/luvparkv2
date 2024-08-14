import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/custom_widgets/variables.dart';
import 'package:luvpark_get/functions/functions.dart';
import 'package:luvpark_get/http/api_keys.dart';
import 'package:luvpark_get/http/http_request.dart';
import 'package:luvpark_get/routes/routes.dart';

class ParkingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  TextEditingController searchCtrl = TextEditingController();
  PageController pageController = PageController();
  final GlobalKey tabBarKey = GlobalKey();
  RxInt currentPage = 0.obs;
  RxList resData = [].obs;
  RxBool hasNet = false.obs;
  RxDouble tabHeight = 0.0.obs;

  RxBool isLoading = false.obs; // Changed from hasNet to isLoading

  ParkingController();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 2);

    getReserveData("C");
  }

  @override
  void onClose() {
    tabController.dispose();
    pageController.dispose();
    searchCtrl.dispose();
    super.onClose();
  }

  void onTabTapped(int index) {
    currentPage.value = index;

    getReserveData(index == 0 ? "C" : "U");
  }

  Future<void> onRefresh() async {
    getReserveData(currentPage.value == 0 ? "C" : "U");
  }

  //Get Reserve Data
  Future<void> getReserveData(String status) async {
    isLoading.value = true; // Start loading
    Functions.getUserBalance(Get.context!, (userData) async {
      if (!userData[0]["has_net"]) {
        isLoading.value = false; // End loading
        CustomDialog().errorDialog(Get.context!, "Error",
            "Please check your internet connection and try again.", () {
          Get.back();
        });
        return;
      }
      final id = userData[0]["items"][0]["user_id"];
      try {
        final returnData = await HttpRequest(
                api: "${ApiKeys.gApiSubFolderGetReservations}?user_id=$id")
            .get();

        if (returnData == "No Internet") {
          isLoading.value = false; // End loading
          CustomDialog().errorDialog(Get.context!, "Error",
              "Please check your internet connection and try again.", () {
            Get.back();
          });
          return;
        }
        if (returnData == null) {
          isLoading.value = false; // End loading
          CustomDialog().errorDialog(Get.context!, "Internet Error",
              "Error while connecting to server, Please contact support.", () {
            Get.back();
          });
          return;
        } else {
          if (currentPage.value == 0) {
            resData.value = returnData["items"].where((element) {
              return element["is_active"] == "Y" && element["status"] == "C";
            }).toList();
          } else {
            resData.value = returnData["items"].where((element) {
              return element["is_active"] == "Y" && element["status"] == "U";
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
    CustomDialog().loadingDialog(Get.context!);
    var param =
        "${ApiKeys.gApiSubFolderGetDirection}?ref_no=${data["reservation_ref_no"]}";

    HttpRequest(api: param).get().then((returnData) async {
      if (returnData == "No Internet") {
        Get.back();
        CustomDialog().internetErrorDialog(Get.context!, () {
          Get.back();
        });
      }
      if (returnData == null) {
        Get.back();
        CustomDialog().serverErrorDialog(Get.context!, () {
          Get.back();
        });

        return;
      } else {
        if (returnData["items"].length == 0) {
          Get.back();
          CustomDialog().errorDialog(Get.context!, "luvpark", "No data found",
              () {
            Get.back();
          });
          return;
        } else {
          Get.back();
          var dateInRelated = "";
          var dateOutRelated = "";
          dateInRelated = data["dt_in"];
          dateOutRelated = data["dt_out"];

          Map<String, dynamic> parameters = {
            "client_id": userId,
            "park_area_id": returnData["items"][0]["park_area_id"],
            "vehicle_type_id": returnData["items"][0]["vehicle_type_id"],
            "vehicle_plate_no":
                returnData["items"][0]["vehicle_plate_no"].toString(),
            "dt_in": dateInRelated,
            "dt_out": dateOutRelated,
            "no_hours": int.parse(data["no_hours"].toString()),
            "tran_type": "E",
          };

          if (data["status"].toString() == "C") {
            dynamic args = {
              'spaceName': returnData["items"][0]["park_space_name"].toString(),
              'parkArea': returnData["items"][0]["park_area_name"].toString(),
              'startDate':
                  Variables.formatDate(dateInRelated.toString().split(" ")[0]),
              'endDate':
                  Variables.formatDate(dateOutRelated.toString().split(" ")[0]),
              'startTime': dateInRelated.toString().split(" ")[1].toString(),
              'endTime': dateOutRelated.toString().split(" ")[1].toString(),
              'plateNo': returnData["items"][0]["vehicle_plate_no"].toString(),
              'hours': data["no_hours"].toString(),
              'amount': data["amount"].toString(),
              'refno': data["reservation_ref_no"].toString().toString(),
              'lat': double.parse(
                  returnData["items"][0]["park_space_latitude"].toString()),
              'long': double.parse(
                  returnData["items"][0]["park_space_longitude"].toString()),
              'canReserved': true,
              'isReserved': false,
              'isShowRate': false,
              'reservationId': data["reservation_id"],
              'address': returnData["items"][0]["address"],
              'isAutoExtend': data["is_auto_extend"].toString(),
              'isBooking': false,
              'paramsCalc': parameters
            };
            // print("args $args");
            // Get.offAll(Routes.bookingReceipt, arguments: args);
            Get.toNamed(Routes.bookingReceipt, arguments: args);
          } else {
            // Variables.pageTrans(
            //     ParkingDetails(
            //       startDate: dateInRelated
            //                   .toString()
            //                   .split(" ")[0]
            //                   .toString() ==
            //               dateOutRelated.toString().split(" ")[0].toString()
            //           ? Variables.formatDate(
            //               dateInRelated.toString().split(" ")[0])
            //           : "${Variables.formatDate(dateInRelated.toString().split(" ")[0])} - ${Variables.formatDate(dateOutRelated.toString().split(" ")[0])}",
            //       startTime: dateInRelated.toString().split(" ")[1].toString(),
            //       endTime: dateOutRelated.toString().split(" ")[1].toString(),
            //       resData: data,
            //       returnData: returnData["items"],
            //       dtOut: dateOutRelated,
            //       dateIn: dateInRelated,
            //       paramsCalc: parameters,
            //       onTap: () {
            //         onRefresh();
            //       },
            //     ),
            //     context);
          }
        }
      }
    });
    // // Get.toNamed(Routes.bookingReceipt);
  }
}
