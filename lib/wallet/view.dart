import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_body.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/wallet/controller.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final WalletController ct = Get.put(WalletController());

    return CustomScaffold(
      children: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: CustomTitle(
                    text: "My Wallet",
                    fontSize: 20,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Iconsax.clock,
                      color: AppColor.primaryColor,
                      size: 18,
                    ),
                    Container(width: 5),
                    const CustomParagraph(text: "Filter")
                  ],
                )
              ],
            ),
            Container(height: 15),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomParagraph(text: "Current Balance"),
                              SizedBox(height: 5),
                              CustomTitle(
                                text: "120.00",
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Container(width: 30),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppColor.primaryColor.withOpacity(.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.card_add,
                                color: AppColor.primaryColor,
                              ),
                              Container(width: 10),
                              const CustomParagraph(
                                text: "Recharge",
                                fontSize: 14,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(height: 20),
                    Row(
                      children: [
                        const Icon(
                          Iconsax.gift,
                          size: 15,
                          color: Colors.pink,
                        ),
                        Container(width: 5),
                        const Flexible(
                            child: CustomParagraph(
                          text: "100.00",
                          fontSize: 12,
                          color: Colors.black,
                        )),
                        Container(width: 5),
                        const Flexible(
                          child: CustomParagraph(
                            text: "Rewards",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(height: 5),
            Container(height: 15),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.send_2,
                        color: AppColor.primaryColor,
                      ),
                      Container(width: 5),
                      const CustomParagraph(text: "Send")
                    ],
                  ),
                ),
                Container(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.qrcode_viewfinder,
                        color: AppColor.primaryColor,
                      ),
                      Container(width: 5),
                      const CustomParagraph(text: "QR")
                    ],
                  ),
                ),
              ],
            ),
            Container(height: 30),
            Row(
              children: [
                const Expanded(
                  child: CustomTitle(
                    text: "Transaction History",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CustomParagraph(
                  text: "See all",
                  fontSize: 14,
                  color: AppColor.primaryColor,
                )
              ],
            ),
            Container(height: 15),
            Expanded(
              child: StretchingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const CustomTitle(
                        text: "Pay Parking",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      subtitle: const CustomParagraph(
                        text: "Aug 16,1998 10:30 AM",
                        fontSize: 12,
                      ),
                      trailing: Icon(
                        CupertinoIcons.chevron_right,
                        size: 14,
                        color: AppColor.primaryColor,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    endIndent: 1,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
