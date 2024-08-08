import 'package:get/get.dart';

class ParkingAreasController extends GetxController
    with GetSingleTickerProviderStateMixin {
  ParkingAreasController();
  bool isInternetConnected = true;
  final dataNearest = Get.arguments;
  RxList searchedZone = [].obs;
  RxBool isLoading = false.obs;

  void onSearch(String value) {
    searchedZone.value = dataNearest;
    searchedZone.value = dataNearest.where((e) {
      return e["park_area_name"]
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          e["address"].toString().toLowerCase().contains(value.toLowerCase());
    }).toList();

    update();
  }

  void onListTap(bool load) {
    isLoading.value = load;
    update();
  }

  @override
  void onInit() {
    searchedZone.value = dataNearest;
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
