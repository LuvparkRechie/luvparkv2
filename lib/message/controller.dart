import 'package:get/get.dart';
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/http/http_request.dart';

import '../http/api_keys.dart';

class MessageScreenController extends GetxController {
  MessageScreenController();
  RxBool isLoading = true.obs;
  RxBool isNetConn = true.obs;
  RxList messages = [].obs;

  @override
  void onInit() {
    refresher();
    super.onInit();
  }

  Future<void> refresher() async {
    isLoading.value = true;
    isNetConn.value = true;
    getMessages();
  }

  Future<void> getMessages() async {
    int userId = await Authentication().getUserId();
    String subApi = "${ApiKeys.gApiLuvParkMessageNotif}?user_id=$userId";
    HttpRequest(api: subApi).get().then((objData) {
      print("objData $objData");
      if (objData == "No Internet") {
        isLoading.value = false;
        isNetConn.value = false;
        messages.value = [];
        CustomDialog().internetErrorDialog(Get.context!, () => Get.back());
        return;
      }
      if (objData == null) {
        isLoading.value = false;
        isNetConn.value = true;
        messages.value = [];
        CustomDialog().errorDialog(
          Get.context!,
          "luvpark",
          "Error while connecting to server, Please contact support.",
          () => Get.back(),
        );
        return;
      }
      if (objData["items"].isNotEmpty) {
        isLoading.value = false;
        isNetConn.value = true;
        messages.value = objData["items"];
      } else {
        isLoading.value = false;
        isNetConn.value = true;
        messages.value = [];
      }
    });
  }

  Future<void> deleteMessage(int index) async {
    CustomDialog().confirmationDialog(Get.context!, "luvpark",
        "Are you sure you want to delete this message?", "Cancel", "Yes", () {
      Get.back();
    }, () {
      messages.removeAt(index);
      Get.back();
    });
  }

  Future<void> deleteAll() async {
    if (messages.isEmpty) {
      CustomDialog().errorDialog(Get.context!, "luvpark", "No messages found",
          () {
        Get.back();
      });
    } else {
      CustomDialog().confirmationDialog(Get.context!, "luvpark",
          "Are you sure you want to delete all messages?", "Cancel", "Yes", () {
        Get.back();
      }, () {
        messages.clear();
        Get.back();
      });
    }
  }
}
