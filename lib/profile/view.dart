import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_appbar.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/no_internet.dart';
import 'package:luvpark_get/custom_widgets/page_loader.dart';
import 'package:luvpark_get/profile/index.dart';
import 'package:luvpark_get/routes/routes.dart';

class Profile extends GetView<ProfileScreenController> {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColor.bodyColor,
        appBar: const CustomAppbar(title: "My Account"),
        body: !controller.isNetConn.value
            ? const NoInternetConnected()
            : controller.isLoading.value
                ? const PageLoader()
                : Column(
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: CircleAvatar(
                          radius: 44.5,
                          backgroundColor: Colors.white,
                          backgroundImage: controller.userProfile != null &&
                                  controller.userProfile['image_base64'] != null
                              ? MemoryImage(
                                  base64Decode(
                                      controller.userProfile['image_base64']),
                                )
                              : null,
                          child: controller.userProfile == null ||
                                  controller.userProfile['image_base64'] == null
                              ? const Icon(Icons.person,
                                  size: 44, color: Colors.blueAccent)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      controller.userProfile != null &&
                              controller.userProfile['first_name'] != null
                          ? CustomTitle(
                              text:
                                  '${controller.userProfile['first_name']} ${controller.userProfile['last_name']}',
                              color: Colors.black,
                              fontSize: 18,
                              fontStyle: FontStyle.normal,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.408,
                            )
                          : Container(
                              color: AppColor.primaryColor,
                              width: double.infinity,
                              padding: const EdgeInsets.all(16.0),
                              // child: const Text(
                              //   'Update your Account',
                              //   style: TextStyle(
                              //     color: Colors.white,
                              //     fontSize: 16,
                              //     fontWeight: FontWeight.w700,
                              //   ),
                              //   textAlign: TextAlign.center,
                              // ),
                              child: const CustomTitle(
                                text: "Update your Account",
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                textAlign: TextAlign.center,
                                letterSpacing: -0.408,
                              ),
                            ),
                      const SizedBox(height: 10),
                      if (controller.userProfile != null &&
                          controller.userProfile['first_name'] != null)
                        Container(
                          padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
                          height: 140,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/wallet_bg.png"),
                                fit: BoxFit.fill),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomTitle(
                                      text: "Invite Friends",
                                      color: Colors.white,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.408,
                                    ),
                                    const SizedBox(height: 5),
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                "Invite your friends for easier booking experiences and get ",
                                            style: TextStyle(
                                              color: Colors.white60,
                                              fontStyle: FontStyle.normal,
                                              letterSpacing: -0.408,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "reward points",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
                                              letterSpacing: -0.408,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " each",
                                            style: TextStyle(
                                              color: Colors.white60,
                                              fontStyle: FontStyle.normal,
                                              letterSpacing: -0.408,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Reward Points: ',
                                              style: paragraphStyle(
                                                color: const Color(0xFFF4FAFF),
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: -0.408,
                                                fontSize: 12,
                                              ),
                                            ),
                                            TextSpan(
                                              text: toCurrencyString(controller
                                                  .userData[0]["points_bal"]
                                                  .toString()),
                                              style: paragraphStyle(
                                                color: const Color(0xFFF4FAFF),
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: -0.408,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(
                                flex: 1,
                                child: Center(
                                  child: Icon(
                                    Iconsax.user_add,
                                    color: Colors.white,
                                    size: 42,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Container(height: 20),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            ListTile(
                              leading: const Icon(Iconsax.personalcard,
                                  color: Color(0xFF1C1C1E)),
                              title: const CustomTitle(
                                text: "My Profile",
                                fontSize: 14,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.408,
                                color: Color(0xFF1C1C1E),
                              ),
                              trailing: const Icon(Icons.chevron_right_sharp,
                                  color: Color(0xFF1C1C1E)),
                              onTap: () {
                                Get.toNamed(Routes.myaccount);
                              },
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Iconsax.shield_tick,
                                  color: Color(0xFF1C1C1E)),
                              title: const CustomTitle(
                                text: "Security Settings",
                                fontSize: 14,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.408,
                                color: Color(0xFF1C1C1E),
                              ),
                              trailing: const Icon(Icons.chevron_right_sharp,
                                  color: Color(0xFF1C1C1E)),
                              onTap: () {
                                Get.toNamed(Routes.security);
                              },
                            ),
                            const Divider(),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
