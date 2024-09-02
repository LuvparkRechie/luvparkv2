import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_appbar.dart';
import 'package:luvpark_get/custom_widgets/custom_button.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/custom_textfield.dart';
import 'package:luvpark_get/custom_widgets/page_loader.dart';
import 'package:luvpark_get/my_account/utils/controller.dart';

import '../../custom_widgets/variables.dart';

class UpdateProfile extends GetView<UpdateProfileController> {
  const UpdateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const PageLoader()
          : Scaffold(
              appBar: CustomAppbar(
                title:
                    controller.currentPage.value == 0 ? "Update Profile" : null,
                onTap: () {
                  if (controller.currentPage.value == 0) {
                    Get.back();
                  } else {
                    FocusScope.of(context).requestFocus(FocusNode());
                    controller.pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  }
                },
              ),
              body: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 20),
                    const CustomTitle(
                      text: "Let's get started!",
                      color: Color.fromARGB(255, 17, 16, 16),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    Container(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: controller.currentPage.value == 0
                                  ? AppColor.primaryColor
                                  : Colors.grey.shade300,
                            ),
                            height: 5,
                          ),
                        ),
                        Container(width: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: controller.currentPage.value == 1
                                  ? AppColor.primaryColor
                                  : Colors.grey.shade300,
                            ),
                            height: 5,
                          ),
                        ),
                        Container(width: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: controller.currentPage.value == 2
                                  ? AppColor.primaryColor
                                  : Colors.grey.shade300,
                            ),
                            height: 5,
                          ),
                        ),
                      ],
                    ),
                    Container(height: 20),
                    Expanded(
                        child: PageView(
                      controller: controller.pageController,
                      onPageChanged: (value) {
                        controller.onPageChanged(value);
                      },
                      children: [step1(), step2(), step3()],
                    )),
                    CustomButton(
                      text: "Next",
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        controller.pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget step1() {
    return StretchingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomTitle(text: "First Name"),
                      CustomTextField(
                        labelText: "First Name",
                        title: "First Name",
                        controller: controller.firstName,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomTitle(text: "Suffix"),
                      CustomDropdown(
                        labelText: "Suffix",
                        ddData: controller.suffixes,
                        ddValue: controller.selectedSuffix.value,
                        onChange: (String? newValue) {
                          controller.selectedSuffix.value = newValue;
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            const CustomTitle(text: "Middle Name"),
            CustomTextField(
              labelText: "Middle Name",
              title: "Middle Name",
              controller: controller.middleName,
            ),
            const CustomTitle(text: "Last Name"),
            CustomTextField(
              labelText: "Last Name",
              title: "Last Name",
              controller: controller.lastName,
            ),
            const CustomTitle(text: "Email"),
            CustomTextField(
              labelText: "Email",
              title: "Email",
              controller: controller.email,
            ),
            const CustomTitle(text: "Birthday"),
            CustomTextField(
              labelText: "Birthday",
              title: "Birthday",
              controller: controller.bday,
            ),
            Container(height: 10),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    controller.gender.value = "M";
                  },
                  child: Row(
                    children: [
                      Icon(
                        controller.gender.value == "M"
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: controller.gender.value == "M"
                            ? AppColor.primaryColor
                            : Colors.grey.shade400,
                      ),
                      Container(width: 5),
                      const CustomParagraph(text: "Male", color: Colors.black)
                    ],
                  ),
                ),
                Container(width: 10),
                InkWell(
                  onTap: () {
                    controller.gender.value = "F";
                  },
                  child: Row(
                    children: [
                      Icon(
                        controller.gender.value == "F"
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: controller.gender.value == "F"
                            ? AppColor.primaryColor
                            : Colors.grey.shade400,
                      ),
                      Container(width: 5),
                      const CustomParagraph(
                        text: "Female",
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.shade200,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomTitle(text: "What's your civil status"),
                    CustomDropdown(
                      labelText: "Civil status",
                      ddData: controller.civilData,
                      ddValue: controller.selectedCivil.value,
                      onChange: (String? newValue) {
                        // controller.selectedCivil.value = newValue!;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget step2() {
    return StretchingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 20),
            const CustomTitle(text: "Region"),
            CustomDropdown(
              labelText: "Region",
              ddData: controller.regionData,
              ddValue: controller.selectedRegion.value,
              onChange: (data) {
                controller.selectedRegion.value = data.toString();
                controller.getProvinceData(data);
              },
            ),
            const CustomTitle(text: "Province"),
            CustomDropdown(
              labelText: "Province",
              ddData: controller.provinceData,
              ddValue: controller.selectedProvince.value,
              onChange: (data) {
                controller.selectedProvince.value = data.toString();
                controller.getCityData(data);
              },
            ),
            const CustomTitle(text: "City"),
            CustomDropdown(
              labelText: "City",
              ddData: controller.cityData,
              ddValue: controller.selectedCity.value,
              onChange: (data) {
                controller.selectedCity.value = data.toString();
                controller.getBrgyData(data);
              },
            ),
            const CustomTitle(text: "Brgy"),
            CustomDropdown(
              labelText: "Brgy",
              ddData: controller.brgyData,
              ddValue: controller.selectedBrgy.value,
              onChange: (data) {
                controller.selectedBrgy.value = data.toString();
              },
            ),
            const CustomTitle(text: "Address1"),
            CustomTextField(
              labelText: 'House No./Bldg (optional)',
              controller: controller.address1,
              onChange: (value) {
                if (value.isNotEmpty) {
                  controller.address1.value = TextEditingValue(
                      text: Variables.capitalizeAllWord(value),
                      selection: controller.address1.selection);
                }
              },
            ),
            const CustomTitle(text: "Zip Code"),
            CustomTextField(
              labelText: 'Zip Code',
              controller: controller.zipCode,
              keyboardType: TextInputType.number,
              onChange: (value) {},
            ),
            Container(height: 10),
          ],
        ),
      ),
    );
  }

  Widget step3() {
    return Text("3");
  }
}
