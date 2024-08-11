import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/booking/utils/booking_receipt/controller.dart';
import 'package:luvpark_get/custom_widgets/custom_button.dart';
import 'package:luvpark_get/routes/routes.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../custom_widgets/app_color.dart';
import '../../../custom_widgets/custom_tciket_style.dart';
import '../../../custom_widgets/custom_text.dart';

class BookingReceipt extends GetView<BookingReceiptController> {
  const BookingReceipt({super.key});

  @override
  Widget build(BuildContext context) {
    final BookingReceiptController ct = Get.put(BookingReceiptController());
    return Scaffold(
      backgroundColor: AppColor.bodyColor,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: AppColor.primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColor.primaryColor,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Stack(
                fit: StackFit.loose,
                children: [
                  Container(
                    color: AppColor.primaryColor,
                    height: MediaQuery.of(context).size.height * 0.20,
                  ),
                  Positioned(
                    left: 15,
                    right: 15,
                    top: 5,
                    bottom: 10, // Space for the buttons at the bottom
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildQrSection(),
                            _buildAddressSection(),
                            _buildDetailsSection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      btnColor: Colors.white,
                      textColor: AppColor.primaryColor,
                      bordercolor: AppColor.primaryColor,
                      text: "Find vehicle",
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      text: "Extend parking",
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColor.primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: () {
                    Get.offAndToNamed(Routes.map);
                  },
                ),
                const CustomParagraph(
                  text: "Back",
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          const Flexible(
            flex: 2,
            child: CustomTitle(
              text: "Parking Details",
              color: Colors.white,
              letterSpacing: -0.41,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIconButton(Icons.download),
              const SizedBox(width: 20),
              Expanded(
                child: QrImageView(
                  data: "hi",
                  version: QrVersions.auto,
                  gapless: false,
                ),
              ),
              const SizedBox(width: 20),
              _buildIconButton(Icons.share_outlined),
            ],
          ),
        ),
        const TicketStyle()
      ],
    );
  }

  Widget _buildIconButton(IconData icon) {
    return IconButton(
      icon: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Icon(
            icon,
            color: Colors.black,
          ),
        ),
      ),
      onPressed: () {},
      padding: const EdgeInsets.all(10),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: CustomTitle(
                      text: "SM SOUTH LEFT",
                      fontSize: 20,
                      maxlines: 1,
                      letterSpacing: 0,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset("assets/dashboard_icon/direct_map.png"),
                  ),
                ],
              ),
              const CustomParagraph(
                text:
                    "SM SOUTH MWCV+3HRT Farther M. Ferrs St. Bacolod, 6100 Negros Occidental",
                maxlines: 2,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(
                    child: CustomTitle(
                      text: "4:00PM - 5:00PM",
                      fontSize: 14,
                      letterSpacing: -0.41,
                    ),
                  ),
                  CustomParagraph(
                    text: "45 mins left",
                    fontSize: 14,
                    letterSpacing: -0.41,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ],
          ),
        ),
        const TicketStyle()
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ticketDetailsWidget('Total Token', '20.00', 'Duration', '1 hour'),
          const SizedBox(height: 10),
          ticketDetailsWidget(
            'Date In-Out',
            '2024/06/26 - 2024/06/26',
            'Time In-Out',
            '4:00PM - 5:00PM',
          ),
          const SizedBox(height: 10),
          ticketDetailsWidget(
            'Vehicle',
            'YTX-1245',
            'Reference no.',
            'BCD-234555L',
          ),
        ],
      ),
    );
  }

  Widget ticketDetailsWidget(String firstTitle, String firstDesc,
      String secondTitle, String secondDesc) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomParagraph(text: firstTitle),
              CustomParagraph(
                text: firstDesc,
                color: Colors.black,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomParagraph(text: secondTitle),
              CustomParagraph(
                text: secondDesc,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
