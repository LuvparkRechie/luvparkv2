import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';

class MessageScreenController extends GetxController {
  MessageScreenController();
  RxBool isLoading = true.obs;
  RxBool isNetConn = true.obs;
  var messages = <String>[].obs;

  @override
  void onInit() {
    getMessage();
    super.onInit();
  }

  Future<void> getMessage() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    messages.value = [
      "Attention! Your vehicle requires assistance. Kindly proceed to your designated parking area. Broken side mirror.",
      "Parking reminder: Your parking slot is due for renewal.",
      "Important notice: Please update your parking information.",
      "Vehicle maintenance alert: Please check your tire pressure.",
      "Security alert: Unusual activity detected near your vehicle.",
      "Payment reminder: Your parking fees are due in 3 days.",
      "New parking policy: Please be aware of the updated rules.",
      "Notification: Your vehicle has been successfully parked.",
      "Reminder: Please remove your vehicle from the reserved spot.",
      "Service update: Parking area maintenance scheduled for tomorrow.",
      "Alert: Your vehicle's battery needs attention.",
      "Reminder: Your parking permit is about to expire.",
      "Important: New parking lot entrance has been opened.",
      "Alert: Severe weather expected, please secure your vehicle.",
      "Notification: Parking area CCTV cameras are now operational."
    ];
    isLoading.value = false;
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
