import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';

class BookingReceiptController extends GetxController {
  late final Map<String, dynamic> parameters;
  late Timer _timer;
  RxDouble progress = 0.0.obs;
  Rx<Duration?> timeLeft = Rx<Duration?>(null);

  @override
  void onInit() {
    super.onInit();
    parameters = Get.arguments as Map<String, dynamic>;

    if (!parameters["isBooking"]) {
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

  @override
  void onClose() {
    if (!parameters["isBooking"]) {
      _timer.cancel();
    }
    super.onClose();
  }
}
