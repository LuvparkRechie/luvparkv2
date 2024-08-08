import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/functions/functions.dart';
import 'package:luvpark_get/http/api_keys.dart';
import 'package:luvpark_get/http/http_request.dart';

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
          print("resData $resData");
        }
      } finally {
        isLoading.value = false; // Ensure loading ends
      }
    });
  }
}
