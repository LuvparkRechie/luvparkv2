import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_body.dart';
import 'package:luvpark_get/custom_widgets/custom_button.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/landing/controller.dart';
import 'package:luvpark_get/routes/routes.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LandingController controllers = Get.put(LandingController());
    return PopScope(
      canPop: false,
      child: CustomScaffold(
        bodyColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 24,
          backgroundColor: Colors.white,
        ),
        children: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 80, 15, 0),
                child: Column(
                  children: [
                    const Center(
                      child: CustomTitle(
                        text: "Get started with\nLuvPark Parking",
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        wordspacing: 5,
                      ),
                    ),
                    Container(
                      height: 15,
                    ),
                    const CustomParagraph(
                      text:
                          "Get started with LuvPark Parking for a hassle-free experience."
                          "Quickly find and reserve parking spots with ease, making your travels smoother and stress-free.",
                      textAlign: TextAlign.center,
                      fontSize: 14,
                    ),
                    Container(
                      height: 24,
                    ),
                    const Image(
                      image: AssetImage("assets/images/terms.png"),
                    )
                  ],
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
                            controllers
                                .onPageChanged(!controllers.isAgree.value);
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
                        Expanded(
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Row(
                                      children: [
                                        const CustomParagraph(
                                          text: "Agree with",
                                          wordspacing: 2,
                                          color: Colors.black,
                                          maxlines: 1,
                                        ),
                                        Container(width: 5),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Get.offAllNamed(Routes.terms);
                                            },
                                            child: const CustomLinkLabel(
                                              text: "luvpark's Terms of use",
                                              wordspacing: 2,
                                              maxlines: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(height: 20),
                    CustomButton(
                        text: "Continue",
                        btnColor: controllers.isAgree.value
                            ? AppColor.primaryColor
                            : Colors.grey,
                        onPressed: !controllers.isAgree.value
                            ? () {}
                            : () {
                                Get.offAllNamed(Routes.registration,
                                    arguments: controllers.isAgree.value);
                              }),
                  ],
                ),
              ),
            ),
            Container(height: 24),
          ],
        ),
      ),
    );
  }
}
