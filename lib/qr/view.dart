// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvpark_get/custom_widgets/custom_body.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/no_internet.dart';
import 'package:luvpark_get/custom_widgets/page_loader.dart';
import 'package:luvpark_get/qr/controller.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../custom_widgets/app_color.dart';

class QrWallet extends GetView<QrWalletController> {
  const QrWallet({super.key});

  @override
  Widget build(BuildContext context) {
  
    return CustomScaffold(
      bodyColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.black,
              size: 15,
            )),
        elevation: 0,
    
        backgroundColor: Colors.white,
        bottom: TabBar(
          labelStyle: paragraphStyle(),
          unselectedLabelStyle: paragraphStyle(),
          controller: controller.tabController,
          onTap: (index) {
            controller.onTabChanged(index);
          },
          tabs: const [
            Tab(
              text: "Qr Pay",
            ),
            Tab(
              text: "Receive",
            ),
          ],
        ),
      ),
      children: TabBarView(
        controller: controller.tabController,
        children: const [PayQr(), ReceiveQr()],
      ),
    );
  }
}

class PayQr extends GetView<QrWalletController> {
  const PayQr({super.key}); 
  @override
  Widget build(BuildContext context) { 
    return Obx(
      () => !controller.isInternetConn.value
          ? NoInternetConnected(onTap: controller.getQrData)
          : controller.isLoading.value
              ? PageLoader()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 52.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .58,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            controller.isLoading.value
                                ? Center(
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: const Color(0xFFe6faff),
                                      child: Container(),
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(28),
                                            border: Border.all(
                                                width: 2,
                                                color: const Color.fromRGBO(
                                                    37, 99, 235, 0.09))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: QrImageView(
                                            data: controller.payKey.value,
                                            version: QrVersions.auto,
                                            gapless: false,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 27,
                                      ),
                                      Center(
                                        child: CustomTitle(
                                          text: controller.isLoading.value
                                              ? ""
                                              : 'Scan QR code to pay',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF787878),
                                        ),
                                      ),
                                      Container(
                                        height: 37,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 10,
                                          ),
                                          Container(
                                            height: 48,
                                            width: 48,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColor.primaryColor),
                                            child: Center(
                                              child: CustomTitle(
                                                text: controller
                                                    .firstlastCapital.value,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                fontSize: 16,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(
                                                  controller.fullName.value
                                                      .toUpperCase(),
                                                  minFontSize: 12,
                                                  maxFontSize: 16,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF353636),
                                                    letterSpacing: -0.32,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                CustomTitle(
                                                  text: controller.mono.value,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF9A9A9A),
                                                  letterSpacing: -0.32,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 33,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.generateQr();
                                        },
                                        child: Center(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .60,
                                            padding: const EdgeInsets.fromLTRB(
                                                12,
                                                12,
                                                12,
                                                12), // Padding values
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: const Color.fromRGBO(
                                                    0,
                                                    0,
                                                    0,
                                                    0.08), // Color with rgba values
                                                width: 1.0, // 1-pixel width
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.sync_outlined,
                                                  size: 28.0,
                                                ),
                                                SizedBox(width: 5),
                                                CustomTitle(
                                                  text: 'Generate QR code',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 16,
                                      ),
                                      IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  controller.shareQr();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .ios_share_outlined,
                                                        color: Colors.black,
                                                        size: 25,
                                                      ),
                                                      Text(
                                                        "Share",
                                                        style: Platform
                                                                .isAndroid
                                                            ? GoogleFonts.dmSans(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                letterSpacing:
                                                                    1,
                                                                fontSize: 14)
                                                            : TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                letterSpacing:
                                                                    1,
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    "SFProTextReg",
                                                              ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              color: const Color.fromRGBO(
                                                  30, 33, 41, 0.08),
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  controller.saveQr();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                        Icons.download_outlined,
                                                        color: Colors.black,
                                                        size: 25,
                                                      ),
                                                      Text(
                                                        "Save",
                                                        style: Platform
                                                                .isAndroid
                                                            ? GoogleFonts.dmSans(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                letterSpacing:
                                                                    1,
                                                                fontSize: 14)
                                                            : TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                letterSpacing:
                                                                    1,
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    "SFProTextReg",
                                                              ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );

  }
}

class ReceiveQr extends GetView<QrWalletController> {
  const ReceiveQr({super.key}); 
  @override
  Widget build(BuildContext context) { 
    return Obx(
      () => !controller.isInternetConn.value
          ? NoInternetConnected(onTap: controller.getQrData)
          : controller.isLoading.value
              ? PageLoader()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 52.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .58,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            controller.isLoading.value
                                ? Center(
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: const Color(0xFFe6faff),
                                      child: Container(),
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(28),
                                            border: Border.all(
                                                width: 2,
                                                color: const Color.fromRGBO(
                                                    37, 99, 235, 0.09))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: QrImageView(
                                            data: controller.payKey.value,
                                            version: QrVersions.auto,
                                            gapless: false,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 27,
                                      ),
                                      Center(
                                        child: CustomTitle(
                                          text: controller.isLoading.value
                                              ? ""
                                              : 'Scan QR code to receive',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF787878),
                                        ),
                                      ),
                                      Container(
                                        height: 37,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 10,
                                          ),
                                          Container(
                                            height: 48,
                                            width: 48,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColor.primaryColor),
                                            child: Center(
                                              child: CustomTitle(
                                                text: controller
                                                    .firstlastCapital.value,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                fontSize: 16,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(
                                                  controller.fullName.value
                                                      .toUpperCase(),
                                                  minFontSize: 12,
                                                  maxFontSize: 16,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF353636),
                                                    letterSpacing: -0.32,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                CustomTitle(
                                                  text: controller.mono.value,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF9A9A9A),
                                                  letterSpacing: -0.32,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Container(
                                      //   height: 33,
                                      // ),
                                      // InkWell(
                                      //   onTap: () {
                                      //     controller.generateQr();
                                      //   },
                                      //   child: Center(
                                      //     child: Container(
                                      //       width: MediaQuery.of(context)
                                      //               .size
                                      //               .width *
                                      //           .60,
                                      //       padding: const EdgeInsets.fromLTRB(
                                      //           12, 12, 12, 12), // Padding values
                                      //       decoration: BoxDecoration(
                                      //         color: Colors.white,
                                      //         border: Border.all(
                                      //           color: const Color.fromRGBO(
                                      //               0,
                                      //               0,
                                      //               0,
                                      //               0.08), // Color with rgba values
                                      //           width: 1.0, // 1-pixel width
                                      //         ),
                                      //         borderRadius:
                                      //             BorderRadius.circular(7),
                                      //       ),
                                      //       child: Row(
                                      //         mainAxisAlignment:
                                      //             MainAxisAlignment.center,
                                      //         children: const [
                                      //           Icon(
                                      //             Icons.sync_outlined,
                                      //             size: 28.0,
                                      //           ),
                                      //           SizedBox(width: 5),
                                      //           CustomTitle(
                                      //             text: 'Generate QR code',
                                      //             color: Colors.black,
                                      //             fontWeight: FontWeight.w600,
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      Container(
                                        height: 16,
                                      ),
                                      IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  controller.shareQr();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .ios_share_outlined,
                                                        color: Colors.black,
                                                        size: 25,
                                                      ),
                                                      Text(
                                                        "Share",
                                                        style: Platform
                                                                .isAndroid
                                                            ? GoogleFonts.dmSans(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                letterSpacing:
                                                                    1,
                                                                fontSize: 14)
                                                            : TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                letterSpacing:
                                                                    1,
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    "SFProTextReg",
                                                              ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              color: const Color.fromRGBO(
                                                  30, 33, 41, 0.08),
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  controller.saveQr();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                        Icons.download_outlined,
                                                        color: Colors.black,
                                                        size: 25,
                                                      ),
                                                      Text(
                                                        "Save",
                                                        style: Platform
                                                                .isAndroid
                                                            ? GoogleFonts.dmSans(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                letterSpacing:
                                                                    1,
                                                                fontSize: 14)
                                                            : TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                letterSpacing:
                                                                    1,
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    "SFProTextReg",
                                                              ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [Text("QR PAY"),],
    // );
  }
}


