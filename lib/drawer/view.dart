import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/routes/routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColor.bodyColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child:
                        Icon(Icons.person, size: 30, color: Colors.blueAccent),
                  ),
                  SizedBox(height: 10),
                  CustomTitle(
                    text: "Rechie Arnado",
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  CustomParagraph(
                    text: "rechkings20@gmail.com",
                    color: Colors.white70,
                  )
                ],
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
