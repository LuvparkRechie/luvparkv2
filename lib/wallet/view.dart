// ignore_for_file: prefer_const_constructorss, prefer_const_constructors
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_appbar.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/no_internet.dart';
import 'package:luvpark_get/custom_widgets/park_shimmer.dart';
import 'package:luvpark_get/routes/routes.dart';
import 'package:luvpark_get/wallet/controller.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../auth/authentication.dart';
import '../custom_widgets/alert_dialog.dart';
import 'utils/transaction_details.dart';

class WalletScreen extends GetView<WalletController> {
  const WalletScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // final WalletController ct = Get.put(WalletController());
    PanelController panelController = PanelController();
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: CustomAppbar(
          title: "My Wallet",
          action: [
            Container(
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                backgroundImage: controller.userImage != null &&
                        controller.userImage['image_base64'] != null
                    ? MemoryImage(
                        base64Decode(controller.userImage['image_base64']),
                      )
                    : null,
                child: controller.userImage == null
                    ? const Icon(Icons.person,
                        size: 24, color: Colors.blueAccent)
                    : null,
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Obx(
            () => !controller.isNetConn.value
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: NoInternetConnected(
                      onTap: controller.getLogs,
                    ),
                  )
                : controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: controller.onRefresh,
                        child: StretchingOverscrollIndicator(
                          axisDirection: AxisDirection.down,
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 15, 15, 0),
                                      child: ListView(
                                        children: [
                                          SizedBox(
                                            height: 200,
                                            child: Stack(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/images/wallet_bg.svg",
                                                  height: 200,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                ),
                                                Positioned(
                                                  child: SizedBox(
                                                    height: 187,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                              15,
                                                              25,
                                                              15,
                                                              15,
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Image(
                                                                      image:
                                                                          AssetImage(
                                                                        "assets/images/wallet_luvpark1.png",
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    CustomTitle(
                                                                      text:
                                                                          'luvpark Balance',
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [],
                                                                    ),
                                                                    CustomTitle(
                                                                      text: NumberFormat.currency(
                                                                              symbol:
                                                                                  "")
                                                                          .format(double.parse(controller.userData[0]
                                                                              [
                                                                              "amount_bal"])),
                                                                      fontSize:
                                                                          50,
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 40,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      15),
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  // SvgPicture.asset(
                                                                  //   "assets/images/wallet_crown.svg",
                                                                  //   height: 14,
                                                                  //   width:
                                                                  //       MediaQuery.of(
                                                                  //               context)
                                                                  //           .size
                                                                  //           .width,
                                                                  // ),
                                                                  Icon(
                                                                    Iconsax
                                                                        .crown5,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            255,
                                                                            198,
                                                                            103,
                                                                            1),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),

                                                                  CustomTitle(
                                                                    text:
                                                                        "Reward Points: ",
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                  CustomTitle(
                                                                    text:
                                                                        " ${controller.userData[0]["points_bal"]} ",
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    final item =
                                                        await Authentication()
                                                            .getUserData2();
                                                    String? fname =
                                                        item["first_name"];
                                                    // print("fnameee $fname");
                                                    if (fname == null) {
                                                      CustomDialog().errorDialog(
                                                          // ignore: use_build_context_synchronously
                                                          context,
                                                          "Attention",
                                                          "Complete your account information to access the requested service.\nGo to profile and update your account.", () {
                                                        Get.back();
                                                      });
                                                      return;
                                                    }
                                                    Get.toNamed(
                                                        Routes.walletrecharge);
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(15),
                                                        width: 60,
                                                        height: 60,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              Color(0xFFE0EEFF),
                                                        ),
                                                        child: SvgPicture.asset(
                                                          "assets/images/wallet_icons_load.svg",
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      AutoSizeText(
                                                          maxFontSize: 16,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xFF0078FF),
                                                            letterSpacing:
                                                                -0.32,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                          "Load")
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    Get.toNamed(
                                                        Routes.walletsend,
                                                        arguments: () {
                                                      controller.getLogs();
                                                      controller
                                                          .getUserBalance();
                                                    });
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(15),
                                                        width: 60,
                                                        height: 60,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              Color(0xFFE0EEFF),
                                                        ),
                                                        child: SvgPicture.asset(
                                                          "assets/images/wallet_icons_send.svg",
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      AutoSizeText(
                                                          maxFontSize: 16,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xFF0078FF),
                                                            letterSpacing:
                                                                -0.32,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                          "Send")
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Get.toNamed(
                                                        Routes.qrwallet);
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(15),
                                                        width: 60,
                                                        height: 60,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              Color(0xFFE0EEFF),
                                                        ),
                                                        child: SvgPicture.asset(
                                                          "assets/images/wallet_icons_qr.svg",
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      AutoSizeText(
                                                          maxFontSize: 16,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xFF0078FF),
                                                            letterSpacing:
                                                                -0.32,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                          "QR Code")
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  // height: 50,
                                                  width: 50,
                                                ),
                                              ]),
                                          Container(height: 10),
                                          Divider(),
                                          Row(
                                            children: [],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SlidingUpPanel(
                                  snapPoint: 0.4,
                                  parallaxEnabled: true,
                                  maxHeight: size.height * 0.90,
                                  minHeight: size.height * 0.45,
                                  controller: panelController,
                                  panelBuilder: (context) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      height: 350,
                                      child: GetBuilder<WalletController>(
                                        init: WalletController(),
                                        builder: (controller) {
                                          return Column(children: [
                                            Container(height: 10),
                                            Center(
                                              child: Container(
                                                width: 71,
                                                height: 6,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(56),
                                                  color:
                                                      const Color(0xffd9d9d9),
                                                ),
                                              ),
                                            ),
                                            Container(height: 10),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 0, 15, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomTitle(
                                                    text: "Recent Activities",
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  SvgPicture.asset(
                                                    "assets/images/wallet_filter.svg",
                                                    height: 19,
                                                    color: Color(0xFF0078FF),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(height: 10),
                                            Expanded(
                                              child: controller.isLoading.value
                                                  ? const ParkShimmer()
                                                  : ListView.separated(
                                                      // controller: scrollController,
                                                      itemCount: controller
                                                          .logs.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            showModalBottomSheet(
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              context: context,
                                                              builder: (context) =>
                                                                  TransactionDetails(
                                                                index: index,
                                                                data: controller
                                                                    .logs,
                                                              ),
                                                            );
                                                          },
                                                          child: ListTile(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          0,
                                                                          15,
                                                                          0),
                                                              leading:
                                                                  SvgPicture
                                                                      .asset(
                                                                fit: BoxFit
                                                                    .cover,
                                                                "assets/images/${controller.logs[index]["tran_desc"] == 'Share a token' ? 'wallet_sharetoken' : controller.logs[index]["tran_desc"] == 'Received token' ? 'wallet_receivetoken' : 'wallet_payparking'}.svg",
                                                                //if trans_Desc is equal to Share a token svg is wallet_sharetoken else Receive Token svg is wallet_receivetoken else parking transaction is svg wallet_payparking
                                                                height: 50,
                                                              ),
                                                              title:
                                                                  CustomTitle(
                                                                text: controller
                                                                            .logs[
                                                                        index][
                                                                    "tran_desc"],
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              subtitle:
                                                                  CustomParagraph(
                                                                text: DateFormat(
                                                                        'MMM d, yyyy h:mm a')
                                                                    .format(DateTime.parse(
                                                                        controller.logs[index]
                                                                            [
                                                                            "tran_date"])),
                                                                fontSize: 12,
                                                              ),
                                                              trailing:
                                                                  CustomTitle(
                                                                text: controller
                                                                            .logs[
                                                                        index]
                                                                    ["amount"],
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: (controller.logs[index]["tran_desc"] ==
                                                                            'Share a token' ||
                                                                        controller.logs[index]["tran_desc"] ==
                                                                            'Received token')
                                                                    ? Color(
                                                                        0xFF0078FF)
                                                                    : Color(
                                                                        0xFFBD2424),
                                                              )),
                                                        );
                                                      },
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              const Divider(
                                                        endIndent: 1,
                                                        height: 1,
                                                      ),
                                                    ),
                                            )
                                          ]);
                                        },
                                      ),
                                    );
                                  }),

                              //BottomSHeeeet
                            ],
                          ),
                        ),
                      ),
          ),
        ));
  }
}

class LoadingTransaction extends StatelessWidget {
  const LoadingTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 20,
        padding: const EdgeInsets.only(top: 15, bottom: 5, left: 15, right: 15),
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey.shade100, width: 1.5),
                borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 13,
                    width: 200,
                    color: Colors.grey[100],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 13,
                    width: 200,
                    color: Colors.grey[100],
                  ),
                ],
              ),
              trailing: Container(
                width: 50,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade100),
              ),
            ),
          );
        },
      ),
    );
  }
}
