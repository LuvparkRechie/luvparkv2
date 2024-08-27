import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/http/http_request.dart';
import 'package:luvpark_get/web_view/webview.dart';
import 'package:page_transition/page_transition.dart';

import '../auth/authentication.dart';
import '../custom_widgets/variables.dart';
import '../http/api_keys.dart';

class WalletRechargeLoadController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final String tokenAmount =
      Get.arguments; // from wallet recharge screen tokenAmount
  WalletRechargeLoadController();
  Timer? _debounce;
  RxBool isValidNumber = false.obs;
  RxString fullName = "".obs;
  RxBool isActiveBtn = false.obs;
  RxBool isSelectedPartner = false.obs;
  RxInt? selectedBankTracker;
  RxBool isLoadingPage = true.obs;
  RxString pageUrl = "".obs;
  RxString aesKeys = "".obs;
  RxString hash = "".obs;
  var userDataInfo;
  final GlobalKey<FormState> page1Key = GlobalKey<FormState>();
  final TextEditingController mobNum = TextEditingController();
  TextEditingController rname = TextEditingController();
  final TextEditingController userName = TextEditingController();
  TextEditingController amountController = TextEditingController();

  // Nullable integer
  Rxn<int> selectedBankType = Rxn<int>();
  final List<dynamic> bankPartner = [
    {
      "name": "U-Bank",
      "value": "UB",
      "img_url": "assets/images/ubank.png",
    },
  ];
  @override
  void onInit() {
    rname = TextEditingController();
    amountController = TextEditingController(text: tokenAmount);

    getData();
    super.onInit();
  }

  Future<void> getData() async {
    var userData = await Authentication().getUserData();
    var item = jsonDecode(userData!);
    mobNum.text = item['mobile_no'].toString().substring(2);
    _onSearchChanged(mobNum.text, true);
  }

  Future<void> getBankUrl(bankCode, int index) async {
    String subApi = "${ApiKeys.gApiSubFolderGetUbDetails}?code=$bankCode";
    selectedBankType.value = index;

    CustomDialog().loadingDialog(Get.context!);
    HttpRequest(api: subApi).get().then((objData) {
      if (isValidNumber == false.obs) {
        if (objData == "No Internet") {
          isSelectedPartner = false.obs;
          selectedBankType;
          selectedBankTracker;

          Get.back();
          CustomDialog().errorDialog(Get.context!, "Error",
              "Please check your internet connection and try again.", () {
            Get.back();
          });
          return;
        }
        if (objData == null || objData["items"].length == 0) {
          Get.back();

          isSelectedPartner = false.obs;
          isLoadingPage = false.obs;
          selectedBankType;
          selectedBankTracker = null;

          CustomDialog().errorDialog(Get.context!, "Error",
              "Error while connecting to server, Please try again.", () {
            Get.back();
          });

          return;
        } else {
          Get.back();
          getBankData(objData["items"][0]["app_id"],
              objData["items"][0]["page_url"], index);
        }
      }
    });
  }

  getBankData(appId, url, ind) {
    String bankParamApi = "${ApiKeys.gApiSubFolderGetBankParam}?app_id=$appId";
    CustomDialog().loadingDialog(Get.context!);
    HttpRequest(api: bankParamApi).get().then((objData) {
      if (objData == "No Internet") {
        isSelectedPartner = false.obs;
        selectedBankType;
        selectedBankTracker;

        Get.back();
        CustomDialog().errorDialog(Get.context!, "Error",
            "Please check your internet connection and try again.", () {
          Get.back();
        });
        return;
      }
      if (objData == null || objData["items"].length == 0) {
        Get.back();

        isSelectedPartner = false.obs;
        isLoadingPage = false.obs;
        selectedBankType;
        selectedBankTracker = null;

        CustomDialog().errorDialog(Get.context!, "Error",
            "Error while connecting to server, Please try again.", () {
          Get.back();
        });

        return;
      } else {
        var dataObj = {};

        for (int i = 0; i < objData["items"].length; i++) {
          dataObj[objData["items"][i]["param_key"]] =
              objData["items"][i]["param_value"];
        }

        isLoadingPage = false.obs;
        selectedBankType = ind;
        selectedBankTracker = ind;
        isSelectedPartner = true.obs;
        aesKeys = dataObj["AES_KEY"];
        pageUrl = Uri.decodeFull(url).obs;

        Get.back();
      }
    });
  }

  Future<void> testUBUriPage(plainText, secretKeyHex) async {
    final secretKey = Variables.hexStringToArrayBuffer(secretKeyHex);
    final nonce = Variables.generateRandomNonce();

    // Encrypt
    final encrypted = await Variables.encryptData(secretKey, nonce, plainText);

    final concatenatedArray = Variables.concatBuffers(nonce, encrypted);
    final output = Variables.arrayBufferToBase64(concatenatedArray);

    hash = Uri.encodeComponent(output).obs;

    // ignore: use_build_context_synchronously

    // ignore: use_build_context_synchronously
    Get.to(Get.context!,
        arguments: PageTransition(
          type: PageTransitionType.scale,
          duration: const Duration(seconds: 1),
          alignment: Alignment.centerLeft,
          child: WebviewPage(urlDirect: "$pageUrl$hash", label: "Bank Payment"),
        ));
  }

  Future<void> generateBank() async {}
  _onSearchChanged(mobile, isFirst) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    if (mobile.toString().length < 10) {
      return;
    }
    Duration duration = const Duration(milliseconds: 200);
    if (isFirst) {
      duration = const Duration(milliseconds: 200);
    } else {
      duration = const Duration(seconds: 2);
    }

    _debounce = Timer(duration, () {
      CustomDialog().loadingDialog(Get.context!);
      HttpRequest(
              api:
                  "${ApiKeys.gApiSubFolderGetUserInfo}?mobile_no=63${mobile.toString().replaceAll(" ", '')}")
          .get()
          .then((objData) {
        if (objData == "No Internet") {
          isValidNumber = false.obs;
          rname.text = "";
          fullName = "".obs;
          userName.text = "";

          Get.back();
          CustomDialog().errorDialog(Get.context!, "Error",
              "Please check your internet connection and try again.", () {
            Get.back();
            if (Navigator.canPop(Get.context!)) {
              Get.back();
            }
          });
          return;
        }
        if (objData == null) {
          Get.back();

          isActiveBtn = false.obs;
          isValidNumber = false.obs;
          rname.text = "";
          fullName = "".obs;
          userName.text = "";

          CustomDialog().errorDialog(Get.context!, "Error",
              "Error while connecting to server, Please try again.", () {
            Get.back();
          });
          return;
        }
        if (objData["items"].length == 0) {
          Get.back();

          isActiveBtn = false.obs;
          userDataInfo = null;
          rname.text = "";
          userName.text = "";
          fullName = "".obs;
          isValidNumber = false.obs;

          CustomDialog().errorDialog(Get.context!, "Error",
              "Sorry, we're unable to find your account.", () {
            //  onChangeText();
            Get.back();
          });
          return;
        } else {
          Get.back();

          isActiveBtn = true.obs;
          userDataInfo = objData["items"][0];
          isValidNumber = true.obs;
          String originalFullName = userDataInfo["first_name"].toString();
          String transformedFullName = Variables.transformFullName(
              originalFullName.replaceAll(RegExp(r'\..*'), ''));
          String transformedLname = Variables.transformFullName(
              userDataInfo["last_name"]
                  .toString()
                  .replaceAll(RegExp(r'\..*'), ''));

          String middelName = "";
          if (userDataInfo["middle_name"] != null) {
            middelName = userDataInfo["middle_name"].toString()[0];
          } else {
            middelName = "";
          }
          userName.text =
              "$originalFullName $middelName ${userDataInfo["last_name"].toString()}";
          fullName.value =
              '$transformedFullName $middelName${middelName.isNotEmpty ? "." : ""} $transformedLname';
          rname.text = fullName.value;
        }
      });
    });
  }

  void onPay() {}
  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
