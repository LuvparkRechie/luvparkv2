import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luvpark_get/booking/index.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_button.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/inputfield.dart';
import 'package:luvpark_get/custom_widgets/no_data_found.dart';
import 'package:luvpark_get/custom_widgets/no_internet.dart';
import 'package:luvpark_get/custom_widgets/variables.dart';
import 'package:shimmer/shimmer.dart';

import '../custom_widgets/custom_body.dart';
import '../custom_widgets/page_loader.dart';

class BookingPage extends GetView<BookingController> {
  const BookingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        controller.onUserInteraction();
      },
      child: CustomScaffold(
        bodyColor: AppColor.bodyColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.chevron_left,
              color: Colors.black,
            ),
          ),
          title: const CustomTitle(
            text: "Book Parking",
            fontSize: 18,
          ),
          centerTitle: true,
        ),
        children: GetBuilder<BookingController>(builder: (ctxt) {
          return Obx(() => controller.isLoadingPage.value
              ? const Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(),
                  ),
                )
              : !controller.isInternetConn.value
                  ? NoInternetConnected(
                      onTap: controller.getAvailabeAreaVh,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: StretchingOverscrollIndicator(
                          axisDirection: AxisDirection.down,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CustomTitle(text: "You are parking at"),
                                Container(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Container(
                                          height: 71,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff1F313F),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(7),
                                              bottomLeft: Radius.circular(7),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                            border: Border.all(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: CustomTitle(
                                                    text: controller.parameters[
                                                            "areaData"]
                                                        ["park_area_name"],
                                                    maxlines: 1,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: CustomParagraph(
                                                    text: controller.parameters[
                                                        "areaData"]["address"],
                                                    fontSize: 12,
                                                    color: Colors.white70,
                                                    maxlines: 2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        height: 71,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff243a4b),
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(7),
                                            bottomRight: Radius.circular(7),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              spreadRadius: 1,
                                              blurRadius: 4,
                                              offset: const Offset(2, 2),
                                            ),
                                          ],
                                          border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            width: 1,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 10,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CustomTitle(
                                                text: Variables.formatDistance(
                                                        controller.parameters[
                                                                "areaData"]
                                                            ["distance"])
                                                    .toString(),
                                                color: Colors.white,
                                                fontSize: 14,
                                                letterSpacing: -0.41,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Container(height: 20),
                                const CustomTitle(
                                    text: "How long do you want to park?"),
                                Container(height: 10),
                                InkWell(
                                  onTap: () async {
                                    Get.bottomSheet(
                                        BookingDuration(
                                          numbersList: controller.numbersList,
                                          maxHours: controller
                                              .parameters["areaData"]
                                                  ["res_max_hours"]
                                              .toString(),
                                          onTap: (dataHours) async {
                                            controller.inputTimeLabel.value =
                                                "$dataHours ${dataHours > 1 ? "Hours" : "Hour"}";
                                            controller.numberOfhours =
                                                dataHours;

                                            controller.isHideBottom.value =
                                                false;
                                            controller.timeComputation();
                                            if (controller
                                                .selectedVh.isNotEmpty) {
                                              controller.routeToComputation();
                                            }
                                          },
                                        ),
                                        isScrollControlled: true);
                                  },
                                  child: Container(
                                    height: 71,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: const Color(0xFFFFFFFF),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Colors.black.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: controller.inputTimeLabel.value ==
                                              'Input a Duration'
                                          ? Center(
                                              child: RichText(
                                                text: TextSpan(
                                                  children: <InlineSpan>[
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: CustomParagraph(
                                                        text:
                                                            "${controller.inputTimeLabel.value} ",
                                                        color: AppColor
                                                            .primaryColor,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        letterSpacing: -0.41,
                                                      ),
                                                    ),
                                                    const WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 3),
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .chevronDown,
                                                          color:
                                                              Color(0xFF0078FF),
                                                          size: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CustomTitle(
                                                        text: controller
                                                            .inputTimeLabel
                                                            .value,
                                                        fontSize: 16,
                                                      ),
                                                      CustomParagraph(
                                                        text:
                                                            "Start Booking: ${controller.startTime.text} - ${controller.endTime.text}",
                                                        fontSize: 14,
                                                        letterSpacing: -0.41,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const FaIcon(
                                                  FontAwesomeIcons.chevronDown,
                                                  color: Color(0xFF0078FF),
                                                  size: 15,
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                                Container(height: 20),
                                if (controller.inputTimeLabel.value !=
                                    'Input a Duration')
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CustomTitle(
                                          text: "Vehicle Details"),
                                      Container(height: 10),
                                      Container(
                                        height: 71,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                          border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            width: 1,
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              controller.getMyVehicle();
                                              Get.bottomSheet(
                                                isScrollControlled: true,
                                                VehicleOption(
                                                  callback: (data) {
                                                    controller.selectedVh
                                                        .value = data;
                                                    controller
                                                        .routeToComputation();
                                                  },
                                                ),
                                              );
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                  ),
                                                  child: controller
                                                          .selectedVh.isEmpty
                                                      ? CustomParagraph(
                                                          text:
                                                              "Tap to add vehicle",
                                                          color: controller
                                                                  .selectedVh
                                                                  .isEmpty
                                                              ? AppColor
                                                                  .primaryColor
                                                              : Colors.grey,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: -0.41,
                                                        )
                                                      : Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CustomTitle(
                                                              text: controller
                                                                      .selectedVh[0]
                                                                  [
                                                                  "vehicle_plate_no"],
                                                              fontSize: 16,
                                                            ),
                                                            CustomParagraph(
                                                              text: controller
                                                                      .selectedVh[0]
                                                                  [
                                                                  "vehicle_brand_name"],
                                                              letterSpacing:
                                                                  -0.41,
                                                            ),
                                                          ],
                                                        ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15),
                                                child: controller
                                                        .selectedVh.isNotEmpty
                                                    ? Icon(
                                                        Icons
                                                            .check_circle_outline_outlined,
                                                        color: AppColor
                                                            .primaryColor,
                                                        size: 20,
                                                        weight: 5,
                                                      )
                                                    : Icon(
                                                        Icons.add,
                                                        color: AppColor
                                                            .primaryColor,
                                                        size: 20,
                                                      ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                //payment details
                                if (controller.selectedVh.isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(height: 20),
                                      const CustomTitle(
                                          text: "Payment Details"),
                                      Container(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(7),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    spreadRadius: 1,
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                                border: Border.all(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const CustomParagraph(
                                                    text: "Wallet Balance",
                                                    fontSize: 14,
                                                    letterSpacing: -0.41,
                                                  ),
                                                  Container(height: 5),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: CustomTitle(
                                                      text: toCurrencyString(
                                                              controller
                                                                  .parameters[
                                                                      "userData"]
                                                                      [0][
                                                                      "amount_bal"]
                                                                  .toString())
                                                          .toString(),
                                                      fontSize: 16,
                                                      maxlines: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(7),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    spreadRadius: 1,
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                                border: Border.all(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const CustomParagraph(
                                                    text: "Rewards",
                                                    fontSize: 14,
                                                    letterSpacing: -0.41,
                                                  ),
                                                  Container(height: 5),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: CustomTitle(
                                                      text: toCurrencyString(
                                                              controller
                                                                  .parameters[
                                                                      "userData"]
                                                                      [0][
                                                                      "points_bal"]
                                                                  .toString())
                                                          .toString(),
                                                      fontSize: 16,
                                                      maxlines: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          controller.toggleRewardChecked(
                                              !controller
                                                  .isRewardchecked.value);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 1,
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                            border: Border.all(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20.0,
                                              right: 20,
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      controller.isRewardchecked
                                                              .value
                                                          ? Icons
                                                              .check_circle_outline
                                                          : Icons
                                                              .circle_outlined,
                                                      color: controller
                                                              .isRewardchecked
                                                              .value
                                                          ? AppColor
                                                              .primaryColor
                                                          : Colors.grey,
                                                    ),
                                                    Container(width: 5),
                                                    const Expanded(
                                                      child: CustomTitle(
                                                        text:
                                                            "Use Reward Points",
                                                        fontSize: 14,
                                                        letterSpacing: -0.41,
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ),
                                                    Container(width: 5),
                                                    if (controller
                                                        .isRewardchecked.value)
                                                      GestureDetector(
                                                        onTap: controller
                                                            .showRewardDialog,
                                                        child: Icon(
                                                          Icons.edit_note,
                                                          color: AppColor
                                                              .primaryColor,
                                                        ),
                                                      )
                                                  ],
                                                ),
                                                if (controller
                                                    .isRewardchecked.value)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Column(
                                                      children: [
                                                        const Divider(
                                                          color: Colors.grey,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const CustomParagraph(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                text:
                                                                    ' Reward Points :',
                                                                letterSpacing:
                                                                    -0.41),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          20),
                                                              child:
                                                                  CustomParagraph(
                                                                text: () {
                                                                  try {
                                                                    double
                                                                        points =
                                                                        double.parse(controller
                                                                            .rewardsCon
                                                                            .text);
                                                                    return points
                                                                        .toStringAsFixed(
                                                                            2); // Formats the number to 2 decimal places
                                                                  } catch (e) {
                                                                    return '0.00'; // Handle parsing error
                                                                  }
                                                                }(),
                                                                color: AppColor
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(height: 5),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const CustomParagraph(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              text: ' Token :',
                                                              letterSpacing:
                                                                  -0.41,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          20),
                                                              child:
                                                                  CustomParagraph(
                                                                // text: subtractedToken
                                                                //             .toStringAsFixed(
                                                                //                 2) ==
                                                                //         "0.00"
                                                                //     ? toCurrencyString(
                                                                //         totalAmount)
                                                                //     : subtractedToken
                                                                //         .toStringAsFixed(
                                                                //             2),
                                                                text:
                                                                    "Subtracted token",
                                                                color: AppColor
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(height: 10),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const CustomParagraph(
                                                                text: ' total ',
                                                                letterSpacing:
                                                                    -0.41),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          20),
                                                              child:
                                                                  CustomParagraph(
                                                                // text: toCurrencyString(
                                                                //     totalAmount),

                                                                text:
                                                                    "Total amount",
                                                                color: AppColor
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          controller.toggleExtendChecked(
                                              !controller
                                                  .isExtendchecked.value);
                                        },
                                        child: Container(
                                          height: 51,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 1,
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                            border: Border.all(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20.0,
                                              right: 20,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Icon(
                                                  controller.isExtendchecked.value
                                                      ? Icons
                                                          .check_circle_outline
                                                      : Icons.circle_outlined,
                                                  color: controller
                                                          .isExtendchecked.value
                                                      ? AppColor.primaryColor
                                                      : Colors.grey,
                                                ),
                                                Container(width: 5),
                                                const Expanded(
                                                  child: CustomTitle(
                                                    text: "Auto extend",
                                                    fontSize: 14,
                                                    letterSpacing: -0.41,
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                      ),
                                    ],
                                  )
                              ],
                            ),
                          ),
                        )),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                top: BorderSide(color: Colors.grey.shade100)),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(7),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 20.0, right: 20.0, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: CustomTitle(
                                        text: "Total",
                                      ),
                                    ),
                                    CustomTitle(
                                      text: toCurrencyString(
                                          controller.totalAmount.value),
                                    ),
                                  ],
                                ),
                                Container(height: 20),
                                if (controller.isBtnLoading.value)
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: const Color(0xFFe6faff),
                                    child: CustomButton(
                                      text: " ",
                                      onPressed: () {},
                                    ),
                                  )
                                else
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                            loading: controller
                                                .isSubmitBooking.value,
                                            text: controller
                                                    .parameters["canCheckIn"]
                                                ? "Check In"
                                                : "Book now",
                                            btnColor:
                                                controller.selectedVh.isEmpty
                                                    ? AppColor.primaryColor
                                                        .withOpacity(.6)
                                                    : AppColor.primaryColor,
                                            textColor: Colors.white,
                                            onPressed: controller
                                                    .selectedVh.isEmpty
                                                ? () {}
                                                : () {
                                                    var dateIn = DateTime.parse(
                                                        "${controller.startDate.text} ${controller.timeInParam.text}");

                                                    var dateOut = dateIn.add(
                                                        Duration(
                                                            hours: controller
                                                                .numberOfhours));

                                                    void bongGo() {
                                                      Map<String, dynamic>
                                                          parameters = {
                                                        "client_id": controller
                                                                    .parameters[
                                                                "areaData"]
                                                            ["client_id"],
                                                        "park_area_id": controller
                                                                    .parameters[
                                                                "areaData"]
                                                            ["park_area_id"],
                                                        "vehicle_plate_no": controller
                                                                .selectedVh[0][
                                                            "vehicle_plate_no"],
                                                        "vehicle_type_id":
                                                            controller
                                                                .selectedVh[0][
                                                                    "vehicle_type_id"]
                                                                .toString(),
                                                        "dt_in": dateIn
                                                            .toString()
                                                            .toString()
                                                            .split(".")[0],
                                                        "dt_out": dateOut
                                                            .toString()
                                                            .split(".")[0],
                                                        "no_hours": controller
                                                            .numberOfhours,
                                                        "tran_type": "R",
                                                      };

                                                      controller
                                                          .submitReservation(
                                                              parameters);
                                                    }

                                                    if (controller
                                                        .isExtendchecked
                                                        .value) {
                                                      bongGo();
                                                    } else {
                                                      CustomDialog()
                                                          .confirmationDialog(
                                                              context,
                                                              "Enable Auto Extend",
                                                              "Your parking duration will be automatically extended using your available balance if it is enabled.\nWould you like to enable it?",
                                                              "No",
                                                              "Yes", () {
                                                        Get.back();
                                                        controller
                                                            .isExtendchecked
                                                            .value = false;
                                                        bongGo();
                                                      }, () {
                                                        Get.back();
                                                        controller
                                                            .isExtendchecked
                                                            .value = true;
                                                        bongGo();
                                                      });
                                                    }
                                                  }),
                                      ),
                                    ],
                                  )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ));
        }),
      ),
    );
  }
}

class BookingDuration extends GetView<BookingController> {
  final List numbersList;
  final String maxHours;
  final Function(int) onTap;
  const BookingDuration(
      {super.key,
      required this.numbersList,
      required this.maxHours,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    BookingController ct = Get.put(BookingController());
    return Obx(() => Container(
          height: numbersList.length >= 5
              ? MediaQuery.of(context).size.height * .60
              : null,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7),
              topRight: Radius.circular(7),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Iconsax.clock),
                        title: const CustomTitle(text: "Booking Duration"),
                        subtitle: CustomParagraph(
                          text: Variables.timeNow(),
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Iconsax.close_circle,
                              color: Colors.grey,
                            )),
                      ),
                      CustomTextField(
                        label: "Input number of hours",
                        controller: controller.noHours,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$')),
                        ],
                        keyboardType: Platform.isAndroid
                            ? TextInputType.number
                            : const TextInputType.numberWithOptions(
                                signed: true, decimal: false),
                        onChanged: (value) {
                          controller.noHours.text =
                              value.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
                          controller.inpDisplay.text =
                              value.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

                          if (value.isNotEmpty &&
                              int.parse(value) >
                                  int.parse(controller.parameters["areaData"]
                                          ["res_max_hours"]
                                      .toString()) &&
                              int.parse(controller.parameters["areaData"]
                                          ["res_max_hours"]
                                      .toString()) !=
                                  0) {
                            CustomDialog().errorDialog(context, "luvpark",
                                "Booking limit is up to ${controller.parameters["areaData"]["res_max_hours"].toString()} hours only.",
                                () {
                              Get.back();
                              controller.noHours.text = controller.noHours.text
                                  .substring(
                                      0, controller.noHours.text.length - 1);

                              controller.inpDisplay.text =
                                  controller.noHours.text.substring(
                                      0, controller.noHours.text.length - 1);
                              controller.inpDisplay.text =
                                  controller.noHours.text.substring(
                                      0, controller.noHours.text.length - 1);

                              controller.noHours.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: controller.noHours.text.length));

                              controller.selectedNumber.value =
                                  int.parse(controller.noHours.text);
                            });
                          }

                          controller.selectedNumber.value =
                              (controller.noHours.text.isEmpty
                                  ? null
                                  : int.parse(controller.noHours.text))!;
                        },
                      ),
                    ],
                  )),
              Container(height: 10),
              if (MediaQuery.of(context).viewInsets.bottom == 0)
                Column(
                  children: [
                    if (numbersList.isNotEmpty)
                      if (numbersList.length >= 5)
                        Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                return Container();
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  height: 2,
                                );
                              },
                              itemCount: numbersList.length),
                        ),
                    if (numbersList.isNotEmpty)
                      if (numbersList.length < 5)
                        for (int i = 0; i < numbersList.length; i++)
                          numberHoursWidget(numbersList, i, ct),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: CustomButton(
                          text: "Confirm",
                          onPressed: () {
                            controller.inputTimeLabel.value =
                                "${controller.selectedNumber.value} ${controller.selectedNumber.value > 1 ? "Hours" : "Hour"}";
                            onTap(controller.selectedNumber.value);
                            Get.back();
                          }),
                    ),
                  ],
                ),
              Builder(
                builder: (context) {
                  if (MediaQuery.of(context).viewInsets.bottom != 0) {
                    return Container(
                        height: MediaQuery.of(context).viewInsets.bottom * .20);
                  } else {
                    return Container(
                      height: 30,
                    );
                  }
                },
              ),
            ],
          ),
        ));
  }

  Widget numberHoursWidget(data, i, ct) {
    return Obx(
      () => Container(
        color: controller.selectedNumber.value == data[i]
            ? const Color(0xFFe8f3fe)
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListTile(
            onTap: () {
              controller.onTapChanged(i);
            },
            contentPadding: EdgeInsets.zero,
            title: CustomParagraph(
              text: '${data[i]} ${data[i] > 1 ? "hours" : "hour"}',
              color: controller.selectedNumber.value == numbersList[i]
                  ? AppColor.primaryColor
                  : Colors.black,
            ),
            trailing: controller.selectedNumber.value == data[i]
                ? Icon(Icons.check, color: AppColor.primaryColor)
                : null,
          ),
        ),
      ),
    );
  }
}

class VehicleOption extends GetView<BookingController> {
  final Function callback;
  const VehicleOption({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    final BookingController ct = Get.find();

    return Wrap(
      children: [
        Obx(
          () => Container(
            height: controller.isFirstScreen.value &&
                    controller.isNetConnVehicles.value &&
                    !controller.isLoadingVehicles.value
                ? MediaQuery.of(context).viewInsets.bottom != 0
                    ? MediaQuery.of(context).viewInsets.bottom
                    : null
                : MediaQuery.of(context).size.height * .50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.white,
            ),
            child: !controller.isNetConnVehicles.value
                ? NoInternetConnected(
                    onTap: () {
                      controller.getMyVehicle();
                    },
                  )
                : controller.isLoadingVehicles.value
                    ? const PageLoader()
                    : controller.myVehiclesData.isEmpty
                        ? const NoDataFound()
                        : Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(height: 10),
                                InkWell(
                                  onTap: () {
                                    if (!controller.isFirstScreen.value) {
                                      controller.onScreenChanged(
                                          !controller.isFirstScreen.value);
                                      return;
                                    }
                                    Get.back();
                                  },
                                  child: const Icon(
                                    Icons.chevron_left,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(height: 20),
                                controller.isFirstScreen.value
                                    ? Form(
                                        key: controller.bookKey,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const CustomTitle(
                                                text:
                                                    "What's your plate number?"),
                                            Container(height: 10),
                                            CustomTextField(
                                              label: "Plate No.",
                                              controller: controller.plateNo,
                                              textCapitalization:
                                                  TextCapitalization.characters,
                                              validator: (data) {
                                                if (data == null ||
                                                    data.isEmpty) {
                                                  return "Plate no is required";
                                                }
                                                return null;
                                              },
                                            ),
                                            if (MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom ==
                                                0)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(height: 30),
                                                  const CustomTitle(
                                                      text: "Select vehicle"),
                                                  Container(height: 10),
                                                  CustomDropdown(
                                                    labelText: "Vehicle Type",
                                                    ddData: controller
                                                        .ddVehiclesData,
                                                    ddValue: controller
                                                        .dropdownValue,
                                                    onChange: (newValue) {
                                                      controller.dropdownValue =
                                                          newValue;
                                                    },
                                                  ),
                                                  Container(height: 30),
                                                  CustomButton(
                                                    text: "Confirm",
                                                    onPressed: () {
                                                      if (ct
                                                          .bookKey.currentState!
                                                          .validate()) {
                                                        dynamic selVh = ct
                                                            .ddVehiclesData
                                                            .where((element) {
                                                          return element[
                                                                  "value"] ==
                                                              int.parse(ct
                                                                  .dropdownValue!
                                                                  .toString());
                                                        }).toList()[0];

                                                        callback([
                                                          {
                                                            'vehicle_type_id': ct
                                                                .dropdownValue!
                                                                .toString(),
                                                            'vehicle_brand_id':
                                                                0,
                                                            'vehicle_brand_name':
                                                                selVh["text"],
                                                            'vehicle_plate_no':
                                                                controller
                                                                    .plateNo
                                                                    .text,
                                                            'base_hours': selVh[
                                                                "base_hours"],
                                                            'base_rate': selVh[
                                                                "base_rate"],
                                                            'succeeding_rate':
                                                                selVh[
                                                                    "succeeding_rate"]
                                                          }
                                                        ]);
                                                        Get.back();
                                                      }
                                                    },
                                                  ),
                                                  Container(height: 15),
                                                  CustomButtonCancel(
                                                      borderColor: Colors.black,
                                                      textColor: Colors.black,
                                                      color: AppColor.bodyColor,
                                                      text: "My Vehicle",
                                                      onPressed: () {
                                                        controller
                                                            .onScreenChanged(!ct
                                                                .isFirstScreen
                                                                .value);
                                                      })
                                                ],
                                              ),
                                          ],
                                        ),
                                      )
                                    : Expanded(
                                        child: Scrollbar(
                                          child: ListView.separated(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            itemCount: controller
                                                .myVehiclesData.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    CustomTitle(
                                                      text: controller
                                                                  .myVehiclesData[
                                                              index]
                                                          ["vehicle_plate_no"],
                                                      fontSize: 14,
                                                    ),
                                                  ],
                                                ),
                                                subtitle: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    CustomParagraph(
                                                      text: controller
                                                                  .myVehiclesData[
                                                              index][
                                                          "vehicle_brand_name"],
                                                      fontSize: 12,
                                                    ),
                                                  ],
                                                ),
                                                leading: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Icon(
                                                    int.parse(controller
                                                                .myVehiclesData[
                                                                    index][
                                                                    "vehicle_type_id"]
                                                                .toString()) ==
                                                            1
                                                        ? Icons
                                                            .motorcycle_outlined
                                                        : Icons.time_to_leave,
                                                  ),
                                                ),
                                                trailing: const Icon(
                                                    Icons.keyboard_arrow_right),
                                                onTap: () {
                                                  List vhDatas = [
                                                    controller
                                                        .myVehiclesData[index]
                                                  ];
                                                  dynamic recData =
                                                      controller.ddVehiclesData;

                                                  Map<int, Map<String, dynamic>>
                                                      recDataMap = {
                                                    for (var item in recData)
                                                      item['value']: item
                                                  };

                                                  // Merge base_hours and succeeding_rate into vhDatas
                                                  for (var vh in vhDatas) {
                                                    int typeId =
                                                        vh['vehicle_type_id'];
                                                    if (recDataMap
                                                        .containsKey(typeId)) {
                                                      var rec =
                                                          recDataMap[typeId];
                                                      vh['base_hours'] =
                                                          rec?['base_hours'];
                                                      vh['base_rate'] =
                                                          rec?['base_rate'];
                                                      vh['succeeding_rate'] =
                                                          rec?[
                                                              'succeeding_rate'];
                                                    }
                                                  }

                                                  Get.back();
                                                  callback(vhDatas);
                                                },
                                              );
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return Divider(
                                                color: Colors.black.withOpacity(
                                                    0.05000000074505806),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
          ),
        )
      ],
    );
  }
}
