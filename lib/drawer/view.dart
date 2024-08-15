import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/mapa/controller.dart';
import 'package:luvpark_get/routes/routes.dart';

class CustomDrawer extends GetView<DashboardMapController> {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getDrawerData();

    return Drawer(
      child: Container(
        color: AppColor.bodyColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
              ),
              child: const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Row(
                    //   children: [
                    //     CircleAvatar(
                    //       backgroundColor: Colors.white,
                    //       radius: 24,
                    //       child: controller.myProfilePic.value.isNotEmpty
                    //           ? Image.network(controller.myProfilePic.value)
                    //           : const Icon(Icons.person,
                    //               size: 24, color: Colors.blueAccent),
                    //     ),
                    //     Container(
                    //       width: 10,
                    //     ),
                    //     Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         CustomTitle(
                    //           text: controller.fullName.value.isNotEmpty
                    //               ? controller.fullName.value
                    //               : "Full Name",
                    //           color: Colors.white,
                    //           fontSize: 18,
                    //         ),
                    //         CustomParagraph(
                    //           text: controller.email.value.isNotEmpty
                    //               ? controller.email.value
                    //               : "Email Address",
                    //           color: Colors.white70,
                    //           fontSize: 13,
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blueAccent),
              title: const CustomParagraph(text: "My Parking"),
              onTap: () {
                Get.offAndToNamed(Routes.parking);
              },
            ),
            ListTile(
              leading: const Icon(Icons.wallet, color: Colors.blueAccent),
              title: const CustomParagraph(text: "Wallet"),
              onTap: () {
                Get.toNamed(Routes.wallet);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.blueAccent),
              title: const CustomParagraph(text: "Settings"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const CustomParagraph(
                text: "Logout",
                color: Colors.red,
              ),
              onTap: () async {
                // Handle logout
                CustomDialog().confirmationDialog(context, "Logout",
                    "Are you sure you want to logout?", "No", "Yes", () {
                  Get.back();
                }, () async {
                  Get.back();
                  CustomDialog().loadingDialog(context);
                  await Future.delayed(const Duration(seconds: 3));
                  final userLogin = await Authentication().getUserLogin();
                  List userData = [userLogin];
                  userData = userData.map((e) {
                    e["is_login"] = "N";
                    return e;
                  }).toList();

                  await Authentication().setLogin(jsonEncode(userData[0]));
                  Get.back();
                  Get.offAllNamed(Routes.splash);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
