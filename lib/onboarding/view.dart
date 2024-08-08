import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_button.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/onboarding/controller.dart';

import '../custom_widgets/custom_body.dart';
import '../routes/routes.dart';

class MyOnboardingPage extends StatelessWidget {
  const MyOnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OnboardingController controller = Get.put(OnboardingController());
    return CustomScaffold(
      bodyColor: Colors.white,
      children: Padding(
        padding: const EdgeInsets.fromLTRB(15, 38, 15, 10),
        child: GetBuilder<OnboardingController>(builder: (ctxt) {
          return Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .62,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: PageView(
                    controller: controller.pageController,
                    onPageChanged: (value) {
                      controller.onPageChanged(value);
                    },
                    children: List.generate(
                      controller.sliderData.length,
                      (index) => _buildPage(
                        controller.sliderData[index]["title"],
                        controller.sliderData[index]["subTitle"],
                        controller.sliderData[index]["icon"],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                    ),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          controller.sliderData.length,
                          (index) => Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: controller.currentPage.value == index
                                  ? AppColor.primaryColor
                                  : const Color(0xFFD9D9D9),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    CustomButton(
                      text: "Get started",
                      onPressed: () {
                        Get.toNamed(Routes.landing);
                      },
                    ),
                    Container(height: 20),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Already a Luvpark user?",
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                color: AppColor.linkLabel,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: " Log In",
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  Get.toNamed(Routes.login);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildPage(String title, String subTitle, String image) {
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            child: Image(
              image: AssetImage("assets/images/$image.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Center(
          child: CustomTitle(
            text: title,
            maxlines: 1,
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          height: 10,
        ),
        Center(
          child: CustomParagraph(
            text: subTitle,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
