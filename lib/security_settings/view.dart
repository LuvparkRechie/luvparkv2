import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_appbar.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/security_Settings/controller.dart';

class Security extends GetView<SecuritySettingsController> {
  const Security({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Obx(
      () => Scaffold(
        backgroundColor: AppColor.bodyColor,
        appBar: const CustomAppbar(title: "My Profile"),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
              height: 140,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/wallet_bg.png"),
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
                      // Get.offAndToNamed(Routes.parking);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
