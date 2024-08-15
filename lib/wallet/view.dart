// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

import 'utils/transaction_details.dart';

class WalletScreen extends GetView<WalletController> {
  const WalletScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // final WalletController ct = Get.put(WalletController());

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          ),
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
                          child: Column(
                            children: [
                              CustomAppbar(
                                onTap: () {
                                  Get.back();
                                },
                                title: "My Parking",
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                  child: ListView(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                width: 1,
                                                color: Color(0xFFDFE7EF)),
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          shadows: const [
                                            BoxShadow(
                                              color: Color(0x0C000000),
                                              blurRadius: 15,
                                              offset: Offset(0, 5),
                                              spreadRadius: 0,
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomParagraph(
                                                            text:
                                                                "Current Balance"),
                                                        SizedBox(height: 5),
                                                        CustomTitle(
                                                          text: controller
                                                                  .userData[0]
                                                              ["amount_bal"],
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 20,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(width: 30),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      border: Border.all(
                                                        color: AppColor
                                                            .primaryColor
                                                            .withOpacity(.2),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Iconsax.card_add,
                                                          color: AppColor
                                                              .primaryColor,
                                                        ),
                                                        Container(width: 10),
                                                        const CustomParagraph(
                                                          text: "Recharge",
                                                          fontSize: 14,
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Container(height: 20),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Iconsax.gift,
                                                    size: 15,
                                                    color: Colors.pink,
                                                  ),
                                                  Container(width: 5),
                                                  Flexible(
                                                      child: CustomParagraph(
                                                    text: controller.userData[0]
                                                        ["points_bal"],
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                  )),
                                                  Container(width: 5),
                                                  const Flexible(
                                                    child: CustomParagraph(
                                                      text: "Rewards",
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(height: 15),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              Get.toNamed(Routes.walletsend,
                                                  arguments: () {
                                                controller.getLogs();
                                                controller.getUserBalance();
                                              });
                                              // final item =
                                              //     await Authentication().getUserData();
                                              // final uData = jsonDecode(item!);

                                              // if (uData["first_name"].toString().isEmpty ||
                                              //     uData["first_name"] == null) {
                                              //   CustomDialog().errorDialog(
                                              //       context,
                                              //       "Attention",
                                              //       "Complete your account information to access the requested service.\nGo to profile and update your account. ",
                                              //       () {
                                              //     Get.back();
                                              //   });
                                              // } else {}
                                              // // print("items $item");
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 8),
                                              clipBehavior: Clip.antiAlias,
                                              decoration: ShapeDecoration(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                      width: 1,
                                                      color: Color(0xFFDFE7EF)),
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                                                shadows: const [
                                                  BoxShadow(
                                                    color: Color(0x0C000000),
                                                    blurRadius: 15,
                                                    offset: Offset(0, 5),
                                                    spreadRadius: 0,
                                                  )
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Iconsax.send_2,
                                                    color:
                                                        AppColor.primaryColor,
                                                  ),
                                                  Container(width: 5),
                                                  const CustomParagraph(
                                                      text: "Send")
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(width: 10),
                                          GestureDetector(
                                            onTap: () {
                                              Get.toNamed(Routes.qrwallet);
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 8),
                                              clipBehavior: Clip.antiAlias,
                                              decoration: ShapeDecoration(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                      width: 1,
                                                      color: Color(0xFFDFE7EF)),
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                                                shadows: const [
                                                  BoxShadow(
                                                    color: Color(0x0C000000),
                                                    blurRadius: 15,
                                                    offset: Offset(0, 5),
                                                    spreadRadius: 0,
                                                  )
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    CupertinoIcons
                                                        .qrcode_viewfinder,
                                                    color:
                                                        AppColor.primaryColor,
                                                  ),
                                                  Container(width: 5),
                                                  const CustomParagraph(
                                                      text: "QR")
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(height: 30),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomTitle(
                                            text: "Transaction History",
                                            fontWeight: FontWeight.w600,
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Get.bottomSheet(
                                                  // enableDrag: true,
                                                  enterBottomSheetDuration:
                                                      const Duration(
                                                    milliseconds: 500,
                                                  ),
                                                  // settings: RouteSettings(),
                                                  BottomSheetWidget(),
                                                  isScrollControlled: true,
                                                );
                                              },
                                              child: const Text(
                                                "See all",
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ))
                                          // CustomParagraph(
                                          //   text: "See all",
                                          //   fontSize: 14,
                                          //   color: AppColor.primaryColor,
                                          // )
                                        ],
                                      ),
                                      Container(height: 15),
                                      controller.isLoading.value
                                          ? const ParkShimmer()
                                          : ListView.separated(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              itemCount:
                                                  controller.logs.length > 5
                                                      ? 5
                                                      : controller.logs.length,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      context: context,
                                                      builder: (context) =>
                                                          TransactionDetails(
                                                        index: index,
                                                        data: controller.logs,
                                                      ),
                                                    );
                                                  },
                                                  child: ListTile(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    title: CustomTitle(
                                                      text:
                                                          controller.logs[index]
                                                              ["tran_desc"],
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    subtitle: CustomParagraph(
                                                      text: DateFormat(
                                                              'MMM d, yyyy h:mm a')
                                                          .format(DateTime
                                                              .parse(controller
                                                                          .logs[
                                                                      index][
                                                                  "tran_date"])),
                                                      fontSize: 12,
                                                    ),
                                                    trailing: Icon(
                                                      CupertinoIcons
                                                          .chevron_right,
                                                      size: 14,
                                                      color:
                                                          AppColor.primaryColor,
                                                    ),
                                                  ),
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) => Divider(
                                                endIndent: 1,
                                                height: 1,
                                                color: Colors.grey.shade200,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
        ));
  }
}

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final WalletController ctr = Get.put(WalletController());
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
      height: MediaQuery.of(context).size.height * .60,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(15),
      child: GetBuilder<WalletController>(
        init: WalletController(),
        builder: (controller) {
          return Column(children: [
            Center(
              child: Container(
                  width: 71,
                  height: 6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(56),
                      color: const Color(0xffd9d9d9))),
            ),
            Container(height: 10),
            Expanded(
              child: ctr.isLoading.value
                  ? const ParkShimmer()
                  : ListView.separated(
                      padding: const EdgeInsets.all(15),
                      itemCount: ctr.logs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => TransactionDetails(
                                index: index,
                                data: ctr.logs,
                              ),
                            );
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: CustomTitle(
                              text: ctr.logs[index]["tran_desc"],
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            subtitle: CustomParagraph(
                              text: DateFormat('MMM d, yyyy h:mm a').format(
                                  DateTime.parse(ctr.logs[index]["tran_date"])),
                              fontSize: 12,
                            ),
                            trailing: Icon(
                              CupertinoIcons.chevron_right,
                              size: 14,
                              color: AppColor.primaryColor,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(
                        endIndent: 1,
                        height: 1,
                      ),
                    ),
            )
          ]);
        },
      ),
    );
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
