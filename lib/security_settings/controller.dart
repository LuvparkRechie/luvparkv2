import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/http/api_keys.dart';
import 'package:luvpark_get/http/http_request.dart';
import 'package:luvpark_get/web_view/webview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SecuritySettingsController extends GetxController {
  RxString mobileNo = "".obs;
  SecuritySettingsController();

  @override
  void onInit() {
    super.onInit();
    print("Test");
    // getUserData();
  }

  Future<void> getUserData() async {
    print("TESt");
    return;
    final prefs = await SharedPreferences.getInstance();
    var userDataString = prefs.getString('userData');

    if (userDataString == null) {
      Get.snackbar("Error", "User data not found.");
      return;
    }

    try {
      // Parse user data
      Map<String, dynamic> userDataMap = jsonDecode(userDataString);
      mobileNo.value = userDataMap['mobile_no'].toString();

      // Call the API to delete account
      var param = {'mobile_no': mobileNo.value};
      var returnData = await HttpRequest(
              api: ApiKeys.gApiLuvPayPostDeleteAccount, parameters: param)
          .post();

      if (returnData == "No Internet") {
        CustomDialog().internetErrorDialog(Get.context!, () {
          Get.back();
        });
        return;
      }

      if (returnData == null) {
        CustomDialog().serverErrorDialog(Get.context!, () {
          Get.back();
        });
        return;
      }

      if (returnData["success"] == "Y") {
        _showSuccessDialog(returnData);
      } else {
        _showErrorDialog("Error on Deleting Account", returnData["msg"]);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to delete account: $e");
    }
  }

  void printMobileNo() {
    print('Mobile Number: ${mobileNo.value}');
    // Alternatively, use Get.snackbar for a UI message
    Get.snackbar("Mobile Number", 'Current mobile number: ${mobileNo.value}');
  }

  void _showErrorDialog(String title, String message) {
    CustomDialog().errorDialog(Get.context!, title, message, () {
      Get.back();
    });
  }

  void _showSuccessDialog(Map<String, dynamic> returnData) {
    CustomDialog().successDialog(
        Get.context!,
        "Success",
        "You will be directed to delete account page. Wait for customer support",
        "Okay", () {
      Get.to(const WebviewPage(
        urlDirect: "https://luvpark.ph/account-deletion/",
        label: "Account Deletion",
        isBuyToken: false,
      ));
    });
  }
}
