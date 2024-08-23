import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:luvpark_get/booking/utils/extend.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/functions/functions.dart';
import 'package:luvpark_get/http/api_keys.dart';
import 'package:luvpark_get/http/http_request.dart';

class BookingReceiptController extends GetxController
    with GetTickerProviderStateMixin {
  final parameters = Get.arguments;
  late Timer _timer;
  RxDouble progress = 0.0.obs;
  RxInt noHours = 1.obs;
  Rx<Duration?> timeLeft = Rx<Duration?>(null);
  RxBool isSubmit = false.obs;

  @override
  void onInit() {
    super.onInit();

    if (parameters["status"] == "A") {
      startTimer();
    }
  }

  void startTimer() {
    DateTime startTime =
        DateTime.parse(parameters["paramsCalc"]["dt_in"].toString());
    DateTime endTime =
        DateTime.parse(parameters["paramsCalc"]["dt_out"].toString());

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      DateTime currentTime = DateTime.now();
      Duration timeElapsed = currentTime.difference(startTime);
      Duration totalTime = endTime.difference(startTime);
      progress.value = timeElapsed.inSeconds / totalTime.inSeconds;

      Duration remainingTime = endTime.difference(currentTime);
      if (remainingTime.isNegative) {
        remainingTime = Duration.zero;
      }
      timeLeft.value = remainingTime;

      if (progress.value >= 1) {
        _timer.cancel();
        progress.value = 1.0;
        CustomDialog().loadingDialog(Get.context!);
        Future.delayed(const Duration(seconds: 2), () {
          Get.back();
          Get.back();
        });
      }
    });
  }

  String formatDateTime(DateTime dtIn, DateTime dtOut) {
    final DateFormat dateFormat = DateFormat('MMM d');
    final DateFormat fullDateFormat = DateFormat('MMM d, yyyy');

    // Check if the dates are on the same day
    if (dtIn.toLocal().year == dtOut.toLocal().year &&
        dtIn.toLocal().month == dtOut.toLocal().month &&
        dtIn.toLocal().day == dtOut.toLocal().day) {
      return fullDateFormat.format(dtIn);
    } else {
      final startDate = dateFormat.format(dtIn);
      final endDate = dateFormat.format(dtOut);
      final endYear = fullDateFormat.format(dtOut).split(', ')[1];

      return '$startDate - ${endDate.split(" ")[1]}, $endYear';
    }
  }

  String formatTimeRange(String dtIn, String dtOut) {
    final DateFormat timeFormat = DateFormat('h:mm a');
    return '${timeFormat.format(DateTime.parse(dtIn))} - ${timeFormat.format(DateTime.parse(dtOut))}';
  }

//EXTEND FUNCTION
  void onExtend() {
    Get.bottomSheet(const ExtendParking(),
        isDismissible: true, isScrollControlled: true);
  }

  void onAdd() {
    noHours.value++;
    update();
  }

  void onMinus() {
    if (noHours.value == 1) return;
    noHours.value--;
    update();
  }

  Future<void> onSubmit() async {
    CustomDialog().confirmationDialog(Get.context!, "Confirmation",
        "Are you sure you want to proceed?", "No", "yes", () {
      Get.back();
    }, () {
      Get.back();
      CustomDialog().loadingDialog(Get.context!);

      Functions.getUserBalance(Get.context!, (dataBalance) async {
        if (dataBalance[0]["success"]) {
          final items = dataBalance[0]["items"];
          dynamic paramHours = {
            "no_hours": noHours.value,
            "ps_ref_no": parameters["refno"],
            "luvpark_amount": items[0]["amount_bal"]
          };

          HttpRequest(
                  api: ApiKeys.gApiSubFolderPutExtend, parameters: paramHours)
              .put()
              .then((returnPost) {
            if (returnPost == "No Internet") {
              Get.back();
              CustomDialog().internetErrorDialog(Get.context!, () {
                Get.back();
              });
              return;
            }
            if (returnPost == null) {
              Get.back();
              CustomDialog().serverErrorDialog(Get.context!, () {
                Get.back();
              });
            }

            if (returnPost["success"] == "Y") {
              var param = {
                "payment_date": DateTime.now().toString().split(".")[0],
                "amount": returnPost["amount"].toString(),
                "dt_out": returnPost["dt_out"].toString(),
                "reservation_ref_no": parameters["refno"],
                "user_id": items[0]["user_id"],
                "no_hours": noHours.value,
              };

              HttpRequest(
                      api: ApiKeys.gApiSubFolderPutExtendPay, parameters: param)
                  .put()
                  .then((returnPut) {
                if (returnPut == "No Internet") {
                  Get.back();
                  CustomDialog().internetErrorDialog(Get.context!, () {
                    Get.back();
                  });
                  return;
                }
                if (returnPut == null) {
                  Get.back();
                  CustomDialog().serverErrorDialog(Get.context!, () {
                    Get.back();
                  });
                }
                if (returnPut["success"] == "Y") {
                  Get.back();
                  Get.back();
                  Get.back();
                  parameters["onRefresh"]();
                } else {
                  Get.back();

                  CustomDialog().errorDialog(
                      Get.context!, "luvpark", returnPut["msg"], () {
                    Get.back();
                  });
                }
              });
            } else {
              Get.back();
              CustomDialog()
                  .errorDialog(Get.context!, "luvpark", returnPost["msg"], () {
                Get.back();
              });
            }
          });
        } else {
          Get.back();
        }
      });
    });
  }

  @override
  void onClose() {
    if (parameters["status"] == "A") {
      _timer.cancel();
    }
    super.onClose();
  }
}
