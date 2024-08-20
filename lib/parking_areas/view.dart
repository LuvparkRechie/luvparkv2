import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_appbar.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/variables.dart';
import 'package:luvpark_get/functions/functions.dart';
import 'package:luvpark_get/parking_areas/controller.dart';
import 'package:luvpark_get/routes/routes.dart';

import '../custom_widgets/showup_animation.dart';

class ParkingAreas extends GetView<ParkingAreasController> {
  const ParkingAreas({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColor.primaryColor, // Set status bar color
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));
    Get.put(ParkingAreasController());
    final ParkingAreasController ct = Get.put(ParkingAreasController());

    return Scaffold(
      appBar: const CustomAppbar(
        title: "Parking Areas",
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(48),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primaryColor.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 0,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                child: TextField(
                  autofocus: false,
                  //    controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search parking zone/address",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: 10),
                    hintStyle: Platform.isAndroid
                        ? GoogleFonts.dmSans(
                            color: const Color(0x993C3C43),
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            height: 0.08,
                            letterSpacing: -0.41,
                          )
                        : const TextStyle(
                            color: Color(0x993C3C43),
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            height: 0.08,
                            letterSpacing: -0.41,
                          ),
                  ),
                  style: paragraphStyle(),
                  onChanged: (String value) async {
                    ct.onSearch(value);
                  },
                ),
              ),
            ),
            Container(height: 20),
            CustomParagraph(
              text: "Nearest Parking",
              fontWeight: FontWeight.w700,
            ),
            Container(height: 10),
            Obx(
              () => Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColor.bodyColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(7),
                    ),
                  ),
                  child: StretchingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 2);
                      },
                      itemCount: ct.searchedZone.length,
                      itemBuilder: (context, index) {
                        String getDistanceString() {
                          double kmDist = Variables.convertToMeters(
                              ct.searchedZone[index]["distance"].toString());
                          if (kmDist >= 1000) {
                            double distanceInKilometers = kmDist / 1000;
                            return '${distanceInKilometers.toStringAsFixed(2)} km';
                          } else {
                            return '${kmDist.toStringAsFixed(2)} m';
                          }
                        }

                        String finalSttime =
                            "${ct.searchedZone[index]["start_time"].toString().substring(0, 2)}:${ct.searchedZone[index]["start_time"].toString().substring(2)}";
                        String finalEndtime =
                            "${ct.searchedZone[index]["end_time"].toString().substring(0, 2)}:${ct.searchedZone[index]["end_time"].toString().substring(2)}";
                        bool isOpen = Functions.checkAvailability(
                            finalSttime, finalEndtime);

                        return ShowUpAnimation(
                          delay: 5 * index,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.parkingDetails,
                                  arguments: ct.searchedZone[index]);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              width: MediaQuery.of(context).size.width * .88,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomTitle(
                                          text: ct.searchedZone[index]
                                              ["park_area_name"],
                                          fontSize: 16,
                                          maxlines: 1,
                                        ),
                                        CustomParagraph(
                                          text: ct.searchedZone[index]
                                              ["address"],
                                          fontSize: 14,
                                          maxlines: 2,
                                        ),
                                        Container(height: 10),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    "${getDistanceString()}  ●  ${ct.searchedZone[index]["parking_schedule"]}  ●  ",
                                                style: GoogleFonts.manrope(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              TextSpan(
                                                text: isOpen ? "OPEN" : "CLOSE",
                                                style: GoogleFonts.manrope(
                                                  fontWeight: FontWeight.w500,
                                                  color: isOpen
                                                      ? Colors.green
                                                      : Colors.red,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right_outlined,
                                    color: AppColor.primaryColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
