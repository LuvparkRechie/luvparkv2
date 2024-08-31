import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_appbar.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/no_data_found.dart';
import 'package:luvpark_get/custom_widgets/no_internet.dart';
import 'package:luvpark_get/custom_widgets/page_loader.dart';

import 'controller.dart';

class MyVehicles extends GetView<MyVehiclesController> {
  const MyVehicles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bodyColor,
      appBar: CustomAppbar(
        title: "My Vehicles",
        bgColor: AppColor.primaryColor,
        textColor: Colors.white,
        titleColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(
            Iconsax.add,
            color: Colors.white,
          ),
          onPressed: () {
            controller.getVehicleDropDown();
          }),
      body: Obx(
        () => controller.isLoadingPage.value
            ? const PageLoader()
            : !controller.isNetConn.value
                ? NoInternetConnected(
                    onTap: controller.onRefresh,
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: RefreshIndicator(
                      onRefresh: controller.onRefresh,
                      child: controller.vehicleData.isEmpty
                          ? const NoDataFound()
                          : StretchingOverscrollIndicator(
                              axisDirection: AxisDirection.down,
                              child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CustomTitle(
                                            text: controller.vehicleData[index]
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
                                            text: controller.vehicleData[index]
                                                ["vehicle_brand_name"],
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                      leading: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Icon(
                                          int.parse(controller
                                                      .vehicleData[index]
                                                          ["vehicle_type_id"]
                                                      .toString()) ==
                                                  1
                                              ? Icons.motorcycle_outlined
                                              : Icons.time_to_leave,
                                        ),
                                      ),
                                      trailing: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onTap: () {
                                        controller.onDeleteVehicle(
                                            controller.vehicleData[index]
                                                ["vehicle_plate_no"]);
                                      },
                                    );
                                  },
                                  separatorBuilder: (context, index) => Divider(
                                        color: Colors.grey[800],
                                        height: 1,
                                      ),
                                  itemCount: controller.vehicleData.length),
                            ),
                    ),
                  ),
      ),
    );
  }
}
