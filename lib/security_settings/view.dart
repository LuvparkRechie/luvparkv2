import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_appbar.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/routes/routes.dart';
import 'package:luvpark_get/security_Settings/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Security extends GetView<SecuritySettingsController> {
  const Security({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: AppColor.bodyColor,
      appBar: const CustomAppbar(title: ""),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primaryColor.withOpacity(0.1),
                    ),
                    child: Center(
                      child: Icon(
                        Iconsax.shield_tick,
                        color: AppColor.primaryColor,
                        size: 55,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTitle(
                    text: "Security Settings",
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.408,
                    color: Color(0xFF1C1C1E),
                  ),
                ],
              ),
              Container(height: 20),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primaryColor.withOpacity(0.1),
                    ),
                    child: Icon(
                      Iconsax.lock,
                      color: AppColor.primaryColor,
                      size: 20,
                    ),
                  ),
                  title: const CustomTitle(
                    text: "Change Password",
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.408,
                  ),
                  subtitle: const CustomParagraph(
                    text:
                        "Update your current password to ensure your account remains secure.",
                    letterSpacing: -0.408,
                    fontSize: 12,
                  ),
                  trailing: const Icon(Icons.chevron_right_sharp,
                      color: Color(0xFF1C1C1E)),
                  onTap: () {
                    Get.toNamed(Routes.changepassword);
                  },
                ),
                Divider(color: Colors.grey.shade500),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primaryColor.withOpacity(0.1),
                    ),
                    child: Icon(
                      Iconsax.finger_cricle,
                      color: AppColor.primaryColor,
                      size: 20,
                    ),
                  ),
                  title: const CustomTitle(
                    text: "Biometric Authentication",
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.408,
                  ),
                  subtitle: const CustomParagraph(
                    text:
                        "Use your device's biometric for a quick and secure login. (Under maintenance)",
                    letterSpacing: -0.408,
                    fontSize: 12,
                  ),
                  trailing: const Icon(Icons.chevron_right_sharp,
                      color: Color(0xFF1C1C1E)),
                  onTap: () {},
                ),
                Divider(color: Colors.grey.shade500),
              ],
            ),
          ),
          Divider(color: Colors.grey.shade500),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.1),
                ),
                child: const Icon(
                  Iconsax.profile_delete,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              title: const CustomTitle(
                text: "Delete Your Account",
                fontSize: 14,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.408,
              ),
              subtitle: const CustomParagraph(
                text:
                    "Permanently remove your account. All associated data will be erased.",
                letterSpacing: -0.408,
                fontSize: 12,
              ),
              trailing: const Icon(Icons.chevron_right_sharp,
                  color: Color(0xFF1C1C1E)),
              onTap: () {
                CustomDialog().customPopUp(
                  context,
                  "Delete your Account?",
                  "Deleting your account will result in the loss of all your data. You'll be redirected to the account deletion page where you'll receive an SMS containing an OTP code. Our support team will then reach out to you promptly.",
                  "I changed my mind",
                  "Delete my account",
                  btnNotBackgroundColor: Colors.transparent,
                  btnNotTextColor: Colors.red,
                  onTapClose: () {
                    Get.back();
                  },
                  onTapConfirm: () {
                    Get.back();
                    CustomDialog().customPopUp(
                      context,
                      "Notice",
                      "Your account deletion request is now in progress. You'll get a text once it's processed.",
                      "",
                      "Okay",
                      showTwoButtons: false,
                      onTapConfirm: () {
                        //Get.back();
                      },
                    );
                  },
                );
              },
            ),
          ),
          Container(
            height: 10,
          ),
        ],
      ),
    );
  }
}
