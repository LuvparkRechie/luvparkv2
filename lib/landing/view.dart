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
    return CustomScaffold(
      bodyColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 24,
        backgroundColor: Colors.white,
      ),
      children: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: 87,
                height: 38,
                padding: const EdgeInsets.only(
                    top: 7, left: 5, right: 16, bottom: 7),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Colors.black.withOpacity(0.15000000596046448),
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(),
                      child: const Center(child: Icon(Icons.chevron_left)),
                    ),
                    Container(width: 5),
                    const Center(
                      child: Text(
                        'Back',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xBF131313),
                          fontSize: 14,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.41,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                            Get.toNamed(Routes.terms);
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
                              Get.toNamed(Routes.registration,
                                  arguments: controllers.isAgree.value);
                            }),
                ],
              ),
            ),
          ),
          Container(height: 24),
        ],
      ),
    );
  }
}
