import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_button.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/custom_textfield.dart';
import 'package:luvpark_get/custom_widgets/variables.dart';
import 'package:luvpark_get/custom_widgets/vertical_height.dart';
import 'package:luvpark_get/login/controller.dart';
import 'package:luvpark_get/routes/routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginScreenController ct = Get.put(LoginScreenController());

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          elevation: 0,
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColor.primaryColor,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        body: Container(
          color: AppColor.primaryColor,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30))),
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 20),
            child: Form(
              key: ct.formKeyLogin,
              child: StretchingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage("assets/images/onboardluvpark.png"),
                          width: 189,
                          fit: BoxFit.contain,
                        ),
                        Image(
                          image: const AssetImage("assets/images/onboard5.png"),
                          width: MediaQuery.of(Get.context!).size.width * .80,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                        const CustomTitle(
                          text: "Login",
                          color: Colors.black,
                          maxlines: 1,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          textAlign: TextAlign.center,
                          letterSpacing: -.1,
                        ),
                        Container(height: 10),
                        const Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const CustomParagraph(
                              textAlign: TextAlign.center,
                              text:
                                  "Please enter your mobile number and password to login"),
                        ),
                        const VerticalHeight(height: 30),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: CustomTitle(
                            text: "Mobile Number",
                            fontWeight: FontWeight.bold,
                            letterSpacing: -.1,
                            wordspacing: 4,
                          ),
                        ),
                        CustomMobileNumber(
                          labelText: "10 digit mobile number",
                          controller: ct.mobileNumber,
                          inputFormatters: [Variables.maskFormatter],
                        ),
                        const VerticalHeight(height: 5),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: CustomTitle(
                            text: "Password",
                            fontWeight: FontWeight.bold,
                            letterSpacing: -.1,
                            wordspacing: 2,
                          ),
                        ),
                        Obx(
                          () => CustomTextField(
                            title: "Password",
                            labelText: "Enter your password",
                            controller: ct.password,
                            isObscure: !ct.isShowPass.value,
                            suffixIcon: ct.isShowPass.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            onIconTap: () {
                              ct.visibilityChanged(!ct.isShowPass.value);
                            },
                          ),
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: CustomParagraph(
                                color: AppColor.primaryColor,
                                text: "Forgot password")),
                        const SizedBox(
                          height: 20,
                        ),
                        if (MediaQuery.of(context).viewInsets.bottom == 0)
                          Column(
                            children: [
                              Obx(() => CustomButton(
                                  loading: ct.isLoading.value,
                                  text: "Log in",
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    if (ct.isLoading.value) return;
                                    ct.toggleLoading(!ct.isLoading.value);

                                    if (ct.mobileNumber.text.isEmpty) {
                                      ct.toggleLoading(!ct.isLoading.value);
                                      CustomDialog().snackbarDialog(context,
                                          "Mobile number is empty", Colors.red);
                                      return;
                                    }
                                    if (ct.password.text.isEmpty) {
                                      ct.toggleLoading(!ct.isLoading.value);
                                      CustomDialog().snackbarDialog(context,
                                          "Password is empty", Colors.red);
                                      return;
                                    }
                                    ct.getAccountStatus(context,
                                        "63${ct.mobileNumber.text.toString().replaceAll(" ", "")}",
                                        (obj) {
                                      final items = obj[0]["items"];

                                      if (items.isEmpty) {
                                        ct.toggleLoading(!ct.isLoading.value);
                                        return;
                                      }

                                      if (items[0]["is_active"] == "N") {
                                        ct.toggleLoading(!ct.isLoading.value);
                                        CustomDialog().confirmationDialog(
                                            context,
                                            "Information",
                                            "Your account is currently inactive. Would you like to activate it now?",
                                            "No",
                                            "Yes", () {
                                          Get.back();
                                        }, () {
                                          Get.back();
                                        });
                                      } else {
                                        Map<String, dynamic> postParam = {
                                          "mobile_no":
                                              "63${ct.mobileNumber.text.toString().replaceAll(" ", "")}",
                                          "pwd": ct.password.text,
                                        };

                                        ct.postLogin(context, postParam,
                                            (data) {
                                          ct.toggleLoading(!ct.isLoading.value);

                                          if (data[0]["items"].isNotEmpty) {
                                            Get.offAndToNamed(Routes.map);
                                          }
                                        });
                                      }
                                    });
                                  })),
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
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
