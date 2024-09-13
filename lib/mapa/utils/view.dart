// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:luvpark_get/custom_widgets/app_color.dart';
// import 'package:luvpark_get/custom_widgets/custom_appbar.dart';
// import 'package:luvpark_get/custom_widgets/custom_text.dart';
// import 'package:luvpark_get/custom_widgets/no_internet.dart';
// import 'package:luvpark_get/custom_widgets/page_loader.dart';

// import 'controller.dart';

// class FilterMap extends GetView<FilterMapController> {
//   const FilterMap({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     Get.put(FilterMapController());
//     return Scaffold(
//       appBar: CustomAppbar(
//         title: "Map Filter",
//         titleSize: 16,
//         action: [
//           InkWell(
//             onTap: () {
//               print("controller.filterParam ${controller.filterParam}");
//               Get.back();
//               controller.arguments(controller.filterParam);
//             },
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 15.0),
//                 child: CustomParagraph(
//                   text: "Apply",
//                   fontWeight: FontWeight.w700,
//                   color: AppColor.primaryColor,
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//       body: SafeArea(
//         child: Container(
//           color: AppColor.bodyColor,
//           child: StretchingOverscrollIndicator(
//             axisDirection: AxisDirection.down,
//             child: Obx(() => !controller.isNetConn.value
//                 ? Center(
//                     child: NoInternetConnected(
//                       onTap: controller.loadData,
//                     ),
//                   )
//                 : controller.isLoadingPage.value
//                     ? const PageLoader()
//                     : ListView(
//                         padding: const EdgeInsets.all(15),
//                         children: [
//                           const CustomParagraph(
//                             text: "Overnight Parking",
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w700,
//                           ),
//                           Container(height: 20),
//                           Row(
//                             children:
//                                 List.generate(controller.items.length, (index) {
//                               return InkWell(
//                                 onTap: () {
//                                   controller.filterParam.value =
//                                       controller.filterParam.map((e) {
//                                     e["ovp"] = controller.items[index]["value"];
//                                     return e;
//                                   }).toList();
//                                   controller.selectedOvp.value = index;
//                                 },
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(horizontal: 5),
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 13, vertical: 7),
//                                     decoration: BoxDecoration(
//                                       color:
//                                           controller.selectedOvp.value == index
//                                               ? AppColor.primaryColor
//                                               : AppColor.primaryColor
//                                                   .withOpacity(.1),
//                                       borderRadius: const BorderRadius.all(
//                                         Radius.circular(15), // Rounded corners
//                                       ),
//                                     ),
//                                     child: CustomParagraph(
//                                       text: controller.items[index]["text"],
//                                       color:
//                                           controller.selectedOvp.value == index
//                                               ? Colors.white
//                                               : Colors.black87,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }),
//                           ),
//                           Container(height: 10),
//                           Divider(
//                             color: Colors.grey.shade300,
//                           ),
//                           Container(height: 10),
//                           const CustomParagraph(
//                             text: "Radius",
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w700,
//                           ),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Slider(
//                                   value: controller.currentDistance.value,
//                                   min: double.parse(
//                                       controller.radiusData.first["value"]),
//                                   max: double.parse(
//                                       controller.radiusData.last["value"]),
//                                   divisions: 1998,
//                                   label: controller.labelDistance.value,
//                                   onChanged: (value) {
//                                     controller.onPickDistance(value);
//                                     double dist = controller
//                                         .currentDistance.value
//                                         .roundToDouble();

//                                     controller.filterParam.value =
//                                         controller.filterParam.map((e) {
//                                       e["radius"] = dist < 1.0
//                                           ? value.toString()
//                                           : dist.toString();
//                                       return e;
//                                     }).toList();
//                                   },
//                                 ),
//                               ),
//                               Text(
//                                 controller.labelDistance.value,
//                                 style:
//                                     paragraphStyle(fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),

//                           Divider(
//                             color: Colors.grey.shade300,
//                           ),

//                           const CustomParagraph(
//                             text: "Vehicle Type",
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w700,
//                           ),
//                           Container(height: 5),
//                           buildFilterOptions(),
//                           Container(height: 10),
//                           Divider(
//                             color: Colors.grey.shade300,
//                           ),
//                           Container(height: 10),
//                           const CustomParagraph(
//                             text: "Parking Type",
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w700,
//                           ),
//                           Container(height: 10),
//                           buildFilterChips(),
//                           Container(height: 10),
//                           Divider(
//                             color: Colors.grey.shade300,
//                           ),
//                           Container(height: 10),

//                           //Amenities
//                           const CustomParagraph(
//                             text: "Amenities",
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w700,
//                           ),
//                           Container(height: 10),
//                           buildFilterChipsAmenities(),
//                           Container(height: 10),
//                           Divider(
//                             color: Colors.grey.shade300,
//                           ),
//                           Container(height: 10),
//                         ],
//                       )),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildFilterOptions() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         for (int i = 0; i < controller.vhTypeData.length; i++)
//           FilterChip(
//             padding: EdgeInsets.symmetric(vertical: 1),
//             showCheckmark: false,
//             backgroundColor: AppColor.primaryColor.withOpacity(.1),
//             label: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   width: 150,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(width: 10),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 5),
//                         child: SvgPicture.asset(
//                           _getSvgForVehicle(
//                               controller.vhTypeData[i]["text"].toString()),
//                           width: 30.0,
//                           height: 30.0,
//                         ),
//                       ),
//                       Container(width: 10),
//                       CustomParagraph(
//                         textAlign: TextAlign.center,
//                         fontSize: 12,
//                         text: controller.vhTypeData[i]["text"].toString(),
//                         color: controller.selectedVehicleTypes.contains(
//                                 controller.vhTypeData[i]["value"].toString())
//                             ? Colors.white
//                             : Colors.black87,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             selected: controller.selectedVehicleTypes
//                 .contains(controller.vhTypeData[i]["value"].toString()),
//             onSelected: (bool selected) {
//               if (selected) {
//                 controller.selectedVehicleTypes
//                     .add(controller.vhTypeData[i]["value"].toString());
//               } else {
//                 controller.selectedVehicleTypes
//                     .remove(controller.vhTypeData[i]["value"].toString());
//               }
//             },
//             selectedColor: AppColor.primaryColor,
//           ),
//         const SizedBox(height: 10.0),
//       ],
//     );
//   }

//   String _getSvgForVehicle(String vhTypeText) {
//     switch (vhTypeText) {
//       case 'Large Vehicle':
//         return 'assets/images/cars.svg';
//       case 'Motorcycle':
//         return 'assets/images/motor.svg';
//       case 'Trikes and Cars':
//         return 'assets/images/cars.svg';
//       default:
//         return 'assets/images/cars.svg';
//     }
//   }

//   Widget buildFilterChips() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Wrap(spacing: 10.0, children: [
//           for (int i = 0; i < controller.parkTypeData.length; i++)
//             FilterChip(
//               showCheckmark: false,
//               backgroundColor: AppColor.primaryColor.withOpacity(.1),
//               label: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(
//                     width: 150,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(width: 10),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 2),
//                           child: SvgPicture.asset(
//                             _getSvgForParkingType(controller.parkTypeData[i]
//                                 ["parking_type_name"]),
//                             width: 30.0,
//                             height: 30.0,
//                           ),
//                         ),
//                         Container(width: 10),
//                         CustomParagraph(
//                           textAlign: TextAlign.center,
//                           fontSize: 12,
//                           text: capitalizeWords(controller.parkTypeData[i]
//                                   ["parking_type_name"]
//                               .toString()),
//                           color: controller.sfPt.contains(controller
//                                   .parkTypeData[i]["parking_type_code"]
//                                   .toString())
//                               ? Colors.white
//                               : Colors.black87,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               selected: controller.sfPt.contains(
//                   controller.parkTypeData[i]["parking_type_code"].toString()),
//               onSelected: (bool selected) {
//                 if (selected) {
//                   controller.sfPt.add(controller.parkTypeData[i]
//                           ["parking_type_code"]
//                       .toString());
//                 } else {
//                   controller.sfPt.remove(controller.parkTypeData[i]
//                           ["parking_type_code"]
//                       .toString());
//                 }
//                 print(controller.parkTypeData[i]["parking_type_name"]);
//                 String filterVtype = controller.sfPt.join('|');
//                 controller.filterParam.value = controller.filterParam.map((e) {
//                   e["park_type"] = filterVtype.toString();
//                   return e;
//                 }).toList();
//               },
//               selectedColor: AppColor.primaryColor,
//             ),
//         ]),
//       ],
//     );
//   }

//   String capitalizeWords(String str) {
//     return str.toLowerCase().split(' ').map((word) {
//       return word[0].toUpperCase() + word.substring(1);
//     }).join(' ');
//   }

//   String _getSvgForParkingType(String ptText) {
//     switch (ptText) {
//       case 'STREET':
//         return 'assets/images/street.svg';
//       case 'COMMERCIAL':
//         return 'assets/images/commercial.svg';
//       case 'PRIVATE':
//         return 'assets/images/private.svg';
//       default:
//         return 'assets/images/street.svg';
//     }
//   }

//   Widget buildFilterChipsAmenities() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Wrap(spacing: 10.0, children: [
//           for (int i = 0; i < controller.amenitiesData.length; i++)
//             FilterChip(
//               showCheckmark: false,
//               backgroundColor: AppColor.primaryColor.withOpacity(.1),
//               label: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(
//                     width: 200,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(width: 10),
//                         SvgPicture.asset(
//                           _getSvgForAmenities(
//                             controller.amenitiesData[i]["parking_amenity_desc"],
//                           ),
//                           width: 34.0,
//                           height: 34.0,
//                         ),
//                         Container(width: 10),
//                         CustomParagraph(
//                           text: _capitalTextAmen(controller.amenitiesData[i]
//                               ["parking_amenity_desc"]),
//                           fontSize: 12,
//                           color: controller.sfAmen.contains(controller
//                                   .amenitiesData[i]["parking_amenity_code"]
//                                   .toString())
//                               ? Colors.white
//                               : Colors.black87,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               selected: controller.sfAmen.contains(controller.amenitiesData[i]
//                       ["parking_amenity_code"]
//                   .toString()),
//               onSelected: (bool selected) {
//                 if (selected) {
//                   controller.sfAmen.add(controller.amenitiesData[i]
//                           ["parking_amenity_code"]
//                       .toString());
//                 } else {
//                   controller.sfAmen.remove(controller.amenitiesData[i]
//                           ["parking_amenity_code"]
//                       .toString());
//                 }
//                 String filterAmen = controller.sfAmen.join('|');
//                 controller.filterParam.value = controller.filterParam.map((e) {
//                   e["amen"] = filterAmen.toString();
//                   return e;
//                 }).toList();
//               },
//               selectedColor: AppColor.primaryColor,
//             ),
//         ]),
//       ],
//     );
//   }
// }

// String _getSvgForAmenities(String amenText) {
//   switch (amenText) {
//     case 'ASPHALT FLOOR':
//       return 'assets/images/asphalt.svg';
//     case 'CONCRETE FLOOR':
//       return 'assets/images/concrete.svg';
//     case 'COVERED / SHADED':
//       return 'assets/images/covered.svg';
//     // case 'SAND  AND GRAVEL':
//     //   return 'assets/images/sand.svg';
//     case 'WITH CCTV':
//       return 'assets/images/cctv.svg';
//     case 'WITH SECURITY':
//       return 'assets/images/security.svg';
//     default:
//       return 'assets/images/grass.svg';
//   }
// }

// String _capitalTextAmen(String amenText) {
//   switch (amenText) {
//     case 'ASPHALT FLOOR':
//       return 'Asphalt Floor';
//     case 'CONCRETE FLOOR':
//       return 'Concrete Floor';
//     case 'COVERED / SHADED':
//       return 'Covered/ Shaded';
//     case 'SAND  AND GRAVEL':
//       return 'Sand and Gravel';
//     case 'WITH CCTV':
//       return 'With CCTV';
//     case 'WITH SECURITY':
//       return 'With Security';
//     default:
//       return 'DEFAULT';
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/custom_button.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/no_internet.dart';
import 'package:luvpark_get/custom_widgets/page_loader.dart';

import 'controller.dart';

class FilterMap extends GetView<FilterMapController> {
  const FilterMap({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(FilterMapController());
    return Container(
      height: MediaQuery.of(context).size.height * .75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0)), // Rounded top corners
      ),
      child: Obx(() => !controller.isNetConn.value
          ? Center(
              child: NoInternetConnected(
                onTap: controller.loadData,
              ),
            )
          : controller.isLoadingPage.value
              ? const PageLoader()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //VEHICLE TYPE
                    Container(height: 20),
                    Center(
                      child: Container(
                        width: 71,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(56),
                          color: const Color(0xffd9d9d9),
                        ),
                      ),
                    ),

                    Container(height: 20),
                    Expanded(
                        child: StretchingOverscrollIndicator(
                      axisDirection: AxisDirection.down,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomParagraph(
                              text: "Vehicle Type",
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                            ),
                            Container(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  buildFilterOptions(),
                                ],
                              ),
                            ),
                            Container(height: 10),
                            //PARKING TYPE
                            const CustomParagraph(
                              text: "Parking Type",
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                            ),
                            Container(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  buildFilterChips(),
                                ],
                              ),
                            ),
                            const CustomParagraph(
                              text: "Radius",
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                            ),
                            //RADIUS
                            Row(
                              children: [
                                Expanded(
                                  child: Slider(
                                    value: controller.currentDistance.value,
                                    min: double.parse(
                                        controller.radiusData.first["value"]),
                                    max: double.parse(
                                        controller.radiusData.last["value"]),
                                    divisions: 1998,
                                    label: controller.labelDistance.value,
                                    onChanged: (value) {
                                      controller.onPickDistance(value);
                                      controller.filterParam.value =
                                          controller.filterParam.map((e) {
                                        e["radius"] = controller
                                            .currentDistance.value
                                            .roundToDouble()
                                            .toString();
                                        return e;
                                      }).toList();
                                    },
                                  ),
                                ),
                                Text(
                                  controller.labelDistance.value,
                                  style: paragraphStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            //OVERNIGHT PARKING
                            const CustomParagraph(
                              text: "Overnight Parking",
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.408,
                              fontSize: 14,
                            ),
                            Container(height: 10),
                            Row(
                              children: List.generate(controller.items.length,
                                  (index) {
                                return InkWell(
                                  onTap: () {
                                    controller.filterParam.value =
                                        controller.filterParam.map((e) {
                                      e["ovp"] =
                                          controller.items[index]["value"];
                                      return e;
                                    }).toList();
                                    controller.selectedOvp.value = index;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: controller.selectedOvp.value ==
                                                index
                                            ? const Color(0xFFEDF7FF)
                                            : const Color(0xFFE6EBF0),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(7), // Rounded corners
                                        ),
                                      ),
                                      child: CustomParagraph(
                                        text: controller.items[index]["text"],
                                        fontSize: 14,
                                        color: controller.selectedOvp.value ==
                                                index
                                            ? const Color(0xFF0078FF)
                                            : const Color(0xFFB6C1CC),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            Container(height: 10),

                            const Divider(
                              color: Colors.grey,
                            ),
                            Container(height: 10),

                            //Amenities
                            const CustomParagraph(
                              text: "Amenities",
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                            ),
                            Container(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: buildFilterChipsAmenities(),
                                ),
                              ],
                            ),
                            Container(height: 5),
                            SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                text: "Apply",
                                onPressed: () {
                                  if (controller
                                          .filterParam[0]["ovp"]!.isEmpty &&
                                      controller
                                          .filterParam[0]["amen"]!.isEmpty &&
                                      controller
                                          .filterParam[0]["vh_type"]!.isEmpty &&
                                      controller.filterParam[0]["park_type"]!
                                          .isEmpty) {
                                    return;
                                  }

                                  Get.back();
                                  controller.arguments(controller.filterParam);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                  ],
                )),
    );
  }

  Widget buildFilterOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        for (int i = 0; i < controller.vhTypeData.length; i++)
          GestureDetector(
            onTap: () {
              bool isSelected = controller.selectedVehicleTypes
                  .contains(controller.vhTypeData[i]["value"].toString());

              if (isSelected) {
                controller.selectedVehicleTypes
                    .remove(controller.vhTypeData[i]["value"].toString());
              } else {
                controller.selectedVehicleTypes
                    .add(controller.vhTypeData[i]["value"].toString());
              }
            },
            child: SizedBox(
              width: MediaQuery.of(Get.context!).size.width / 4,
              height: MediaQuery.of(Get.context!).size.width / 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      _getSvgForVehicle(
                        controller.vhTypeData[i]["text"].toString(),
                        controller.selectedVehicleTypes.contains(
                          controller.vhTypeData[i]["value"].toString(),
                        ),
                      ),
                      width: 40.0,
                      height: 40.0,
                    ),
                    const SizedBox(height: 5.0),
                    CustomParagraph(
                      textAlign: TextAlign.center,
                      fontSize: 12,
                      text: controller.vhTypeData[i]["text"].toString(),
                      color: controller.selectedVehicleTypes.contains(
                              controller.vhTypeData[i]["value"].toString())
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _getSvgForVehicle(String vhTypeText, bool isActive) {
    switch (vhTypeText) {
      case 'Large Vehicle':
        return isActive
            ? 'assets/map_filter/active/largevehicle_active.svg'
            : 'assets/map_filter/inactive/largevehicle_inactive.svg';
      case 'Motorcycle':
        return isActive
            ? 'assets/map_filter/active/motor_active.svg'
            : 'assets/map_filter/inactive/motor_inactive.svg';
      case 'Trikes and Cars':
        return isActive
            ? 'assets/map_filter/active/car_active.svg'
            : 'assets/map_filter/inactive/car_inactive.svg';
      default:
        return isActive
            ? 'assets/map_filter/active/car_active.svg'
            : 'assets/map_filter/inactive/car_inactive.svg';
    }
  }

  Widget buildFilterChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          //spacing: 10.0,
          children: [
            for (int i = 0; i < controller.parkTypeData.length; i++)
              GestureDetector(
                onTap: () {
                  bool isSelected = controller.sfPt.contains(controller
                      .parkTypeData[i]["parking_type_code"]
                      .toString());

                  if (isSelected) {
                    controller.sfPt.remove(controller.parkTypeData[i]
                            ["parking_type_code"]
                        .toString());
                  } else {
                    controller.sfPt.add(controller.parkTypeData[i]
                            ["parking_type_code"]
                        .toString());
                  }

                  String filterVtype = controller.sfPt.join('|');
                  controller.filterParam.value =
                      controller.filterParam.map((e) {
                    e["park_type"] = filterVtype.toString();
                    return e;
                  }).toList();
                },
                child: SizedBox(
                  width: MediaQuery.of(Get.context!).size.width / 4,
                  height: MediaQuery.of(Get.context!).size.width / 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          _getSvgForParkingType(
                            controller.parkTypeData[i]["parking_type_name"],
                            controller.sfPt.contains(controller.parkTypeData[i]
                                    ["parking_type_code"]
                                .toString()), // Determines active/inactive state
                          ),
                          width: 40.0,
                          height: 40.0,
                        ),
                        const SizedBox(height: 5.0),
                        CustomParagraph(
                          textAlign: TextAlign.center,
                          fontSize: 12,
                          text: capitalizeWords(
                            controller.parkTypeData[i]["parking_type_name"]
                                .toString(),
                          ),
                          color: controller.sfPt.contains(controller
                                  .parkTypeData[i]["parking_type_code"]
                                  .toString())
                              ? Colors.black // Black when selected
                              : Colors.grey, // Grey when not selected
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  String capitalizeWords(String str) {
    return str.toLowerCase().split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  String _getSvgForParkingType(String ptText, bool isActive) {
    // Return active/inactive SVG based on selection state
    switch (ptText) {
      case 'STREET':
        return isActive
            ? 'assets/map_filter/active/street_active.svg'
            : 'assets/map_filter/inactive/street_inactive.svg';
      case 'COMMERCIAL':
        return isActive
            ? 'assets/map_filter/active/commercial_active.svg'
            : 'assets/map_filter/inactive/commercial_inactive.svg';
      case 'PRIVATE':
        return isActive
            ? 'assets/map_filter/active/private_active.svg'
            : 'assets/map_filter/inactive/private_inactive.svg';
      default:
        return isActive
            ? 'assets/map_filter/active/street_active.svg'
            : 'assets/map_filter/inactive/street_inactive.svg';
    }
  }

  Widget buildFilterChipsAmenities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 5.0,
          alignment: WrapAlignment.center,
          children: [
            for (int i = 0; i < controller.amenitiesData.length; i++)
              SizedBox(
                width: 100.0,
                child: GestureDetector(
                  onTap: () {
                    bool isSelected = controller.sfAmen.contains(controller
                        .amenitiesData[i]["parking_amenity_code"]
                        .toString());

                    if (isSelected) {
                      controller.sfAmen.remove(controller.amenitiesData[i]
                              ["parking_amenity_code"]
                          .toString());
                    } else {
                      controller.sfAmen.add(controller.amenitiesData[i]
                              ["parking_amenity_code"]
                          .toString());
                    }

                    String filterAmen = controller.sfAmen.join('|');
                    controller.filterParam.value =
                        controller.filterParam.map((e) {
                      e["amen"] = filterAmen.toString();
                      return e;
                    }).toList();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7.0, vertical: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          _getSvgForAmenities(
                            controller.amenitiesData[i]["parking_amenity_desc"],
                            controller.sfAmen.contains(controller
                                .amenitiesData[i]["parking_amenity_code"]
                                .toString()),
                          ),
                          width: 32.0,
                          height: 32.0,
                        ),
                        const SizedBox(height: 5.0),
                        CustomParagraph(
                          textAlign: TextAlign.center,
                          text: _capitalTextAmen(
                            controller.amenitiesData[i]["parking_amenity_desc"]
                                .toString(),
                          ),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: controller.sfAmen.contains(controller
                                  .amenitiesData[i]["parking_amenity_code"]
                                  .toString())
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  String _getSvgForAmenities(String amenText, bool isActive) {
    switch (amenText) {
      case 'ASPHALT FLOOR':
        return isActive
            ? 'assets/map_filter/active/asphalt_active.svg'
            : 'assets/map_filter/inactive/asphalt_inactive.svg';
      case 'CONCRETE FLOOR':
        return isActive
            ? 'assets/map_filter/active/concrete_active.svg'
            : 'assets/map_filter/inactive/concrete_inactive.svg';
      case 'COVERED / SHADED':
        return isActive
            ? 'assets/map_filter/active/covered_active.svg'
            : 'assets/map_filter/inactive/covered_inactive.svg';
      case 'SAND AND GRAVEL':
        return isActive
            ? 'assets/map_filter/active/gravel_active.svg'
            : 'assets/map_filter/inactive/gravel_inactive.svg';
      case 'WITH CCTV':
        return isActive
            ? 'assets/map_filter/active/cctv_active.svg'
            : 'assets/map_filter/inactive/cctv_inactive.svg';
      case 'WITH SECURITY':
        return isActive
            ? 'assets/map_filter/active/security_active.svg'
            : 'assets/map_filter/inactive/security_inactive.svg';
      default:
        return isActive
            ? 'assets/map_filter/active/gravel_active.svg'
            : 'assets/map_filter/inactive/gravel_inactive.svg'; // Default icon
    }
  }

  String _capitalTextAmen(String amenText) {
    switch (amenText) {
      case 'ASPHALT FLOOR':
        return 'Asphalt Floor';
      case 'CONCRETE FLOOR':
        return 'Concrete Floor';
      case 'COVERED / SHADED':
        return 'Covered/ Shaded';
      case 'SAND  AND GRAVEL':
        return 'Sand and Gravel';
      case 'WITH CCTV':
        return 'With CCTV';
      case 'WITH SECURITY':
        return 'With Security';
      default:
        return 'DEFAULT';
    }
  }
}
