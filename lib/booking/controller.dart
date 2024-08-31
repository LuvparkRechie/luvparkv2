import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/custom_widgets/variables.dart';
import 'package:luvpark_get/functions/functions.dart';
import 'package:luvpark_get/http/api_keys.dart';
import 'package:luvpark_get/http/http_request.dart';
import 'package:luvpark_get/routes/routes.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../booking_notice/view.dart';

class BookingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  BookingController();
  final parameters = Get.arguments;

  TextEditingController timeInParam = TextEditingController();
  TextEditingController plateNo = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController noHours = TextEditingController();
  TextEditingController inpDisplay = TextEditingController();
  TextEditingController rewardsCon = TextEditingController();

  RxString hintTextLabel = "Plate No.".obs;
  RxString vehicleText = "Tap to add vehicle".obs;
  RxString inputTimeLabel = 'Input a Duration'.obs;
  RxBool isBtnLoading = false.obs;
  RxBool isHideBottom = true.obs;

  RxBool hasInternetBal = true.obs;
  RxBool isRewardchecked = false.obs;
  RxBool isExtendchecked = false.obs;
  RxBool isLoadingPage = true.obs;
  RxBool isInternetConn = true.obs;
  MaskTextInputFormatter? maskFormatter;
  final Map<String, RegExp> _filter = {
    'A': RegExp(r'[A-Za-z0-9]'),
    '#': RegExp(r'[A-Za-z0-9]')
  };
  int numberOfhours = 1;
  RxList numbersList = [].obs;
  RxList selectedVh = [].obs;
  RxList vehicleTypeData = [].obs;
  RxInt selectedNumber = RxInt(0);
  RxString totalAmount = "0.0".obs;
  RxString vehicleTypeValue = "".obs;

  //VH OPTION PARAm
  final GlobalKey<FormState> bookKey = GlobalKey<FormState>();
  RxBool isFirstScreen = true.obs;
  RxBool isLoadingVehicles = true.obs;
  RxBool isNetConnVehicles = true.obs;
  RxList myVehiclesData = [].obs;
  RxList ddVehiclesData = [].obs;
  String? dropdownValue;

  //Booking param
  RxBool isSubmitBooking = false.obs;

  Timer? inactivityTimer;
  final int timeoutDuration = 180; //3 mins

  @override
  void onInit() {
    super.onInit();

    _startInactivityTimer();
    _updateMaskFormatter("");
    int endNumber =
        int.parse(parameters["areaData"]["res_max_hours"].toString());
    numbersList.value = List.generate(
        endNumber - numberOfhours + 1, (index) => numberOfhours + index);
    if (numbersList.isNotEmpty) {
      selectedNumber.value = 0;
      noHours.text =
          "1 ${int.parse(selectedNumber.value.toString()) > 1 ? "hours" : "hour"}";
    }

    timeInParam = TextEditingController();
    plateNo = TextEditingController();
    startDate = TextEditingController();
    endDate = TextEditingController();
    startTime = TextEditingController();
    endTime = TextEditingController();
    noHours = TextEditingController();
    inpDisplay = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timeComputation();
      getAvailabeAreaVh();
    });
  }

  void _startInactivityTimer() {
    inactivityTimer?.cancel();
    inactivityTimer =
        Timer(Duration(seconds: timeoutDuration), _handleInactivity);
  }

  void _handleInactivity() {
    inactivityTimer?.cancel();
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text('No Interaction Detected'),
            content: const Text(
                'No gestures were detected within the last minute. Reloading the page.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _reloadPage();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _reloadPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timeComputation();
      getAvailabeAreaVh();
    });
  }

  void onUserInteraction() {
    _startInactivityTimer(); // Reset timer on any interaction
  }

  void _updateMaskFormatter(mask) {
    if (mask != null) {
      hintTextLabel.value = mask.toString();
    } else {
      hintTextLabel.value = "Plate No.";
    }
    maskFormatter = MaskTextInputFormatter(
      mask: mask,
      filter: _filter,
    );
  }

  void timeComputation() {
    DateTime now = DateTime.now();
    startDate.text = DateTime.now().toString().split(" ")[0].toString();
    startTime.text = DateFormat('h:mm a').format(now).toString();
    DateTime parsedTime = DateFormat('hh:mm a').parse(startTime.text);
    timeInParam.text = DateFormat('HH:mm').format(parsedTime);
    endTime.text = DateFormat('h:mm a')
        .format(parsedTime.add(Duration(hours: numberOfhours)))
        .toString();
  }

  void onTapChanged(int i) {
    selectedNumber.value = numbersList[i];
    noHours.text =
        "${selectedNumber.value} ${int.parse(selectedNumber.value.toString()) > 1 ? "hours" : "hour"}";

    update();
  }

  void toggleRewardChecked(bool value) {
    isRewardchecked.value = value;
  }

  void toggleExtendChecked(bool value) {
    isExtendchecked.value = value;
  }

  //Get Vehicle Formatter or if there is vehicle in this area
  Future<void> getAvailabeAreaVh() async {
    isLoadingPage.value = true;
    final dataVehicle = [];
    HttpRequest(
            api:
                "${ApiKeys.gApiSubFolderGetVehicleType}?park_area_id=${parameters["areaData"]["park_area_id"]}")
        .get()
        .then((returnData) async {
      if (returnData == "No Internet") {
        isInternetConn.value = false;
        isLoadingPage.value = false;
        CustomDialog().internetErrorDialog(Get.context!, () {
          Get.back();
        });
        return;
      }
      if (returnData == null) {
        isLoadingPage.value = false;
        isInternetConn.value = true;
        CustomDialog().serverErrorDialog(Get.context!, () {
          Get.back();
        });
        return;
      }
      isInternetConn.value = true;
      if (returnData["items"].length > 0) {
        isLoadingPage.value = false;

        for (var items in returnData["items"]) {
          dataVehicle.add({
            "vehicle_id": items["vehicle_type_id"],
            "vehicle_desc": items["vehicle_type_desc"],
            "format": items["input_format"],
          });
        }
        vehicleTypeData.value = dataVehicle;
        _updateMaskFormatter(vehicleTypeData[0]["format"]);
      }

      Get.bottomSheet(const BookingNotice(),
          isScrollControlled: true, enableDrag: false, isDismissible: false);
    });
  }

  //Vehicle
  void onScreenChanged(bool value) {
    isFirstScreen.value = value;
  }

  //GET my registered vehicle
  Future<void> getMyVehicle() async {
    if (selectedVh.isEmpty) {
      isBtnLoading.value = true;
    }
    isLoadingVehicles.value = true;
    isNetConnVehicles.value = true;

    isFirstScreen.value = true;
    plateNo.text = "";
    final item = await Authentication().getUserData();
    int userId = jsonDecode(item!)["user_id"];
    String api =
        "${ApiKeys.gApiLuvParkPostGetVehicleReg}?user_id=$userId&vehicle_types_id_list=${parameters["areaData"]["vehicle_types_id_list"]}";

    HttpRequest(api: api).get().then((myVehicles) async {
      if (myVehicles == "No Internet") {
        isNetConnVehicles.value = false;
        isLoadingVehicles.value = true;
        CustomDialog().internetErrorDialog(Get.context!, () {
          Get.back();
        });

        return;
      }
      if (myVehicles == null) {
        isNetConnVehicles.value = true;
        isLoadingVehicles.value = true;
        CustomDialog().serverErrorDialog(Get.context!, () {
          Get.back();
        });
        return;
      }

      if (myVehicles["items"].length > 0) {
        myVehiclesData.value = [];

        for (var row in myVehicles["items"]) {
          String brandName = await Functions.getBrandName(
              row["vehicle_type_id"], row["vehicle_brand_id"]);

          myVehiclesData.add({
            "vehicle_type_id": row["vehicle_type_id"],
            "vehicle_brand_id": row["vehicle_brand_id"],
            "vehicle_brand_name": brandName,
            "vehicle_plate_no": row["vehicle_plate_no"],
          });
        }
        getDropdownVehicles();
      }
    });
  }

  //GET drodown vehicles per area
  Future<void> getDropdownVehicles() async {
    HttpRequest(
            api:
                "${ApiKeys.gApiLuvParkDDVehicleTypes2}?park_area_id=${parameters["areaData"]["park_area_id"]}")
        .get()
        .then((returnData) async {
      if (returnData == "No Internet") {
        isNetConnVehicles.value = false;
        isLoadingVehicles.value = true;
        CustomDialog().internetErrorDialog(Get.context!, () {
          Get.back();
        });

        return;
      }
      if (returnData == null) {
        isNetConnVehicles.value = true;
        isLoadingVehicles.value = true;
        CustomDialog().serverErrorDialog(Get.context!, () {
          Get.back();
        });
        return;
      }
      isNetConnVehicles.value = true;
      isLoadingVehicles.value = false;
      ddVehiclesData.value = [];

      if (returnData["items"].length > 0) {
        dynamic items = returnData["items"];
        ddVehiclesData.value = items.map((item) {
          return {
            "text": item["vehicle_type_desc"],
            "value": item["vehicle_type_id"],
            "base_hours": item["base_hours"],
            "base_rate": item["base_rate"],
            "succeeding_rate": item["succeeding_rate"],
          };
        }).toList();
      }
    });
  }

  //Compute booking payment
  Future<void> routeToComputation() async {
    isBtnLoading.value = true;

    int selNoHours = int.parse(selectedNumber.value.toString());
    int selBaseHours = int.parse(selectedVh[0]["base_hours"].toString());
    int selSucceedRate = int.parse(selectedVh[0]["succeeding_rate"].toString());
    int amount = int.parse(selectedVh[0]["base_rate"].toString());

    int finalData = 0;

    if (selNoHours > selBaseHours) {
      finalData = amount + ((selNoHours - selBaseHours)) * selSucceedRate;
    } else {
      finalData = amount;
    }
    isBtnLoading.value = false;
    totalAmount.value = "$finalData";
  }

  //Reservation Submit
  void submitReservation(params) async {
    List bookingParams = [params];

    int userId = await Authentication().getUserId();
    isSubmitBooking.value = true;
    final position = await Functions.getCurrentPosition();
    LatLng current = LatLng(position[0]["lat"], position[0]["long"]);
    LatLng destinaion = LatLng(parameters["areaData"]["pa_latitude"],
        parameters["areaData"]["pa_longitude"]);
    final etaData = await Functions.fetchETA(current, destinaion);

    if (etaData.isEmpty) {
      isSubmitBooking.value = false;
      CustomDialog().errorDialog(Get.context!, "Error",
          "We couldn't calculate the distance. Please check your connection and try again.",
          () {
        Get.back();
      });
      return;
    }

    if (etaData[0]["error"] == "No Internet") {
      isSubmitBooking.value = false;
      CustomDialog().internetErrorDialog(Get.context!, () {
        Get.back();
      });
      return;
    }

    int etaTime =
        int.parse(etaData[0]["time"].toString().split(" ")[0].toString());
    int areaEtaTime = etaTime +
        int.parse(
            parameters["areaData"]["book_grace_period_in_mins"].toString());

    Map<String, dynamic> dynamicBookParam = {
      "user_id": userId,
      "amount": totalAmount.value,
      "no_hours": selectedNumber.value.toString(),
      "dt_in": params["dt_in"].toString(),
      "dt_out": params["dt_out"].toString(),
      "eta_in_mins": areaEtaTime,
      "vehicle_type_id": params["vehicle_type_id"].toString(),
      "vehicle_plate_no": params["vehicle_plate_no"],
      "park_area_id": params["park_area_id"].toString(),
    };

    CustomDialog().confirmationDialog(
        Get.context!,
        "Confirm Booking",
        "Please ensure that you arrive at the destination by $areaEtaTime mins, or your advance booking will be forfeited.",
        "Cancel",
        "Proceed", () {
      Get.back();
    }, () {
      Get.back();

      HttpRequest(api: ApiKeys.gApiBooking, parameters: dynamicBookParam)
          .postBody()
          .then((objData) async {
        if (objData == "No Internet") {
          isSubmitBooking.value = false;
          CustomDialog().internetErrorDialog(Get.context!, () {
            Get.back();
          });
          return;
        }
        if (objData == null) {
          isSubmitBooking.value = false;
          CustomDialog().serverErrorDialog(Get.context!, () {
            Get.back();
          });
        }
        if (objData["success"] == "Y") {
          dynamic paramArgs = {
            'parkArea': parameters["areaData"]["park_area_name"],
            'startDate': Variables.formatDate(
                bookingParams[0]["dt_in"].toString().split(" ")[0]),
            'endDate': Variables.formatDate(
                bookingParams[0]["dt_out"].toString().split(" ")[0]),
            'startTime':
                bookingParams[0]["dt_in"].toString().split(" ")[1].toString(),
            'endTime':
                bookingParams[0]["dt_out"].toString().split(" ")[1].toString(),
            'plateNo': bookingParams[0]["vehicle_plate_no"].toString(),
            'hours': bookingParams[0]["no_hours"].toString(),
            'amount': totalAmount.value.toString(),
            'refno': objData["lp_ref_no"].toString(),
            'lat':
                double.parse(parameters["areaData"]['pa_latitude'].toString()),
            'long':
                double.parse(parameters["areaData"]['pa_longitude'].toString()),
            'canReserved': false,
            'isReserved': false,
            'isShowRate': true,
            'reservationId': objData["reservation_id"],
            'address': parameters["areaData"]["address"],
            'area_data': parameters["areaData"],
            'isAutoExtend': false,
            'isBooking': true,
            'status': "B",
            'paramsCalc': bookingParams[0]
          };
          Map<String, dynamic> lastBookingData = {
            "plate_no": selectedVh[0]["vehicle_plate_no"].toString(),
            "brand_name": selectedVh[0]["vehicle_brand_name"].toString(),
            "park_area_id": parameters["areaData"]["park_area_id"].toString(),
          };
          print("paramArgs $paramArgs");
          Authentication().setLastBooking(jsonEncode(lastBookingData));
          if (parameters["canCheckIn"]) {
            checkIn(objData["reservation_id"], userId, paramArgs);
            return;
          } else {
            isSubmitBooking.value = false;
            Get.offAndToNamed(Routes.bookingReceipt, arguments: paramArgs);

            return;
          }
        }
        if (objData["success"] == "Q") {
          CustomDialog().confirmationDialog(
              Get.context!, "Queue Booking", objData["msg"], "No", "Yes", () {
            Get.back();
          }, () {
            Map<String, dynamic> queueParam = {
              'luvpay_id': userId,
              'park_area_id': params["park_area_id"],
              'vehicle_type_id': params["vehicle_type_id"].toString(),
              'vehicle_plate_no': params["vehicle_plate_no"]
            };

            HttpRequest(
                    api: ApiKeys.gApiLuvParkResQueue, parameters: queueParam)
                .post()
                .then((queParamData) {
              if (queParamData == "No Internet") {
                isSubmitBooking.value = false;
                CustomDialog().internetErrorDialog(Get.context!, () {
                  Get.back();
                });
                return;
              }
              if (queParamData == null) {
                isSubmitBooking.value = false;
                CustomDialog().serverErrorDialog(Get.context!, () {
                  Get.back();
                });
                return;
              } else {
                isSubmitBooking.value = false;
                if (queParamData["success"] == 'Y') {
                  CustomDialog().successDialog(Get.context!, "Success",
                      queParamData["msg"], "Go to dashboad", () {
                    Get.offAllNamed(Routes.map);
                  });
                } else {
                  CustomDialog().errorDialog(
                      Get.context!, 'luvpark', queParamData["msg"], () {
                    Get.back();
                  });
                }
              }
            });
          });
          return;
        } else {
          isSubmitBooking.value = false;
          CustomDialog().errorDialog(Get.context!, "luvpark", objData["msg"],
              () {
            Get.back();
          });
          return;
        }
      });
    });
  }

  //Self checkin
  Future<void> checkIn(ticketId, lpId, args) async {
    dynamic chkInParam = {
      "ticket_id": ticketId,
      "luvpay_id": lpId,
    };

    HttpRequest(api: ApiKeys.gApiPostSelfCheckIn, parameters: chkInParam)
        .postBody()
        .then((returnData) async {
      if (returnData == "No Internet") {
        isSubmitBooking.value = false;
        CustomDialog().internetErrorDialog(Get.context!, () {
          Get.back();
        });
        return;
      }
      if (returnData == null) {
        isSubmitBooking.value = false;
        CustomDialog().serverErrorDialog(Get.context!, () {
          Get.back();
        });

        return;
      }
      isSubmitBooking.value = false;
      if (returnData["success"] == 'Y') {
        Get.offNamed(Routes.bookingReceipt, arguments: args);
      } else {
        CustomDialog().errorDialog(Get.context!, "luvpark", returnData["msg"],
            () {
          Get.back();
        });
      }
    });
  }

  void showRewardDialog() {
    Get.dialog(Container(
      height: 200,
      width: 200,
      color: Colors.white,
    ));
    // showDialog<double>(
    //   context: Get.context!,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: CustomTitle(
    //         text: "Reward Points",
    //         fontWeight: FontWeight.w700,
    //         fontSize: 19,
    //       ),
    //       content: Container(
    //         height: 150,
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             CustomParagraph(text: "Enter desired amount to be used"),
    //             CustomTextField(
    //               label:
    //                   toCurrencyString(parameters["userData"][0]["points_bal"])
    //                       .toString(),
    //               controller: rewardsCon,
    //               keyboardType: TextInputType.number,
    //               inputFormatters: [
    //                 //LengthLimitingTextInputFormatter(int.parse(totalAmount)),
    //                 FilteringTextInputFormatter.digitsOnly
    //               ],
    //               onChanged: (value) {
    //                 if (int.parse(value) >
    //                     int.parse(
    //                         widget.totalAmount.toString().split(".")[0])) {
    //                   setState(() {
    //                     isExceed = true;
    //                   });
    //                 } else {
    //                   setState(() {
    //                     isExceed = false;
    //                   });
    //                 }
    //               },
    //             ),
    //             if (isExceed)
    //               CustomParagraph(
    //                 text:
    //                     "Reward points inputted should not be greater than the total bill for parking",
    //                 maxlines: 2,
    //                 fontSize: 10,
    //                 color: Colors.red,
    //               ),
    //           ],
    //         ),
    //       ),
    //       actions: <Widget>[
    //         TextButton(
    //           child: Text('Cancel'),
    //           onPressed: () {
    //             _rewardpoints.clear();
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //         TextButton(
    //           child: Text('OK'),
    //           onPressed: () {
    //             if (int.parse(_rewardpoints.text) >
    //                 int.parse(totalAmount.toString().split(".")[0])) {
    //               showAlertDialog(context, "LuvPark", "Limit exceeds", () {
    //                 Navigator.of(context).pop();
    //               });
    //             } else {
    //               Navigator.of(context).pop(double.parse(_rewardpoints.text));
    //             }
    //             _RewardSubtract();
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  @override
  void onClose() {
    super.onClose();
    bookKey.currentState?.reset();
    inactivityTimer?.cancel();
  }
}
