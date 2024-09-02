import 'package:get/get.dart';
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/custom_widgets/variables.dart';
import 'package:luvpark_get/http/api_keys.dart';
import 'package:luvpark_get/http/http_request.dart';
import 'package:luvpark_get/routes/routes.dart';

class MyAccountScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  MyAccountScreenController();
  RxList regionData = [].obs;
  RxList userData = [].obs;
  RxString myName = "".obs;
  RxString civilStatus = "".obs;
  RxString province = "".obs;
  RxString gender = "".obs;
  RxString myprofile = "".obs;
  RxBool isLoading = true.obs;
  RxBool isNetConn = true.obs;
  @override
  // ignore: unnecessary_overrides
  void onInit() {
    super.onInit();
    getUserData();
  }

  void getUserData() async {
    final profilepic = await Authentication().getUserProfilePic();
    final data = await Authentication().getUserData2();

    myprofile.value = profilepic;
    userData.add(data);

    civilStatus.value = Variables.civilStatusData.where((element) {
      return element["value"] == userData[0]['civil_status'];
    }).toList()[0]["status"];
    gender.value = userData[0]['gender'] == "F" ? "Female" : "Male";

    if (userData[0]['first_name'] != null) {
      if (userData[0]['region_id'] == null) {
        province.value = "No province provided";
      } else {
        getProvince(userData[0]['region_id']);
      }
    } else {
      isLoading.value = false;
      isNetConn.value = true;
    }
  }

  void getRegions() async {
    CustomDialog().loadingDialog(Get.context!);
    var returnData =
        await const HttpRequest(api: ApiKeys.gApiSubFolderGetRegion).get();
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
      regionData.value = returnData["items"];
      Get.toNamed(
        Routes.updProfile,
        arguments: regionData,
      );
      return;
    } else {
      CustomDialog().serverErrorDialog(Get.context!, () {
        Get.back();
      });
    }
  }

  void getProvince(regionId) async {
    String params = "${ApiKeys.gApiSubFolderGetProvince}?p_region_id=$regionId";

    isLoading.value = false;

    var returnData = await HttpRequest(api: params).get();

    if (returnData == "No Internet") {
      isNetConn.value = false;
      CustomDialog().internetErrorDialog(Get.context!, () {
        Get.back();
      });
      return;
    }
    if (returnData == null) {
      CustomDialog().serverErrorDialog(Get.context!, () {
        Get.back();
      });
      isNetConn.value = true;
      return;
    }
    if (returnData["items"].isNotEmpty) {
      isNetConn.value = true;
      province.value = returnData["items"][0]["text"];

      return;
    } else {
      isNetConn.value = true;

      CustomDialog().serverErrorDialog(Get.context!, () {
        Get.back();
      });
    }
  }
}
