import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_button.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/no_internet.dart';
import 'package:luvpark_get/parking_details/controller.dart';

class ParkingDetails extends GetView<ParkingDetailsController> {
  const ParkingDetails({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true, //!ct.isLoadingAmen.value && !ct.isLoadingRoute.value,
      child: Scaffold(
        body: Obx(
          () => !controller.isNetConnected.value
              ? NoInternetConnected(
                  onTap: controller.refreshAmenData,
                )
              : controller.isLoading.value
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .80,
                          height: MediaQuery.of(context).size.width * .80,
                          child: const Image(
                            image: AssetImage(
                                "assets/area_details/create_route.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        const CustomTitle(
                            text: "Creating route please wait..."),
                        Container(height: 10),
                        SizedBox(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.grey.shade400,
                              backgroundColor: Colors.grey.shade200,
                            ),
                          ),
                        )
                      ],
                    )
                  : Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: GoogleMap(
                                initialCameraPosition:
                                    controller.intialPosition!,
                                mapType: MapType.normal,
                                mapToolbarEnabled: false,
                                zoomControlsEnabled: false,
                                myLocationEnabled: false,
                                myLocationButtonEnabled: false,
                                compassEnabled: false,
                                buildingsEnabled: false,
                                tiltGesturesEnabled: true,
                                markers: Set<Marker>.of(controller.markers),
                                polylines: {controller.polyline.value},
                                onMapCreated: controller.onMapCreated,
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * .25,
                            )
                          ],
                        ),
                        Positioned(bottom: 0, child: _buildDetails()),
                        Positioned(
                          top: 40,
                          left: 20,
                          child: Container(
                            width: 45,
                            height: 45,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFFDFE7EF)),
                                borderRadius: BorderRadius.circular(7),
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
                            child: IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(Get.context!).size.width,
      clipBehavior: Clip.antiAlias,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0xFFDFE7EF)),
            borderRadius: BorderRadius.vertical(top: Radius.circular(7))),
        shadows: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 15,
            offset: Offset(0, 5),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          // Row(
          //   children: [
          //     Expanded(
          //       child: ListTile(
          //         contentPadding: EdgeInsets.zero,
          //         title: CustomTitle(
          //           text: controller.dataNearest["park_area_name"],
          //           maxlines: 1,
          //         ),
          //         subtitle: CustomParagraph(
          //           text: controller.dataNearest["address"],
          //           maxlines: 2,
          //         ),
          //       ),
          //     ),
          //     Container(width: 10),
          //     CustomParagraph(
          //         text: Variables.formatDistance(
          //             controller.dataNearest["distance"]))
          //   ],
          // ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Icon(CupertinoIcons.clock_fill, color: AppColor.primaryColor),
                Container(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomParagraph(
                        text: "Worktime",
                        maxlines: 1,
                      ),
                      CustomTitle(
                        text: "${controller.dataNearest["parking_schedule"]}",
                        maxlines: 1,
                      ),
                    ],
                  ),
                ),
                Container(width: 10),
                Container(
                  width: 65,
                  height: 26,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    color: controller.isOpen.value
                        ? const Color(0xFF7BB56C)
                        : Colors.red,
                  ),
                  child: Center(
                    child: CustomParagraph(
                      text: controller.isOpen.value ? "Open" : "Close",
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: const Center(
                    child: CustomTitle(
                      text: "P",
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomParagraph(
                        text: "Availability",
                        fontSize: 14,
                        maxlines: 1,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "${controller.dataNearest["ps_vacant_count"]}",
                              style: GoogleFonts.manrope(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "/${controller.dataNearest["ps_total_count"]} slots available",
                              style: GoogleFonts.manrope(
                                color: AppColor.paragraphColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.bottomSheet(
                      const BottomSheetWidget(),
                      isScrollControlled: true,
                    );
                  },
                  child: Row(
                    children: [
                      CustomParagraph(
                        text: "More details",
                        color: AppColor.primaryColor,
                      ),
                      Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: AppColor.primaryColor,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Container(height: 20),
          CustomButton(
            text: "Book now",
            loading: controller.btnLoading.value,
            onPressed: controller.onClickBooking,
          ),
          Container(height: 20),
        ],
      ),
    );
  }
}

class BottomSheetWidget extends GetView<ParkingDetailsController> {
  const BottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .80,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(7),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Row(
              children: [
                Icon(
                  Icons.chevron_left,
                  size: 24,
                  color: AppColor.primaryColor,
                ),
                const SizedBox(width: 3),
                Text(
                  'Back',
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontSize: 16,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(height: 20),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTitle(
                            text: "SM SOUTH LEFT",
                            fontSize: 20,
                          ),
                          CustomParagraph(
                            text:
                                "SM SOUTH MWCV+3HRT Farther M. Ferrs St. Bacolod, 6100 Negros Occidental",
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Iconsax.heart,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
                Container(height: 15),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Open ",
                        style: paragraphStyle(
                          color: Colors.green,
                        ),
                      ),
                      TextSpan(
                        text: ' ●  9:00 AM to 7:00 PM  ●  ',
                        style: paragraphStyle(),
                      ),
                      TextSpan(
                        text: '6 slots left',
                        style: paragraphStyle(color: const Color(0xFFE03C20)),
                      ),
                    ],
                  ),
                ),
                Container(height: 15),
                const CustomTitle(
                  text: "Available Vehicles",
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
                Container(height: 15),
                Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.vehicleTypes.map((type) {
                        final color = Color(
                            int.parse(type['color'].substring(1), radix: 16) +
                                0xFF000000);

                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: color.withOpacity(.5))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/dashboard_icon/${type["icon"]}.png"),
                                    color: color,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                CustomParagraph(
                                  text: '${type['name']} [ ${type['count']} ]',
                                  fontWeight: FontWeight.w700,
                                  color: color,
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(height: 25),
                const Divider(
                  height: 3,
                ),
                Container(height: 15),
                const CustomTitle(
                  text: "Parking Amenities",
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
                Container(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildColumn("2.5m x 5m\nPerpendicular"),
                      _buildColumn("CCTV Camera available"),
                      _buildColumn("Concrete floor"),
                      _buildColumn("Streetlights available"),
                    ],
                  ),
                ),
                Container(height: 20),
                const CustomTitle(
                  text: "Parking Rates",
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
                Container(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFE2F0FF),
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFF7FB2EC)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            CustomTitle(
                              text: '15',
                              textAlign: TextAlign.center,
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                            ),
                            CustomParagraph(
                              text: 'Base Rate',
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            CustomTitle(
                              text: '15',
                              textAlign: TextAlign.center,
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                            ),
                            CustomParagraph(
                              text: 'Succeedig Rate',
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w700,
                              maxlines: 1,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            CustomTitle(
                              text: '15',
                              textAlign: TextAlign.center,
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                            ),
                            CustomParagraph(
                              text: 'Base Hours',
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFE2F0FF),
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFF7FB2EC)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            CustomTitle(
                              text: '15',
                              textAlign: TextAlign.center,
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                            ),
                            CustomParagraph(
                              text: 'Base Rate',
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            CustomTitle(
                              text: '15',
                              textAlign: TextAlign.center,
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                            ),
                            CustomParagraph(
                              text: 'Succeedig Rate',
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w700,
                              maxlines: 1,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            CustomTitle(
                              text: '15',
                              textAlign: TextAlign.center,
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                            ),
                            CustomParagraph(
                              text: 'Base Hours',
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(height: 15),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget _buildColumn(String text) {
    return SizedBox(
      width: MediaQuery.of(Get.context!).size.width / 3.5,
      child: Padding(
        padding: const EdgeInsets.only(right: 10), // Padding to ensure spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 49,
              height: 49,
              decoration: ShapeDecoration(
                color: const Color(0xFFEDF7FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomParagraph(
              text: text,
              textAlign: TextAlign.center,
              maxlines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
