// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvpark_get/custom_widgets/custom_appbar.dart';
import 'package:luvpark_get/custom_widgets/custom_body.dart';
import 'package:luvpark_get/custom_widgets/custom_tciket_style.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/no_internet.dart';
import 'package:luvpark_get/custom_widgets/page_loader.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../custom_widgets/app_color.dart';
import 'controller.dart';

class QrWallet extends GetView<QrWalletController> {
  const QrWallet({super.key});
// CustomAppbar(
//             title: controller.tabController.index==0?"Payment":"Receive",
//             bgColor: AppColor.primaryColor,
//             titleColor: Colors.white,
//           ),
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: AppColor.primaryColor,
          body: Column(
            children: [
              CustomAppbar(
                title:
                    controller.currentPage.value == 0 ? "Payment" : "Receive",
                bgColor: AppColor.primaryColor,
                titleColor: Colors.white,
              ),
              Container(
                color: AppColor.primaryColor,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D62C3),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: const Color(0xFF0D62C3),
                      ),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (controller.isLoading.value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Loading on progress, Please wait...'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.blue,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }
                            controller.onTabChanged(0);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: controller.currentPage.value != 0
                                ? decor2()
                                : decor1(),
                            child: Center(
                              child: CustomParagraph(
                                text: "QR Pay",
                                fontSize: 10,
                                color: controller.currentPage.value != 0
                                    ? Colors.white38
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(width: 5),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (controller.isLoading.value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Loading on progress, Please wait...'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.blue,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }
                            controller.onTabChanged(1);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: controller.currentPage.value != 1
                                ? decor2()
                                : decor1(),
                            child: Center(
                                child: CustomParagraph(
                              text: "Receive",
                              fontSize: 10,
                              color: controller.currentPage.value != 1
                                  ? Colors.white38
                                  : Colors.white,
                            )),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
              Expanded(
                child:
                    controller.currentPage.value == 0 ? PayQr() : ReceiveQr(),
              )
            ],
          ),
        ));
  }

//selected tab
  BoxDecoration decor1() {
    return BoxDecoration(
      color: Colors.white30,
      borderRadius: BorderRadius.circular(7),
      border: Border.all(
        color: Colors.transparent,
      ),
    );
  }

//unselected tab
  BoxDecoration decor2() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(7),
      color: const Color(0xFF0D62C3),
      border: Border.all(
        color: const Color(0xFF0D62C3),
      ),
    );
  }
}

class PayQr extends GetView<QrWalletController> {
  const PayQr({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() => !controller.isInternetConn.value
        ? NoInternetConnected(onTap: controller.getQrData)
        : controller.isLoading.value
            ? PageLoader()
            : Column(
                children: [Text("Pay QR")],
              ));
  }
}

class ReceiveQr extends GetView<QrWalletController> {
  const ReceiveQr({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 17, 0, 0),
              child: Column(
                children: [
                  Center(
                    child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.black,
                        child: buildProfileImage()),
                  ),
                  CustomTitle(
                    text: controller.fullName.value.toUpperCase(),
                    maxlines: 1,
                    fontSize: 18,
                    color: Color(0xFF070707),
                    textAlign: TextAlign.center,
                  ),
                  CustomTitle(
                    text: controller.mono.value,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF616161),
                    letterSpacing: -0.32,
                  ),
                ],
              ),
            ),
            TicketStyle(
              dtColor: AppColor.primaryColor,
            ),

            //   child: SizedBox(
            //     width: MediaQuery.of(context).size.width * .58,
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Container(
            //               decoration: BoxDecoration(
            //                   color: Colors.white,
            //                   borderRadius: BorderRadius.circular(28),
            //                   border: Border.all(
            //                       width: 2,
            //                       color: const Color.fromRGBO(37, 99, 235, 0.09))),
            //               child: Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: QrImageView(
            //                   data: controller.mobNum.value,
            //                   version: QrVersions.auto,
            //                   gapless: false,
            //                 ),
            //               ),
            //             ),
            //             Container(
            //               height: 27,
            //             ),
            //             Center(
            //               child: CustomTitle(
            //                 text: 'Scan QR code to receive',
            //                 fontSize: 14,
            //                 fontWeight: FontWeight.w600,
            //                 color: const Color(0xFF787878),
            //               ),
            //             ),
            //             Container(
            //               height: 37,
            //             ),
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.end,
            //               children: [
            //                 Container(
            //                   width: 10,
            //                 ),
            //                 Container(
            //                   height: 48,
            //                   width: 48,
            //                   decoration: BoxDecoration(
            //                       shape: BoxShape.circle,
            //                       color: AppColor.primaryColor),
            //                   child: Center(
            //                     child: CustomTitle(
            //                       text: controller.firstlastCapital.value,
            //                       fontWeight: FontWeight.w700,
            //                       color: Colors.white,
            //                       fontSize: 16,
            //                       textAlign: TextAlign.center,
            //                     ),
            //                   ),
            //                 ),
            //                 Container(
            //                   width: 10,
            //                 ),
            //                 Expanded(
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       AutoSizeText(
            //                         controller.fullName.value.toUpperCase(),
            //                         maxFontSize: 16,
            //                         maxLines: 1,
            //                         style: TextStyle(
            //                           fontWeight: FontWeight.w600,
            //                           color: Color(0xFF353636),
            //                           letterSpacing: -0.32,
            //                         ),
            //                         textAlign: TextAlign.center,
            //                       ),
            //                       CustomTitle(
            //                         text: controller.mono.value,
            //                         fontSize: 14,
            //                         fontWeight: FontWeight.w600,
            //                         color: Color(0xFF9A9A9A),
            //                         letterSpacing: -0.32,
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             Container(
            //               height: 16,
            //             ),
            //             IntrinsicHeight(
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                 children: [
            //                   Expanded(
            //                     child: InkWell(
            //                       onTap: () {
            //                         controller.shareQr();
            //                       },
            //                       child: Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Column(
            //                           mainAxisAlignment: MainAxisAlignment.center,
            //                           children: [
            //                             const Icon(
            //                               Icons.ios_share_outlined,
            //                               color: Colors.black,
            //                               size: 25,
            //                             ),
            //                             Text(
            //                               "Share",
            //                               style: Platform.isAndroid
            //                                   ? GoogleFonts.dmSans(
            //                                       color: Colors.black,
            //                                       fontWeight: FontWeight.w600,
            //                                       letterSpacing: 1,
            //                                       fontSize: 14)
            //                                   : TextStyle(
            //                                       color: Colors.black,
            //                                       fontWeight: FontWeight.w600,
            //                                       letterSpacing: 1,
            //                                       fontSize: 14,
            //                                       fontFamily: "SFProTextReg",
            //                                     ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                   Container(
            //                     width: 1,
            //                     color: const Color.fromRGBO(30, 33, 41, 0.08),
            //                   ),
            //                   Expanded(
            //                     child: InkWell(
            //                       onTap: () {
            //                         controller.saveQr();
            //                       },
            //                       child: Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Column(
            //                           mainAxisAlignment: MainAxisAlignment.center,
            //                           children: [
            //                             const Icon(
            //                               Icons.download_outlined,
            //                               color: Colors.black,
            //                               size: 25,
            //                             ),
            //                             Text(
            //                               "Save",
            //                               style: Platform.isAndroid
            //                                   ? GoogleFonts.dmSans(
            //                                       color: Colors.black,
            //                                       fontWeight: FontWeight.w600,
            //                                       letterSpacing: 1,
            //                                       fontSize: 14)
            //                                   : TextStyle(
            //                                       color: Colors.black,
            //                                       fontWeight: FontWeight.w600,
            //                                       letterSpacing: 1,
            //                                       fontSize: 14,
            //                                       fontFamily: "SFProTextReg",
            //                                     ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(18),
          decoration: BoxDecoration(
            shape: BoxShape.circle,

            image: controller.userImage != null
                ? DecorationImage(
                    image: MemoryImage(
                      base64Decode(controller.userImage!),
                    ),
                    fit: BoxFit.cover,
                  )
                : null, // No background image if userImage is null
          ),
          child: controller.userImage == null
              ? Center(
                  child: Icon(
                    Icons.person,
                    color: Colors.blueAccent,
                  ),
                )
              : null,
        ),
      ],
    );
  }
}
