import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_body.dart';
import 'package:luvpark_get/custom_widgets/custom_button.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/vertical_height.dart';
import 'package:luvpark_get/otp_screen/controller.dart';
import 'package:luvpark_get/routes/routes.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final OtpController ct = Get.put(OtpController());

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(
        fontSize: 24,
        color: ct.isOtpValid.value ? AppColor.primaryColor : Colors.red,
      ),
      decoration: BoxDecoration(
        border: Border.all(
            color: ct.inputPin.isEmpty
                ? Colors.grey
                : ct.isOtpValid.value
                    ? AppColor.primaryColor
                    : Colors.red,
            width: 2),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
    );
    return CustomScaffold(
      bodyColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black,
          ),
        ),
      ),
      children: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 15, 0),
        child: StretchingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Image(
                        image: AssetImage("assets/images/otp_logo.png"),
                        fit: BoxFit.contain,
                        width: 200,
                        height: 200,
                      ),
                    ),
                    const Center(
                      child: CustomTitle(
                        text: "OTP verification",
                        fontSize: 24,
                      ),
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text:
                                    "We have sent an OTP to your registered\nmobile number",
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: AppColor.paragraphColor,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: " +${ct.paramArgs[0]["mobile_no"]}",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(height: 20),
                Obx(
                  () => Directionality(
                    // Specify direction if desired
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      length: 6,
                      controller: ct.pinController,
                      androidSmsAutofillMethod:
                          AndroidSmsAutofillMethod.smsUserConsentApi,
                      listenForMultipleSmsOnAndroid: true,
                      defaultPinTheme: defaultPinTheme,
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (pin) {
                        if (pin.length == 6) {
                          ct.onInputChanged(pin);
                        }
                      },
                      onChanged: (value) {
                        if (value.isEmpty) {
                          ct.onInputChanged(value);
                        } else {
                          ct.onInputChanged(value);
                        }
                      },
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 9),
                            width: 22,
                            height: 1,
                            color: AppColor.primaryColor,
                          ),
                        ],
                      ),
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: AppColor.primaryColor, width: 2),
                        ),
                      ),
                      submittedPinTheme: defaultPinTheme.copyWith(
                        // textStyle: TextStyle(
                        //   fontSize: 24,
                        //   color: ct.isOtpValid.value
                        //       ? AppColor.primaryColor
                        //       : ct.inputPin.value.length < 6 ||
                        //               ct.inputPin.value.isEmpty
                        //           ? AppColor.secondaryColor
                        //           : Colors.red,
                        // ),
                        decoration: defaultPinTheme.decoration!.copyWith(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColor.bodyColor,
                          border: Border.all(
                              color: ct.isOtpValid.value
                                  ? AppColor.primaryColor
                                  : ct.inputPin.value.length < 6 ||
                                          ct.inputPin.value.isEmpty
                                      ? Colors.grey
                                      : Colors.red,
                              width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
                const VerticalHeight(height: 30),
                Obx(
                  () => CustomButton(
                    loading: ct.isLoading.value,
                    text: "Verify",
                    onPressed: () {
                      print("tast ${ct.paramArgs}");
                    },
                  ),
                ),
                Container(
                  height: 20,
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account?",
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: AppColor.linkLabel,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: " Register",
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              Get.toNamed(Routes.landing);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
