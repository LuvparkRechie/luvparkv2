import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/http/api_keys.dart';
import 'package:luvpark_get/http/http_request.dart';
import 'package:luvpark_get/routes/routes.dart';
import 'package:luvpark_get/sqlite/vehicle_brands_model.dart';
import 'package:luvpark_get/sqlite/vehicle_brands_table.dart';

class LoginScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  LoginScreenController();
  final GlobalKey<FormState> formKeyLogin = GlobalKey<FormState>();
  RxBool isAgree = false.obs;
  RxBool isShowPass = false.obs;
  RxBool isLoading = false.obs;

  TextEditingController mobileNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLogin = false;
  RxBool isInternetConnected = true.obs;

  bool isTappedReg = false;
  var usersLogin = [];

  void toggleLoading(bool value) {
    isLoading.value = value;
  }

  void onPageChanged(bool agree) {
    isAgree.value = agree;
    update();
  }

  void visibilityChanged(bool visible) {
    isShowPass.value = visible;
    update();
  }

  Future<void> getAccountStatus(context, mobile, Function cb) async {
    String apiParam =
        "${ApiKeys.gApiSubFolderGetLoginAttemptRecord}?mobile_no=$mobile";

    HttpRequest(api: apiParam).get().then((objData) {
      if (objData == "No Internet") {
        isInternetConnected.value = false;
        CustomDialog().internetErrorDialog(context, () {
          Get.back();
          cb([
            {"has_net": false, "items": []}
          ]);
        });
        return;
      }
      if (objData == null) {
        isInternetConnected.value = false;
        CustomDialog().errorDialog(context, "Error",
            "Error while connecting to server, Please try again.", () {
          Get.offAndToNamed(Routes.onboarding);
        });

        return;
      }
      if (objData["items"].isEmpty) {
        isInternetConnected.value = true;
        CustomDialog().errorDialog(context, "Error", "Invalid account.", () {
          Get.offAndToNamed(Routes.login);
        });
        return;
      } else {
        cb([
          {"has_net": true, "items": objData["items"]}
        ]);
      }
    });
  }

  //POST LOGIN
  postLogin(context, Map<String, dynamic> param, Function cb) async {
    String apiParam = ApiKeys.gApiLuvParkGetVehicleBrand;

    HttpRequest(api: apiParam).get().then((returnBrandData) async {
      if (returnBrandData == "No Internet") {
        CustomDialog().internetErrorDialog(context, () {
          Get.back();
          cb([
            {"has_net": false, "items": []}
          ]);
        });
        return;
      }
      if (returnBrandData == null) {
        CustomDialog().serverErrorDialog(Get.context!, () {
          Get.back();
          cb([
            {"has_net": true, "items": []}
          ]);
        });
      } else {
        VehicleBrandsTable.instance.deleteAll();
        for (var dataRow in returnBrandData["items"]) {
          var vbData = {
            VHBrandsDataFields.vhTypeId:
                int.parse(dataRow["vehicle_type_id"].toString()),
            VHBrandsDataFields.vhBrandId:
                int.parse(dataRow["vehicle_brand_id"].toString()),
            VHBrandsDataFields.vhBrandName:
                dataRow["vehicle_brand_name"].toString(),
          };
          await VehicleBrandsTable.instance.insertUpdate(vbData);
        }

        HttpRequest(api: ApiKeys.gApiSubFolderPostLogin, parameters: param)
            .post()
            .then((returnPost) async {
          if (returnPost == "No Internet") {
            CustomDialog().internetErrorDialog(context, () {
              Get.back();
              cb([
                {"has_net": false, "items": []}
              ]);
            });
            return;
          }
          if (returnPost == null) {
            CustomDialog().errorDialog(context, "Error",
                "Error while connecting to server, Please try again.", () {
              Get.back();
              cb([
                {"has_net": true, "items": []}
              ]);
            });
            return;
          }
          if (returnPost["success"] == "N") {
            CustomDialog().errorDialog(context, "Error", returnPost["msg"], () {
              Get.back();
              cb([
                {"has_net": true, "items": []}
              ]);
            });

            return;
          } else {
            var getApi =
                "${ApiKeys.gApiSubFolderLogin}?mobile_no=${param["mobile_no"]}&auth_key=${returnPost["auth_key"].toString()}";

            HttpRequest(api: getApi).get().then((objData) async {
              if (objData == "No Internet") {
                CustomDialog().internetErrorDialog(context, () {
                  Get.back();
                  cb([
                    {"has_net": false, "items": []}
                  ]);
                });
                return;
              }
              if (objData == null) {
                CustomDialog().errorDialog(context, "Error",
                    "Error while connecting to server, Please try again.", () {
                  Get.back();
                  cb([
                    {"has_net": true, "items": []}
                  ]);
                });
                return;
              } else {
                if (objData["items"].length == 0) {
                  CustomDialog().errorDialog(
                      context, "Error", objData["items"]["msg"], () {
                    Get.back();
                    cb([
                      {"has_net": true, "items": []}
                    ]);
                  });
                  return;
                } else {
                  var items = objData["items"][0];

                  Map<String, dynamic> parameters = {
                    "user_id": items['user_id'].toString(),
                    "mobile_no": param["mobile_no"],
                    "is_active": "Y",
                    "is_login": "Y",
                  };

                  Authentication().setLogin(jsonEncode(parameters));
                  Authentication().setUserData(jsonEncode(items));
                  Authentication().setPasswordBiometric(param["pwd"]);
                  if (items["image_base64"] != null) {
                    Authentication().setProfilePic(items["image_base64"]);
                  }

                  cb([
                    {"has_net": true, "items": objData["items"]}
                  ]);
                }
              }
            });
          }
        });
      }
    });
  }

  @override
  void onInit() {
    mobileNumber = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
