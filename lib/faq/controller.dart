import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/http/api_keys.dart';
import 'package:luvpark_get/http/http_request.dart';

class FaqPageController extends GetxController {
  RxList<Map<String, dynamic>> faqsData = <Map<String, dynamic>>[].obs;
  RxBool isLoadingPage = true.obs;
  RxBool isNetConn = true.obs;
  RxSet<int> expandedIndexes = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getFaq();
  }

  Future<void> getFaq() async {
    isLoadingPage.value = true;
    var returnData = await const HttpRequest(
      api: ApiKeys.gAPISubFolderFaqList,
    ).get();

    if (returnData == "No Internet") {
      isNetConn.value = false;
      isLoadingPage.value = false;
      CustomDialog().internetErrorDialog(Get.context!, () {
        Get.back();
      });
      return;
    }
    if (returnData == null) {
      isNetConn.value = true;
      isLoadingPage.value = false;
      CustomDialog().serverErrorDialog(Get.context!, () {
        Get.back();
      });
      return;
    }
    if (returnData["items"].isNotEmpty) {
      faqsData.value = List<Map<String, dynamic>>.from(returnData["items"]);
    } else {
      CustomDialog().errorDialog(Get.context!, "Luvpark", "No data found", () {
        Get.back();
      });
    }
    isLoadingPage.value = false;
  }

  Future<void> getFaqAnswers(String id, int index) async {
    var returnData = await HttpRequest(
      api: '${ApiKeys.gAPISubFolderFaqAnswer}?faq_id=$id',
    ).get();

    if (returnData == "No Internet") {
      isNetConn.value = false;
      isLoadingPage.value = false;
      CustomDialog().internetErrorDialog(Get.context!, () {
        Get.back();
      });
      return;
    }
    if (returnData == null) {
      isNetConn.value = true;
      isLoadingPage.value = false;
      CustomDialog().serverErrorDialog(Get.context!, () {
        Get.back();
      });
      return;
    }

    if (returnData["items"].length > 0) {
      faqsData[index]['answers'] = returnData["items"];
      expandedIndexes.add(index);
      update(); // Notify listeners
    } else {
      CustomDialog().errorDialog(Get.context!, "Luvpark", "No data found", () {
        Get.back();
      });
    }
  }
}
