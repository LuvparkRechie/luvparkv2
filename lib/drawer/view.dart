import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/mapa/controller.dart';
import 'package:luvpark_get/routes/routes.dart';
import 'package:luvpark_get/web_view/webview.dart';

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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 67),
                    Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 29),
                          child: Row(
                            children: [
                              Container(
                                height: 38,
                                width: 45,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 44.5,
                                backgroundColor: Colors.white,
                                backgroundImage: controller.userProfile !=
                                            null &&
                                        controller
                                                .userProfile['image_base64'] !=
                                            null
                                    ? MemoryImage(
                                        base64Decode(controller
                                            .userProfile['image_base64']),
                                      )
                                    : null,
                                child: controller.userProfile == null
                                    ? const Icon(Icons.person,
                                        size: 44, color: Colors.blueAccent)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 10,
                    ),
                    CustomTitle(
                      text: controller.userProfile != null
                          ? '${controller.userProfile['first_name']} ${controller.userProfile['last_name']}'
                          : "Not Specified",
                      color: Colors.black,
                      fontSize: 18,
                      fontStyle: FontStyle.normal,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.408,
                    ),
                    Container(height: 10),
                    TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFEDEFF3),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(58.0),
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(horizontal: 20.0),
                        ),
                      ),
                      child: const CustomTitle(
                        text: "My Profile and Settings",
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.center,
                        letterSpacing: -0.408,
                      ),
                    ),
                    Container(height: 42),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: CustomTitle(
                    text: "My Account",
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.408,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFA1A1A9),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Color(0xFF1C1C1E)),
                  title: const CustomTitle(
                    text: "My Parking",
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.408,
                    color: Color(0xFF1C1C1E),
                  ),
                  trailing: const Icon(Icons.chevron_right_sharp,
                      color: Color(0xFF1C1C1E)),
                  onTap: () {
                    Get.offAndToNamed(Routes.parking);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.wallet, color: Color(0xFF1C1C1E)),
                  title: const CustomTitle(
                    text: "Wallet",
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.408,
                    color: Color(0xFF1C1C1E),
                  ),
                  trailing: const Icon(Icons.chevron_right_sharp,
                      color: Color(0xFF1C1C1E)),
                  onTap: () {
                    Get.toNamed(Routes.wallet);
                  },
                ),
                // ListTile(
                //   leading: const Icon(Icons.settings, color: Color(0xFF1C1C1E)),
                //   title: const CustomTitle(
                //     text: "Settings",
                //     fontSize: 14,
                //     fontStyle: FontStyle.normal,
                //     fontWeight: FontWeight.w700,
                //     letterSpacing: -0.408,
                //     color: Color(0xFF1C1C1E),
                //   ),
                //   trailing: const Icon(Icons.chevron_right_sharp,
                //       color: Color(0xFF1C1C1E)),
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                // ),
                Container(height: 22),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: CustomTitle(
                    text: "Help and Support",
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.408,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFA1A1A9),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Color(0xFF1C1C1E)),
                  title: const CustomTitle(
                    text: "About Us",
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.408,
                    color: Color(0xFF1C1C1E),
                  ),
                  trailing: const Icon(Icons.chevron_right_sharp,
                      color: Color(0xFF1C1C1E)),
                  onTap: () {
                    Get.offAndToNamed(Routes.aboutus);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Color(0xFF1C1C1E)),
                  title: const CustomTitle(
                    text: "FAQs",
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.408,
                    color: Color(0xFF1C1C1E),
                  ),
                  trailing: const Icon(Icons.chevron_right_sharp,
                      color: Color(0xFF1C1C1E)),
                  onTap: () {
                    Get.offAndToNamed(Routes.faqpage);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Color(0xFF1C1C1E)),
                  title: const CustomTitle(
                    text: "Terms of Use",
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.408,
                    color: Color(0xFF1C1C1E),
                  ),
                  trailing: const Icon(Icons.chevron_right_sharp,
                      color: Color(0xFF1C1C1E)),
                  onTap: () {
                    Get.to(const WebviewPage(
                      urlDirect: "https://luvpark.ph/terms-of-use/",
                      label: "Terms of Use",
                      isBuyToken: false,
                    ));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Color(0xFF1C1C1E)),
                  title: const CustomTitle(
                    text: "Privacy Policy",
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.408,
                    color: Color(0xFF1C1C1E),
                  ),
                  trailing: const Icon(Icons.chevron_right_sharp,
                      color: Color(0xFF1C1C1E)),
                  onTap: () {
                    Get.to(const WebviewPage(
                      urlDirect: "https://luvpark.ph/privacy-policy/",
                      label: "Privacy Policy",
                      isBuyToken: false,
                    ));
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 35, left: 60, right: 60),
            child: SizedBox(
              width: 200,
              child: TextButton(
                onPressed: () {
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
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xFFBD2424).withOpacity(0.12),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(58.0),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                ),
                child: const CustomTitle(
                  text: "Log out",
                  fontSize: 14,
                  color: Color(0xFFBD2424),
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                  letterSpacing: -0.408,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
