// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_button.dart';
import 'package:luvpark_get/custom_widgets/custom_textfield.dart';
import 'package:luvpark_get/wallet/controller.dart';
import '../../custom_widgets/custom_text.dart';

class WalletTransactionFilter extends GetView<WalletController> {
  const WalletTransactionFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              decoration: BoxDecoration(
                color: AppColor.bodyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Form(
                key: controller.formKeyFilter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTitle(
                          text: "Transaction Period",
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(Icons.close),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTitle(text: "Start Date"),
                    CustomTextField(
                      suffixIcon: Iconsax.calendar_1,
                      onTap: () {
                        controller.selectDate(context, true);
                      },
                      onIconTap: () {
                        controller.selectDate(context, true);
                      },
                      isReadOnly: true,
                      labelText: "From",
                      controller: controller.fromDate,
                    ),
                    CustomTitle(text: "End Date"),
                    CustomTextField(
                      suffixIcon: Iconsax.calendar_1,
                      onTap: () {
                        controller.selectDate(context, false);
                      },
                      onIconTap: () {
                        controller.selectDate(context, false);
                      },
                      isReadOnly: true,
                      labelText: "To",
                      controller: controller.toDate,
                    ),
                    CustomButton(
                      text: "Apply",
                      onPressed: () {
                        controller.applyFilter();
                      },
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
