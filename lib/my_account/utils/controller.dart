import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/custom_widgets/variables.dart';

import '../../http/api_keys.dart';
import '../../http/http_request.dart';

class UpdateProfileController extends GetxController {
  UpdateProfileController();
  final parameters = Get.arguments;
  PageController pageController = PageController();

  RxBool isLoading = true.obs;
  RxInt currentPage = 0.obs;

  //Step 1 variable
  RxList suffixes = [].obs;
  RxList civilData = [].obs;
  RxString gender = "M".obs;

  var selectedSuffix = Rx<String?>(null);
  var selectedCivil = Rx<String?>(null);

  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController bday = TextEditingController();

  //step 2 variable
  RxList regionData = [].obs;
  RxList provinceData = [].obs;
  RxList cityData = [].obs;
  RxList brgyData = [].obs;
  var selectedRegion = Rx<String?>(null);
  var selectedProvince = Rx<String?>(null);
  var selectedCity = Rx<String?>(null);
  var selectedBrgy = Rx<String?>(null);

  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController zipCode = TextEditingController();

  @override
  // ignore: unnecessary_overrides
  void onInit() {
    pageController = PageController();
    super.onInit();
    getSuffixes();

    for (dynamic datas in parameters) {
      regionData.add(
        {"text": datas["region_name"], "value": datas["region_id"]},
      );
    }
    for (dynamic item in Variables.civilStatusData) {
      civilData.add({"text": item["status"], "value": item["value"]});
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
    update();
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
  }

  getSuffixes() {
    suffixes.value = [
      {"text": "Jr", "value": "jr"},
      {"text": "Sr", "value": "sr"},
      {"text": "II", "value": "II"},
      {"text": "III", "value": "III"}
    ];
    isLoading.value = false;
  }

  void getProvinceData(id) async {
    CustomDialog().loadingDialog(Get.context!);
    var returnData = await HttpRequest(
            api: "${ApiKeys.gApiSubFolderGetProvince}?p_region_id=$id")
        .get();
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
    if (returnData["items"].isNotEmpty) {
      selectedProvince.value = null;
      selectedCity.value = null;
      selectedBrgy.value = null;
      provinceData.value = [];
      cityData.value = [];
      brgyData.value = [];
      provinceData.value = returnData["items"];

      return;
    } else {
      CustomDialog().serverErrorDialog(Get.context!, () {
        Get.back();
      });
    }
  }

  void getCityData(id) async {
    CustomDialog().loadingDialog(Get.context!);
    var returnData = await HttpRequest(
            api: "${ApiKeys.gApiSubFolderGetCity}?p_province_id=$id")
        .get();
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
    if (returnData["items"].isNotEmpty) {
      selectedCity.value = null;
      selectedBrgy.value = null;
      cityData.value = [];
      brgyData.value = [];
      cityData.value = returnData["items"];

      return;
    } else {
      CustomDialog().serverErrorDialog(Get.context!, () {
        Get.back();
      });
    }
  }

  void getBrgyData(id) async {
    CustomDialog().loadingDialog(Get.context!);
    var returnData =
        await HttpRequest(api: "${ApiKeys.gApiSubFolderGetBrgy}?p_city_id=$id")
            .get();
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
    if (returnData["items"].isNotEmpty) {
      brgyData.value = [];
      selectedBrgy.value = null;
      brgyData.value = returnData["items"];

      return;
    } else {
      CustomDialog().serverErrorDialog(Get.context!, () {
        Get.back();
      });
    }
  }
}
