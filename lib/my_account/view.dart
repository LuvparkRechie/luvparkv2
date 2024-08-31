import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/my_account/controller.dart';

class MyAccount extends GetView<MyAccountScreenController> {
  const MyAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.bodyColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(236),
        child: Obx(() {
          // Check if userProfile is not null and has the necessary keys
          final userProfile = controller.userProfile;
          return AppBar(
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () {
                  // Handle more actions here
                },
                icon: const Icon(Iconsax.more, size: 20),
              ),
            ],
            leading: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
            ),
            leadingWidth: 100,
            title: const CustomTitle(
              text: "My Profile",
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.41,
            ),
            centerTitle: true,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light,
            ),
            flexibleSpace: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: AppColor.bodyColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/profile_bg.png"),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(height: 50),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // CircleAvatar with border
                          Container(
                            padding: const EdgeInsets.all(2.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: CircleAvatar(
                              radius: 44.5,
                              backgroundColor: Colors.white,
                              backgroundImage: userProfile['image_base64'] !=
                                      null
                                  ? MemoryImage(
                                      base64Decode(userProfile['image_base64']),
                                    )
                                  : null,
                              child: userProfile['image_base64'] == null
                                  ? const Icon(Icons.person,
                                      size: 44, color: Colors.blueAccent)
                                  : null,
                            ),
                          ),
                          // Edit button
                          Positioned(
                            right: -4,
                            top: 10,
                            child: GestureDetector(
                              onTap: () {
                                // Handle the image change logic here
                              },
                              child: SvgPicture.asset(
                                'assets/drawer_icon/editpicture.svg',
                                height: 24,
                                width: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      userProfile['first_name'] != null
                          ? CustomTitle(
                              text:
                                  '${userProfile['first_name']} ${userProfile['last_name']}',
                              color: Colors.white,
                              fontSize: 18,
                              fontStyle: FontStyle.normal,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.408,
                            )
                          : const CustomTitle(
                              text: "Not Verified",
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              textAlign: TextAlign.center,
                              letterSpacing: -0.408,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      body: const Stack(
        children: [],
      ),
    );
  }
}
