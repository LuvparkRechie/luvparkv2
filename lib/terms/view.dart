import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_body.dart';
import 'package:luvpark_get/custom_widgets/custom_button.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/terms/controller.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({super.key});

  @override
  Widget build(BuildContext context) {
    final TermsOfUseController controllers = Get.put(TermsOfUseController());
    return CustomScaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const CustomTitle(
          text: "Terms of use",
          fontWeight: FontWeight.bold,
          wordspacing: 4,
        ),
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      bodyColor: Colors.white,
      children: Column(
        children: [
          Expanded(
            child: StretchingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomTitle(
                      text: "Terms of use",
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                    const CustomParagraph(
                      text: "Last updated January 1, 2024",
                      fontSize: 14,
                    ),
                    Container(height: 30),
                    const CustomParagraph(
                      text:
                          "IMPORTANT– please read these terms carefully. By using the Service (as defined below), you agree that you have read,"
                          " understood, accepted and agreed with the Terms of Service. You further agree to the "
                          "representations made by yourself below.",
                      fontSize: 14,
                    ),
                    Container(height: 20),
                    const CustomParagraph(
                      text:
                          "If you do not agree to or fall within the Terms of Use of the Service and wish to discontinue using the"
                          " Service, please do not continue using the Application (as defined below) or the Service.",
                      fontSize: 14,
                    ),
                    Container(height: 20),
                    const CustomParagraph(
                      text:
                          "1. Acceptance to LUVPARK Service Terms together with the Privacy Policy and all other additional terms and"
                          " information that may be provided within the Service (collectively “Terms”) govern your use of the service, "
                          "site,content and software (collectively the “Service”). By registering for or using the Service or any portion"
                          " of it you accept the Terms. The Terms constitute an agreement between you and CLEVER MINDS DIGITAL SOLUTIONS INC.",
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          Obx(
            () => Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          controllers.onPageChanged(!controllers.isAgree.value);
                        },
                        child: Obx(
                          () => Icon(
                            controllers.isAgree.value
                                ? Icons.check_box_outlined
                                : Icons.check_box_outline_blank,
                            color: controllers.isAgree.value
                                ? AppColor.primaryColor
                                : Colors.grey,
                          ),
                        ),
                      ),
                      Container(width: 10),
                      const Expanded(
                          child: CustomParagraph(
                              color: Colors.black,
                              text: "I have read and agree to terms of use"))
                    ],
                  ),
                  Container(height: 20),
                  CustomButton(
                      text: "Continue",
                      btnColor: controllers.isAgree.value
                          ? AppColor.primaryColor
                          : Colors.grey,
                      onPressed: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dialogBody() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    );
  }
}
