import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_body.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/no_data_found.dart';
import 'package:luvpark_get/custom_widgets/park_shimmer.dart';
import 'package:luvpark_get/custom_widgets/variables.dart';

import '../routes/routes.dart';
import 'controller.dart';

class ParkingScreen extends StatelessWidget {
  const ParkingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ParkingController ct = Get.put(ParkingController());

    return DefaultTabController(
      length: 3,
      child: CustomScaffold(
        bodyColor: AppColor.bodyColor,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColor.primaryColor,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        children: Obx(
          () => Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 1),
                      blurRadius: 1,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(
                                  Icons.chevron_left,
                                  color: Colors.white,
                                ),
                              ),
                              const CustomParagraph(
                                text: "Back",
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        const Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: CustomTitle(
                              text: "My Parking",
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Expanded(child: Container(width: 10))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
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
                                if (ct.isLoading.value) {
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
                                ct.onTabTapped(0);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: ct.currentPage.value != 0
                                    ? decor2()
                                    : decor1(),
                                child: Center(
                                  child: CustomParagraph(
                                    text: "Reservations",
                                    fontSize: 10,
                                    color: ct.currentPage.value != 0
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
                                if (ct.isLoading.value) {
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
                                ct.onTabTapped(1);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: ct.currentPage.value != 1
                                    ? decor2()
                                    : decor1(),
                                child: Center(
                                    child: CustomParagraph(
                                  text: "Active Parking",
                                  fontSize: 10,
                                  color: ct.currentPage.value != 1
                                      ? Colors.white38
                                      : Colors.white,
                                )),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (ct.isLoading.value) {
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
                                ct.onTabTapped(2);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: ct.currentPage.value != 2
                                    ? decor2()
                                    : decor1(),
                                child: Center(
                                    child: CustomParagraph(
                                  fontSize: 10,
                                  text: "Cancellations",
                                  color: ct.currentPage.value != 2
                                      ? Colors.white38
                                      : Colors.white,
                                )),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ct.isLoading.value
                    ? const ParkShimmer()
                    : ct.resData.isEmpty
                        ? const NoDataFound()
                        : RefreshIndicator(
                            onRefresh: ct.onRefresh,
                            child: ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                itemBuilder: (context, index) {
                                  String title = ct.resData[index]["notes"];
                                  String subTitle =
                                      ct.resData[index]["reservation_ref_no"];
                                  String date = Variables.convertDateFormat(
                                      ct.resData[index]["dt_in"]);
                                  String time =
                                      "${Variables.convertTime(ct.resData[index]["dt_in"].toString().split(" ")[1])} - ${Variables.convertTime(ct.resData[index]["dt_out"].toString().split(" ")[1])}";
                                  String totalAmt = toCurrencyString(
                                      ct.resData[index]["amount"].toString());
                                  String status = ct.resData[index]["status"] ==
                                          "U"
                                      ? "${ct.resData[index]["is_auto_extend"].toString() == "Y" ? "EXTENDED" : "ACTIVE"} PARKING"
                                      : "CONFIRMED";

                                  return ListCard(
                                    title: title,
                                    subTitle: subTitle,
                                    date: date,
                                    time: time,
                                    totalAmt: totalAmt,
                                    status: status,
                                    data: ct.resData[index],
                                    currentTab: ct.currentPage.value,
                                    onRefresh: () {},
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: 15,
                                    ),
                                itemCount: ct.resData.length),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
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

class ListCard extends StatelessWidget {
  final String title, subTitle, date, time, totalAmt, status;
  final int currentTab;
  final dynamic data;
  final Function onRefresh;
  const ListCard(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.date,
      required this.time,
      required this.totalAmt,
      required this.status,
      required this.data,
      required this.currentTab,
      required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // CustomModal(context: context).loader();
        // var param =
        //     "${ApiKeys.gApiSubFolderGetDirection}?ref_no=${data["reservation_ref_no"]}";

        // HttpRequest(api: param).get().then((returnData) async {
        //   if (returnData == "No Internet") {
        //     Navigator.of(context).pop();
        //     showAlertDialog(context, "Error",
        //         "Please check your internet connection and try again.", () {
        //       Navigator.of(context).pop();
        //     });
        //   }
        //   if (returnData == null) {
        //     Navigator.of(context).pop();
        //     showAlertDialog(context, "Error",
        //         "Error while connecting to server, Please contact support.",
        //         () {
        //       Navigator.of(context).pop();
        //     });

        //     return;
        //   } else {
        //     if (returnData["items"].length == 0) {
        //       Navigator.of(context).pop();
        //       showAlertDialog(
        //           context, "Error", "No data found, Please change location.",
        //           () {
        //         Navigator.of(context).pop();
        //       });
        //     } else {
        //       Navigator.pop(context);
        //       var dateInRelated = "";
        //       var dateOutRelated = "";
        //       dateInRelated = data["dt_in"];
        //       dateOutRelated = data["dt_out"];
        //       Map<String, dynamic> parameters = {
        //         "client_id": userId,
        //         "park_area_id": returnData["items"][0]["park_area_id"],
        //         "vehicle_type_id": returnData["items"][0]["vehicle_type_id"],
        //         "vehicle_plate_no":
        //             returnData["items"][0]["vehicle_plate_no"].toString(),
        //         "dt_in": dateInRelated,
        //         "dt_out": dateOutRelated,
        //         "no_hours": int.parse(data["no_hours"].toString()),
        //         "tran_type": "E",
        //       };
        //       if (data["status"].toString() == "C") {
        //         Variables.pageTrans(
        //             ReserveReceipt(
        //               isVehicleSelected: false,
        //               spaceName:
        //                   returnData["items"][0]["park_space_name"].toString(),
        //               parkArea:
        //                   returnData["items"][0]["park_area_name"].toString(),
        //               startDate: Variables.formatDate(
        //                   dateInRelated.toString().split(" ")[0]),
        //               endDate: Variables.formatDate(
        //                   dateOutRelated.toString().split(" ")[0]),
        //               startTime:
        //                   dateInRelated.toString().split(" ")[1].toString(),
        //               endTime:
        //                   dateOutRelated.toString().split(" ")[1].toString(),
        //               plateNo:
        //                   returnData["items"][0]["vehicle_plate_no"].toString(),
        //               hours: data["no_hours"].toString(),
        //               amount: data["amount"].toString(),
        //               refno: data["reservation_ref_no"].toString().toString(),
        //               lat: double.parse(returnData["items"][0]
        //                       ["park_space_latitude"]
        //                   .toString()),
        //               long: double.parse(returnData["items"][0]
        //                       ["park_space_longitude"]
        //                   .toString()),
        //               dtOut: dateOutRelated,
        //               dateIn: dateInRelated,
        //               isReserved: true,
        //               tab: currentTab,
        //               canReserved: true,
        //               paramsCalc: parameters,
        //               address: returnData["items"][0]["address"],
        //               ticketId: returnData["items"][0]["ticket_id"],
        //               isAutoExtend: data["is_auto_extend"].toString(),
        //               reservationId: data["reservation_id"],
        //               onTap: () {
        //                 onRefresh();
        //               },
        //             ),
        //             context);
        //       } else {
        //         Variables.pageTrans(
        //             ParkingDetails(
        //               startDate: dateInRelated
        //                           .toString()
        //                           .split(" ")[0]
        //                           .toString() ==
        //                       dateOutRelated.toString().split(" ")[0].toString()
        //                   ? Variables.formatDate(
        //                       dateInRelated.toString().split(" ")[0])
        //                   : "${Variables.formatDate(dateInRelated.toString().split(" ")[0])} - ${Variables.formatDate(dateOutRelated.toString().split(" ")[0])}",
        //               startTime:
        //                   dateInRelated.toString().split(" ")[1].toString(),
        //               endTime:
        //                   dateOutRelated.toString().split(" ")[1].toString(),
        //               resData: data,
        //               returnData: returnData["items"],
        //               dtOut: dateOutRelated,
        //               dateIn: dateInRelated,
        //               paramsCalc: parameters,
        //               onTap: () {
        //                 onRefresh();
        //               },
        //             ),
        //             context);
        //       }
        //     }
        //   }
        // });
        Get.toNamed(Routes.bookingReceipt);
      },
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFE8E6E6)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: currentTab == 0
                          ? const Color(0xFFF0E6C3)
                          : const Color(0xFFEAF3EA),
                      child: SvgPicture.asset(
                        "assets/dashboard_icon/${currentTab == 0 ? "orange_check" : "green_check"}.svg",
                        height: 24,
                        width: 24,
                      ),
                    ),
                    title: CustomTitle(
                      text: title,
                      color: AppColor.primaryColor,
                      letterSpacing: -0.41,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    subtitle: CustomParagraph(
                      text: subTitle,
                      fontSize: 14,
                      letterSpacing: -0.41,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppColor.primaryColor,
                      size: 30,
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 35.50,
                        height: 35.50,
                        child: Image(
                          image:
                              AssetImage("assets/dashboard_icon/calendar.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(width: 8),
                      CustomParagraph(
                        text: date,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.41,
                      ),
                      Container(width: 15),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(
                                width: 35.50,
                                height: 35.50,
                                child: Image(
                                  image: AssetImage(
                                      "assets/dashboard_icon/clock.png"),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Container(width: 8),
                              Flexible(
                                child: CustomParagraph(
                                  text: time,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.41,
                                  maxlines: 1,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
              decoration: const BoxDecoration(
                  color: Color(0xFF2495eb),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10))),
              child: Row(
                children: [
                  const Expanded(
                    child: CustomTitle(
                      text: "Total Amount Paid",
                      color: Colors.white,
                      letterSpacing: -0.41,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  CustomTitle(
                    text: totalAmt,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.41,
                    fontSize: 14,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
