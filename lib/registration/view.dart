import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/custom_widgets/custom_button.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/custom_textfield.dart';
import 'package:luvpark_get/custom_widgets/password_indicator.dart';
import 'package:luvpark_get/custom_widgets/variables.dart';
import 'package:luvpark_get/custom_widgets/vertical_height.dart';
import 'package:luvpark_get/registration/controller.dart';
import 'package:luvpark_get/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../custom_widgets/custom_body.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RegistrationController ct = Get.put(RegistrationController());
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
            )),
      ),
      children: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: StretchingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          child: SingleChildScrollView(
            child: GetBuilder<RegistrationController>(builder: (ctxt) {
              return Form(
                key: ct.formKeyRegister,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomTitle(
                      text: "Create Account",
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -.1,
                      wordspacing: 4,
                    ),
                    Container(height: 10),
                    const CustomParagraph(
                        text:
                            "Please complete all input fields to create\nyour account"),
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
                      onChange: (value) {
                        ct.onMobileChanged(value);
                      },
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
                        onChange: (value) {
                          ct.onPasswordChanged(value);
                        },
                      ),
                    ),
                    Container(height: 10),
                    Obx(
                      () => Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color:
                                  Colors.black.withOpacity(0.05999999865889549),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 15, 11, 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomTitle(
                                text: "Password Strength",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -.1,
                                wordspacing: 2,
                              ),
                              Container(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  PasswordStrengthIndicator(
                                    strength: 1,
                                    currentStrength: ct.passStrength.value,
                                  ),
                                  Container(
                                    width: 5,
                                  ),
                                  PasswordStrengthIndicator(
                                    strength: 2,
                                    currentStrength: ct.passStrength.value,
                                  ),
                                  Container(
                                    width: 5,
                                  ),
                                  PasswordStrengthIndicator(
                                    strength: 3,
                                    currentStrength: ct.passStrength.value,
                                  ),
                                  Container(
                                    width: 5,
                                  ),
                                  PasswordStrengthIndicator(
                                    strength: 4,
                                    currentStrength: ct.passStrength.value,
                                  ),
                                ],
                              ),
                              Container(
                                height: 15,
                              ),
                              if (Variables.getPasswordStrengthText(
                                      ct.passStrength.value)
                                  .isNotEmpty)
                                Row(
                                  children: [
                                    Icon(
                                      Icons.shield_moon,
                                      color:
                                          Variables.getColorForPasswordStrength(
                                              ct.passStrength.value),
                                      size: 18,
                                    ),
                                    Container(
                                      width: 6,
                                    ),
                                    CustomParagraph(
                                      text: Variables.getPasswordStrengthText(
                                          ct.passStrength.value),
                                      color:
                                          Variables.getColorForPasswordStrength(
                                              ct.passStrength.value),
                                    ),
                                  ],
                                ),
                              Container(
                                height: 10,
                              ),
                              const CustomParagraph(
                                text:
                                    "The password should have a minimum of 8 characters, including at least one uppercase letter and a number.",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    CustomButton(
                      text: "Submit",
                      loading: ct.isLoading.value,
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (ct.formKeyRegister.currentState!.validate()) {
                          if (Variables.getPasswordStrengthText(
                                  ct.passStrength.value) !=
                              "Strong Password") {
                            CustomDialog().snackbarDialog(
                                context,
                                'For enhanced security, please create a stronger password.',
                                Colors.red);
                            return;
                          }
                          if (ct.isLoading.value) return;
                          ct.toggleLoading(!ct.isLoading.value);
                          Map<String, dynamic> parameters = {
                            "mobile_no":
                                "63${ct.mobileNumber.text.toString().replaceAll(" ", "")}",
                            "pwd": ct.password.text,
                          };
                          ct.onSubmit(context, parameters, (data) async {
                            ct.toggleLoading(!ct.isLoading.value);
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setBool('isLoggedIn', false);
                            Authentication()
                                .setPasswordBiometric(ct.password.text);

                            if (data[0]["success"]) {
                              // ignore: use_build_context_synchronously
                              CustomDialog().successDialog(
                                  context,
                                  "Activate account",
                                  "We have sent an activation code to your mobile number.",
                                  "Continue", () async {
                                Get.back();
                                List argsParam = [
                                  {
                                    "otp":
                                        int.parse(data[0]["items"].toString()),
                                    'mobile_no': parameters["mobile_no"],
                                    "req_type": "VERIFY",
                                    "seq_id": 0,
                                    "seca": "",
                                    "seq_no": 1,
                                    "new_pass": ct.password.text,
                                  }
                                ];
                                ct.formKeyRegister.currentState?.reset();
                                Get.toNamed(Routes.otp, arguments: argsParam);
                              });
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
