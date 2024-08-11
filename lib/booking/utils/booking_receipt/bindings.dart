import 'package:get/get.dart';
import 'package:luvpark_get/booking_notice/controller.dart';

class BookingReceiptBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingNoticeController>(() => BookingNoticeController());
  }
}
