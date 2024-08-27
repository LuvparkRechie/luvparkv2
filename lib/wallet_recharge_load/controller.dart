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
  WalletRechargeLoadController();

  RxString aesKeys = "".obs;
  TextEditingController amountController = TextEditingController();
  final List<dynamic> bankPartner = [
    {
      "name": "U-Bank",
      "value": "UB",
      "img_url": "assets/images/ubank.png",
    },
  ];
  RxString email = "".obs;
  RxString fullName = "".obs;
  RxString hash = "".obs;
  RxBool isActiveBtn = false.obs;
  RxBool isLoadingPage = true.obs;
  RxBool isSelectedPartner = false.obs;
  RxBool isValidNumber = false.obs;
  final TextEditingController mobNum = TextEditingController();
  final GlobalKey<FormState> page1Key = GlobalKey<FormState>();
  RxString pageUrl = "".obs;
  TextEditingController rname = TextEditingController();
  RxInt? selectedBankTracker;
  // Nullable integer
  Rxn<int> selectedBankType = Rxn<int>();

  final String tokenAmount =
      Get.arguments; // from wallet recharge screen tokenAmount

  var userDataInfo;
  final TextEditingController userName = TextEditingController();

  Timer? _debounce;

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    rname = TextEditingController();
    amountController = TextEditingController(text: tokenAmount);
    fullName.value = "";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
    super.onInit();
  }

  Future<void> getData() async {
    var userData = await Authentication().getUserData();
    var item = jsonDecode(userData!);
    mobNum.text = item['mobile_no'].toString().substring(2);
    _onSearchChanged(mobNum.text, true);
  }

  Future<void> getBankUrl(bankCode, int ind) async {
    String subApi = "${ApiKeys.gApiSubFolderGetUbDetails}?code=$bankCode";

    CustomDialog().loadingDialog(Get.context!);
    HttpRequest(api: subApi).get().then((objData) {
      if (objData == "No Internet") {
        isSelectedPartner.value = false;
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

        isSelectedPartner.value = false;
        isLoadingPage.value = false;
        selectedBankType;
        selectedBankTracker = null;

        CustomDialog().errorDialog(Get.context!, "Error",
            "Error while connecting to server, Please try again.", () {
          Get.back();
        });

        return;
      } else {
        getBankData(objData["items"][0]["app_id"],
            objData["items"][0]["page_url"], ind);
      }
    });
  }

  getBankData(appId, url, ind) {
    String bankParamApi = "${ApiKeys.gApiSubFolderGetBankParam}?app_id=$appId";

    HttpRequest(api: bankParamApi).get().then((objData) {
      if (objData == "No Internet") {
        isSelectedPartner.value = false;
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

        isSelectedPartner.value = false;
        isLoadingPage.value = false;
        selectedBankType;
        selectedBankTracker = null;

        CustomDialog().errorDialog(Get.context!, "Error",
            "Error while connecting to server, Please try again.", () {
          Get.back();
        });

        return;
      } else {
        Get.back();
        var dataObj = {};

        for (int i = 0; i < objData["items"].length; i++) {
          dataObj[objData["items"][i]["param_key"]] =
              objData["items"][i]["param_value"];
        }

        isLoadingPage.value = false;
        selectedBankType = ind;
        selectedBankTracker = ind;
        isSelectedPartner.value = true;
        aesKeys = dataObj["AES_KEY"];
        pageUrl.value = Uri.decodeFull(url);
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

    hash.value = Uri.encodeComponent(output);

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

  void onPay() async {
    var uData = await Authentication().getUserData();
    var item = jsonDecode(uData!);
    if (page1Key.currentState!.validate()) {
      FocusManager.instance.primaryFocus!.unfocus();
      if (!isActiveBtn.value) {
        return;
      }
      if (!isSelectedPartner.value) {
        CustomDialog().errorDialog(
            Get.context!, "Attention", "Please Select payment method", () {
          Get.back();
        });
        return;
      }

      var dataParam = {
        "amount": tokenAmount,
        "user_id": userDataInfo["user_id"],
        "to_mobile_no": "63${mobNum.text.replaceAll(" ", "")}",
      };
      CustomDialog().loadingDialog(Get.context!);
      HttpRequest(api: ApiKeys.gApiSubFolderPostUbTrans, parameters: dataParam)
          .post()
          .then((returnPost) {
        if (returnPost == "No Internet") {
          Get.back();
          CustomDialog().errorDialog(Get.context!, "Error",
              "Please check your internet connection and try again.", () {
            Get.back();
          });
          return;
        }
        if (returnPost == null) {
          Get.back();
          CustomDialog().errorDialog(Get.context!, "Error",
              "Error while connecting to server, Please try again.", () {
            Get.back();
          });
        } else {
          if (returnPost["success"] == 'Y') {
            var plainText = {
              "Amt": tokenAmount,
              "Email": item['email'].toString(),
              "Mobile": mobNum.text.replaceAll(" ", ""),
              "Redir": "https://www.example.com",
              "References": [
                {
                  "Id": "1",
                  "Name": "RECIPIENT_MOBILE_NO",
                  "Val": "63${mobNum.text.replaceAll(" ", "")}"
                },
                {
                  "Id": "2",
                  "Name": "RECIPIENT_FULL_NAME",
                  "Val": userName.text.replaceAll(RegExp(' +'), ' ')
                },
                {"Id": "3", "Name": "TNX_HK", "Val": returnPost["hash-key"]}
              ]
            };
            Get.back();

            testUBUriPage(json.encode(plainText), aesKeys);
            if (Navigator.canPop(Get.context!)) {
              Get.back();
            }
          } else {
            Get.back();

            CustomDialog().errorDialog(Get.context!, "Error", returnPost['msg'],
                () {
              Get.back();
            });
          }
        }
      });
    }
  }

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
          isValidNumber.value = false;
          rname.text = "";
          fullName.value = "";
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

          isActiveBtn.value = false;
          isValidNumber.value = false;
          rname.text = "";
          fullName.value = "";
          userName.text = "";

          CustomDialog().errorDialog(Get.context!, "Error",
              "Error while connecting to server, Please try again.", () {
            Get.back();
          });
          return;
        }
        if (objData["items"].length == 0) {
          Get.back();

          isActiveBtn.value = false;
          userDataInfo = null;
          rname.text = "";
          userName.text = "";
          fullName.value = "";
          isValidNumber.value = false;

          CustomDialog().errorDialog(Get.context!, "Error",
              "Sorry, we're unable to find your account.", () {
            //  onChangeText();
            Get.back();
          });
          return;
        } else {
          Get.back();

          isActiveBtn.value = true;
          userDataInfo = objData["items"][0];
          isValidNumber.value = true;
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
}
