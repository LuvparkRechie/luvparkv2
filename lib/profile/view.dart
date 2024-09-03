import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/page_loader.dart';
import 'package:luvpark_get/profile/controller.dart';
import 'package:luvpark_get/routes/routes.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class Profile extends GetView<ProfileScreenController> {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          toolbarHeight: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        body: controller.isLoading.value
            ? const PageLoader()
            : Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/profile_bg.png"),
                          ),
                        ),
                        child: SafeArea(
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.chevron_left,
                                              color: Colors.white,
                                            ),
                                            CustomParagraph(
                                              text: "Back",
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const CustomTitle(
                                        text: "My Account",
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Icon(
                                          Icons.more_vert,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 120),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          color: AppColor.bodyColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(height: 50),
                              controller.userData.isNotEmpty &&
                                      controller.userData[0]['first_name'] !=
                                          null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomTitle(
                                          text:
                                              '${controller.userData[0]['first_name']} ${controller.userData[0]['last_name']}',
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontStyle: FontStyle.normal,
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: -0.408,
                                        ),
                                        Container(width: 5),
                                        Icon(
                                          Icons.verified,
                                          color: AppColor.primaryColor,
                                        )
                                      ],
                                    )
                                  : const Center(
                                      child: CustomTitle(
                                        text: "Not Verified",
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        textAlign: TextAlign.center,
                                        letterSpacing: -0.408,
                                      ),
                                    ),
                              Center(
                                child: CustomParagraph(
                                  text:
                                      "+${controller.userData[0]['mobile_no']}",
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white38,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ListView(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(10.0),
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(
                                        Iconsax.personalcard,
                                        color: AppColor.primaryColor,
                                      ),
                                      title: const CustomTitle(
                                        text: "My Account",
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.408,
                                        color: Color(0xFF1C1C1E),
                                      ),
                                      trailing: Icon(Icons.chevron_right_sharp,
                                          color: AppColor.primaryColor),
                                      onTap: () {
                                        Get.toNamed(Routes.myaccount);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Iconsax.security,
                                        color: AppColor.primaryColor,
                                      ),
                                      title: const CustomTitle(
                                        text: "Security Settings",
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.408,
                                        color: Color(0xFF1C1C1E),
                                      ),
                                      trailing: Icon(Icons.chevron_right_sharp,
                                          color: AppColor.primaryColor),
                                      onTap: () {
                                        Get.toNamed(Routes.security);
                                      },
                                    ),
                                    // Add more ListTiles here if needed
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 165,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.bodyColor,
                      ),
                      child: CircleAvatar(
                        radius: 44.5,
                        backgroundColor: Colors.white,
                        backgroundImage: controller.myprofile.value.isNotEmpty
                            ? MemoryImage(
                                base64Decode(controller.myprofile.value),
                              )
                            : null,
                        child: controller.myprofile.value.isEmpty
                            ? const Icon(Icons.person,
                                size: 44, color: Colors.blueAccent)
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
