import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_body.dart';
import 'package:luvpark_get/custom_widgets/custom_button.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/custom_textfield.dart';
import 'package:luvpark_get/custom_widgets/variables.dart';
import 'package:luvpark_get/custom_widgets/vertical_height.dart';
import 'package:luvpark_get/login/controller.dart';
import 'package:luvpark_get/routes/routes.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> formKeyLogin = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final LoginScreenController ct = Get.put(LoginScreenController());

    return PopScope(
      canPop: false,
      child: CustomScaffold(
        bodyColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        children: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 15, 20),
          child: Form(
            key: formKeyLogin,
            child: StretchingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomTitle(
                      text: "Login",
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -.1,
                    ),
                    Container(height: 10),
                    const CustomParagraph(
                        text:
                            "Please enter your mobile number and password to login"),
                    const VerticalHeight(height: 30),
                    const CustomTitle(
                      text: "Mobile Number",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -.1,
                      wordspacing: 4,
                    ),
                    CustomMobileNumber(
                      labelText: "10 digit mobile number",
                      controller: ct.mobileNumber,
                      inputFormatters: [Variables.maskFormatter],
                    ),
                    const VerticalHeight(height: 5),
                    const CustomTitle(
                      text: "Password",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -.1,
                      wordspacing: 2,
                    ),
                    Obx(
                      () => CustomTextField(
                        title: "Password",
                        labelText: "Enter your password",
                        controller: ct.password,
                        isObscure: ct.isShowPass.value,
                        suffixIcon: ct.isShowPass.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onIconTap: () {
                          ct.visibilityChanged(!ct.isShowPass.value);
                        },
                      ),
                    ),
                    const VerticalHeight(height: 30),
                    Obx(() => CustomButton(
                        loading: ct.isLoading.value,
                        text: "Log in",
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (ct.isLoading.value) return;
                          ct.toggleLoading(!ct.isLoading.value);

                          if (ct.mobileNumber.text.isEmpty) {
                            ct.toggleLoading(!ct.isLoading.value);
                            CustomDialog().snackbarDialog(
                                context, "Mobile number is empty");
                            return;
                          }
                          if (ct.password.text.isEmpty) {
                            ct.toggleLoading(!ct.isLoading.value);
                            CustomDialog()
                                .snackbarDialog(context, "Password is empty");
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

                              ct.postLogin(context, postParam, (data) {
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
