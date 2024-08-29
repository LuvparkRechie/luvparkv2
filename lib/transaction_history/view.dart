import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_appbar.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/routes/routes.dart';
import 'package:luvpark_get/transaction_history/controller.dart';

class TransactionHistory extends GetView<TransactionHistoryController> {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: AppColor.bodyColor,
      appBar: const CustomAppbar(title: "Transaction History"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primaryColor.withOpacity(0.1),
                    ),
                    child: Icon(
                      Iconsax.lock,
                      color: AppColor.primaryColor,
                      size: 20,
                    ),
                  ),
                  title: const CustomTitle(
                    text: "Change Password",
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.408,
                  ),
                  subtitle: const CustomParagraph(
                    text:
                        "Update your current password to ensure your account remains secure.",
                    letterSpacing: -0.408,
                    fontSize: 12,
                  ),
                  trailing: const Icon(Icons.chevron_right_sharp,
                      color: Color(0xFF1C1C1E)),
                  onTap: () {
                    Get.toNamed(Routes.changepassword);
                  },
                ),
                Divider(color: Colors.grey.shade500),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
