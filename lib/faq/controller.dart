import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/http/api_keys.dart';
import 'package:luvpark_get/http/http_request.dart';

class FaqPageController extends GetxController {
  RxList faqsData = [].obs;
  RxBool isLoadingPage = true.obs;
  RxBool isNetConn = true.obs;
  RxList<int> expandedIndexes = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    getFaq();
  }

  Future<void> getFaq() async {
    faqsData.value = [];
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

    if (returnData["items"].length > 0) {
      faqsData.value = returnData["items"];
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
      update();
    } else {
      CustomDialog().errorDialog(Get.context!, "Luvpark", "No data found", () {
        Get.back();
      });
    }
  }
}
