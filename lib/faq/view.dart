import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_appbar.dart';
import 'package:luvpark_get/faq/controller.dart';

class FaqPage extends GetView<FaqPageController> {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColor.bodyColor,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));

    return const Scaffold(
      backgroundColor: AppColor.bodyColor,
      appBar: CustomAppbar(title: "FAQs"),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //   child: GridView.builder(
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2,
            //       crossAxisSpacing: 10.0,
            //       mainAxisSpacing: 10.0,
            //     ),
            //     itemCount: controller.faqsData.length,
            //     itemBuilder: (context, index) {
            //       return FlipCard(
            //         onFlip: () async {
            //           if (!controller.faqsData[index].containsKey('answers')) {
            //             var faqId = controller.faqsData[index]['id'];
            //             await controller.getFaqAnswers(faqId, index);
            //           }
            //         },
            //         front: Container(
            //           decoration: BoxDecoration(
            //             color: AppColor.primaryColor,
            //             borderRadius: BorderRadius.circular(15),
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.black.withOpacity(0.3),
            //                 spreadRadius: 2,
            //                 blurRadius: 5,
            //                 offset: const Offset(0, 3),
            //               ),
            //             ],
            //           ),
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: CustomParagraph(
            //                   text: controller.faqsData[index]['faq_text'],
            //                   fontWeight: FontWeight.bold,
            //                   color: Colors.white,
            //                   textAlign: TextAlign.center,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //         back: Container(
            //           decoration: BoxDecoration(
            //             color: AppColor.primaryColor,
            //             borderRadius: BorderRadius.circular(15),
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.black.withOpacity(0.3),
            //                 spreadRadius: 2,
            //                 blurRadius: 5,
            //                 offset: const Offset(0, 3),
            //               ),
            //             ],
            //           ),
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: controller.faqsData[index]
            //                     .containsKey('answers')
            //                 ? (controller.faqsData[index]['answers'] as List)
            //                     .map((answer) {
            //                     return Padding(
            //                       padding: const EdgeInsets.all(8.0),
            //                       child: CustomParagraph(
            //                         text: answer[
            //                             'faq_ans_text'], // Adjust this key based on your API response
            //                         color: Colors.white,
            //                         textAlign: TextAlign.start,
            //                       ),
            //                     );
            //                   }).toList()
            //                 : [
            //                     const CustomParagraph(
            //                       text: 'Loading...',
            //                       color: Colors.white,
            //                       textAlign: TextAlign.center,
            //                     ),
            //                   ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
