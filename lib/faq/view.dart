import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_appbar.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/no_data_found.dart';
import 'package:luvpark_get/custom_widgets/no_internet.dart';
import 'package:luvpark_get/custom_widgets/page_loader.dart';
import 'package:luvpark_get/faq/controller.dart';

class FaqPage extends GetView<FaqPageController> {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor:
              controller.isLoadingPage.value ? null : AppColor.primaryColor,
          // appBar: const PreferredSize(
          //   preferredSize: Size.fromHeight(236),
          //   child: FaqsAppbar(),
          // ),
          body: controller.isLoadingPage.value
              ? const PageLoader()
              : Column(
                  children: [
                    Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/faq_frame.png"),
                        ),
                      ),
                      child: Column(
                        children: [
                          CustomAppbar(
                            elevation: 0,
                            bgColor: Colors.transparent,
                            textColor: Colors.white,
                            titleColor: Colors.white,
                            title: "FAQ's",
                          ),
                          Container(height: 20),
                          CustomTitle(
                            text: "How can we help you?",
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10))),
                        child: !controller.isNetConn.value
                            ? NoInternetConnected(
                                onTap: controller.refresher,
                              )
                            : controller.faqsData.isEmpty
                                ? NoDataFound()
                                : ListView.separated(
                                    itemCount: controller.faqsData.length,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      color: Colors.grey[800],
                                      height: 1,
                                    ),
                                    itemBuilder: (context, index) {
                                      var faq = controller.faqsData[index];

                                      return ExpansionTile(
                                        title: CustomParagraph(
                                          text: faq['faq_text'] ??
                                              'No text available',
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        trailing: Icon(
                                          controller.expandedIndexes
                                                  .contains(index)
                                              ? Iconsax.minus
                                              : Iconsax.add,
                                          color: AppColor.primaryColor,
                                        ),
                                        onExpansionChanged: (onExpand) async {
                                          controller.onExpand(
                                              onExpand, index, faq);
                                        },
                                        children: [
                                          if (controller.expandedIndexes
                                              .contains(index))
                                            Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (faq['answers'] == null ||
                                                      (faq['answers'] as List)
                                                          .isEmpty)
                                                    const CustomParagraph(
                                                      text:
                                                          'No answers available',
                                                      color: Colors.black54,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )
                                                  else
                                                    ...((faq['answers'] as List)
                                                        .asMap()
                                                        .entries
                                                        .map((entry) {
                                                      int index = entry.key;
                                                      var answer = entry.value;
                                                      return CustomParagraph(
                                                        text:
                                                            '${index + 1}. ${answer['faq_ans_text'] ?? 'No answer available'}',
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      );
                                                    }).toList()),
                                                ],
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                      ),
                    ),
                  ],
                ),
        ));
  }
}

class FaqsAppbar extends StatelessWidget {
  const FaqsAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Iconsax.message_search, size: 20),
        ),
      ],
      leading: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
              CustomParagraph(
                text: "Back",
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
      ),
      leadingWidth: 100,
      title: const CustomTitle(
        text: "FAQs",
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        letterSpacing: -0.41,
      ),
      centerTitle: true,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
      flexibleSpace: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/faq_frame.png"),
              ),
            ),
          ),
          Column(
            children: [
              const Expanded(
                flex: 7,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: CustomTitle(
                      text: "How can we help you?",
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColor.bodyColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
