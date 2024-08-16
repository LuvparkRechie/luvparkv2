// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_appbar.dart';
import 'package:luvpark_get/custom_widgets/custom_body.dart';
import 'package:luvpark_get/custom_widgets/custom_button.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';

import '../custom_widgets/custom_textfield.dart';
import '../custom_widgets/variables.dart';
import 'controller.dart';

class WalletRechargeLoadScreen extends GetView<WalletRechargeLoadController> {
  const WalletRechargeLoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      children: Form(
        key: controller.page1Key,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          children: [
            CustomAppbar(
              title: "Load",
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTitle(
                      textAlign: TextAlign.start,
                      text: 'Payment Method',
                      fontSize: 15,
                      color: Colors.black87,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        for (int index = 0;
                            index < controller.bankPartner.length;
                            index++)
                          Obx(
                            () => Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: InkWell(
                                onTap: () {
                                  controller.onSelectBank(index);
                                },
                                child: Container(
                                  height: 70,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            controller.selectedBankType.value ==
                                                    null
                                                ? Colors.black12
                                                : controller.selectedBankType
                                                            .value ==
                                                        index
                                                    ? AppColor.primaryColor
                                                    : Colors.black12),
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFFffffff),
                                    image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: AssetImage(controller
                                          .bankPartner[index]["img_url"]),
                                    ),
                                  ),
                                  child: Stack(children: [
                                    Align(
                                      alignment: const Alignment(1.0, 1.0),
                                      child: controller
                                                  .selectedBankType.value ==
                                              null
                                          ? SizedBox()
                                          : controller.selectedBankType.value ==
                                                  index
                                              ? const Icon(
                                                  Icons.check_circle_outline,
                                                  color: Colors.green,
                                                  size: 25,
                                                )
                                              : const SizedBox(),
                                    )
                                  ]),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CustomTitle(
                      textAlign: TextAlign.start,
                      text: 'Top-up account',
                      fontSize: 15,
                      color: Colors.black87,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFffffff),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTitle(text: "Recipient Number"),
                            CustomMobileNumber(
                              labelText: "Mobile No",
                              controller: controller.mobileNo,
                              inputFormatters: [Variables.maskFormatter],
                              onChange: (value) {
                                // setState(() {
                                //   isActiveBtn = false;
                                // });
                                // _onSearchChanged(
                                //     value.replaceAll(" ", ""), false);
                                // //  onChangeText();
                              },
                            ),
                            CustomTitle(text: "Recipient Name"),
                            CustomTextField(
                              isReadOnly: true,
                              controller: controller.rname,
                              labelText: "Recipient Name",
                            ),
                            CustomTitle(text: "Amount"),
                            CustomTextField(
                              isReadOnly: true,
                              controller: controller.amountController,
                              labelText: "Amount",
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      text: "Pay Now",
                      onPressed: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        if (controller.page1Key.currentState!.validate()) {
                          controller.onPay();
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
