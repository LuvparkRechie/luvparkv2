import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luvpark_get/custom_widgets/custom_appbar.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/no_data_found.dart';
import 'package:luvpark_get/custom_widgets/no_internet.dart';
import 'package:luvpark_get/custom_widgets/page_loader.dart';

import '../custom_widgets/app_color.dart';
import 'controller.dart';

class MessageScreen extends GetView<MessageScreenController> {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "Messages",
        action: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Center(
              child: InkWell(
                onTap: controller.deleteAll,
                child: CustomParagraph(
                  text: "Delete all",
                  color: AppColor.primaryColor,
                ),
              ),
            ),
          )
        ],
      ),
      body: StretchingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        child: RefreshIndicator(
          onRefresh: controller.refresher,
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: Obx(
              () {
                if (controller.isLoading.value) {
                  return const PageLoader();
                } else if (!controller.isNetConn.value) {
                  return NoInternetConnected(
                    onTap: controller.refresher,
                  );
                } else if (controller.messages.isEmpty) {
                  return const NoDataFound(text: "No messages found");
                } else {
                  return ListView.builder(
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                        child: Card(
                          child: ListTile(
                            leading: const Icon(Iconsax.message_question),
                            title: CustomParagraph(
                              maxlines: 5,
                              text: message["message"] ?? "No message content",
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                controller.deleteMessage(index);
                              },
                              icon: const Icon(
                                Icons.delete_rounded,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
