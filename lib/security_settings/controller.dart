import 'package:get/get.dart';
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/http/api_keys.dart';
import 'package:luvpark_get/http/http_request.dart';
import 'package:luvpark_get/web_view/webview.dart';

class SecuritySettingsController extends GetxController {
  RxString mobileNo = "".obs;
  RxList userData = [].obs;

  Future<void> deleteAccount() async {
    CustomDialog().loadingDialog(Get.context!);
    try {
      final mydata = await Authentication().getUserData2();

      mobileNo.value = mydata["mobile_no"];

      Map<String, dynamic> param = {
        "mobile_no": mydata["mobile_no"],
      };
      var returnData = await HttpRequest(
              api: ApiKeys.gApiLuvPayPostDeleteAccount, parameters: param)
          .post();
      Get.back();

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
      Get.back();
      Get.to(WebviewPage(
        urlDirect: "https://luvpark.ph/account-deletion/",
        label: "Account Deletion",
        isBuyToken: false,
        callback: () {
          controller.getAccountStatus(context,
              "63${controller.mobileNumber.text.toString().replaceAll(" ", "")}",
              (obj) {
            final items = obj[0]["items"];
          });
        },
      ));
    });
  }
}
