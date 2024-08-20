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
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              backgroundImage: controller.userProfile != null &&
                                      controller.userProfile['image_base64'] !=
                                          null
                                  ? MemoryImage(
                                      base64Decode(controller
                                          .userProfile['image_base64']),
                                    )
                                  : null,
                              child: controller.userProfile == null
                                  ? const Icon(Icons.person,
                                      size: 24, color: Colors.blueAccent)
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTitle(
                                  text: controller.userProfile != null
                                      ? '${controller.userProfile['first_name']} ${controller.userProfile['last_name']}'
                                      : "Not Specified",
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                                CustomParagraph(
                                  text: controller.userProfile != null
                                      ? controller.userProfile['email']
                                      : "Email Address",
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: CustomTitle(
                      text: "My Account".toUpperCase(),
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w900,
                      color: AppColor.primaryColor),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: CustomTitle(
                      text: "Help and Support".toUpperCase(),
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w900,
                      color: AppColor.primaryColor),
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.blueAccent),
                  title: const CustomParagraph(text: "FAQs"),
                  onTap: () {
                    Get.offAndToNamed(Routes.faqpage);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.wallet, color: Colors.blueAccent),
                  title: const CustomParagraph(text: "Terms of Use"),
                  onTap: () {
                    Get.toNamed(Routes.wallet);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.blueAccent),
                  title: const CustomParagraph(text: "Privacy Policy"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const CustomParagraph(
              text: "Logout",
              color: Colors.red,
            ),
            onTap: () async {
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
    );
  }
}
