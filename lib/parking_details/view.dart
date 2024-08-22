import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_button.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/no_internet.dart';
import 'package:luvpark_get/custom_widgets/variables.dart';
import 'package:luvpark_get/parking_details/controller.dart';

class ParkingDetails extends GetView<ParkingDetailsController> {
  const ParkingDetails({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(ParkingDetailsController());
    final ParkingDetailsController ct = Get.put(ParkingDetailsController());
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));
    return PopScope(
      canPop: true, //!ct.isLoadingAmen.value && !ct.isLoadingRoute.value,
      child: Scaffold(
        body: Obx(
          () => !ct.isNetConnected.value
              ? NoInternetConnected(
                  onTap: controller.refreshAmenData,
                )
              : ct.isLoading.value
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
                                initialCameraPosition: ct.intialPosition!,
                                mapType: MapType.normal,
                                mapToolbarEnabled: false,
                                zoomControlsEnabled: false,
                                myLocationEnabled: false,
                                myLocationButtonEnabled: false,
                                compassEnabled: false,
                                buildingsEnabled: false,
                                tiltGesturesEnabled: true,
                                markers: Set<Marker>.of(ct.markers),
                                polylines: {ct.polyline.value},
                                onMapCreated: ct.onMapCreated,
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * .25,
                            )
                          ],
                        ),
                        Positioned(bottom: 0, child: _buildDetails(ct)),
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

  Widget _buildDetails(ct) {
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
          Row(
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: CustomTitle(
                    text: ct.dataNearest["park_area_name"],
                    maxlines: 1,
                  ),
                  subtitle: CustomParagraph(
                    text: ct.dataNearest["address"],
                    maxlines: 2,
                  ),
                ),
              ),
              Container(width: 10),
              CustomParagraph(
                  text: Variables.formatDistance(ct.dataNearest["distance"]))
            ],
          ),
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
                        text: "${ct.dataNearest["parking_schedule"]}",
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
                    color:
                        ct.isOpen.value ? const Color(0xFF7BB56C) : Colors.red,
                  ),
                  child: Center(
                    child: CustomParagraph(
                      text: ct.isOpen.value ? "Open" : "Close",
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
                              text: "${ct.dataNearest["ps_vacant_count"]}",
                              style: GoogleFonts.manrope(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "/${ct.dataNearest["ps_total_count"]} slots available",
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
                      BottomSheetWidget(),
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
            loading: ct.btnLoading.value,
            onPressed: ct.onClickBooking,
          ),
          Container(height: 20),
        ],
      ),
    );
  }
}

class BottomSheetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParkingDetailsController>(
      init: ParkingDetailsController(),
      builder: (controller) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
        );
      },
    );
  }
}
