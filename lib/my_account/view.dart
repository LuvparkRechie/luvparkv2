import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/page_loader.dart';
import 'package:luvpark_get/custom_widgets/variables.dart';
import 'package:luvpark_get/my_account/controller.dart';

import '../custom_widgets/no_data_found.dart';

class MyAccount extends GetView<MyAccountScreenController> {
  const MyAccount({Key? key}) : super(key: key);

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
            : Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/profile_bg.png"),
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
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
                              const CustomTitle(
                                text: "My Profile",
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
                          const SizedBox(height: 20),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2.0),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: CircleAvatar(
                                  radius: 44.5,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      controller.myprofile.value.isNotEmpty
                                          ? MemoryImage(
                                              base64Decode(
                                                  controller.myprofile.value),
                                            )
                                          : null,
                                  child: controller.myprofile.value.isEmpty
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
                          controller.userData.isNotEmpty &&
                                  controller.userData[0]['first_name'] != null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomTitle(
                                      text:
                                          '${controller.userData[0]['first_name']} ${controller.userData[0]['last_name']}',
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontStyle: FontStyle.normal,
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.408,
                                    ),
                                    Container(width: 5),
                                    const Icon(
                                      Icons.verified,
                                      color: Colors.white,
                                    )
                                  ],
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
                          CustomParagraph(
                            text: "+${controller.userData[0]['mobile_no']}",
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(height: 15),
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
                          Container(height: 24),
                          Row(
                            children: [
                              CustomTitle(
                                text: "Personal Details",
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColor.primaryColor,
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  controller.getRegions();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColor.primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(
                                    child:
                                        CustomLinkLabel(text: "Edit Profile"),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(height: 20),
                          Expanded(
                            child: controller.userData[0]['first_name'] == null
                                ? const NoDataFound(
                                    text:
                                        "No personal data to be displayed. \nplease update your profile.",
                                  )
                                : StretchingOverscrollIndicator(
                                    axisDirection: AxisDirection.down,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const CustomParagraph(
                                                      text: "Civil Status",
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                    Container(height: 5),
                                                    CustomParagraph(
                                                      text: controller
                                                          .civilStatus.value,
                                                    ),
                                                    Divider(
                                                      color:
                                                          Colors.grey.shade500,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const CustomParagraph(
                                                      text: "Gender",
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                    Container(height: 5),
                                                    CustomParagraph(
                                                        text: controller
                                                            .gender.value),
                                                    Divider(
                                                      color:
                                                          Colors.grey.shade500,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(height: 10),
                                          const CustomParagraph(
                                            text: "Birthday",
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                          Container(height: 5),
                                          CustomParagraph(
                                              text: Variables.convertBday(
                                                  controller.userData[0]
                                                      ['birthday'])),
                                          Divider(
                                            color: Colors.grey.shade500,
                                          ),
                                          Container(height: 10),
                                          const CustomParagraph(
                                            text: "Address",
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                          Container(height: 5),
                                          CustomParagraph(
                                              text:
                                                  "${controller.userData[0]['address'] ?? "No adress provided"}"),
                                          Divider(
                                            color: Colors.grey.shade500,
                                          ),
                                          Container(height: 10),
                                          const CustomParagraph(
                                            text: "Province",
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                          Container(height: 5),
                                          CustomParagraph(
                                              text: controller.province.value),
                                          Divider(
                                            color: Colors.grey.shade500,
                                          ),
                                          Container(height: 10),
                                          const CustomParagraph(
                                            text: "Zip Code",
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                          Container(height: 5),
                                          CustomParagraph(
                                              text: controller.userData[0]
                                                      ['zip_code']
                                                  .toString()),
                                          Divider(
                                            color: Colors.grey.shade500,
                                          ),
                                          Container(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
