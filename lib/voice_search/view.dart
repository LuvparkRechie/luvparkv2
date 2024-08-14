import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/voice_search/controller.dart';

class VoiceSearchPopup extends StatelessWidget {
  const VoiceSearchPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VoiceSearchController>(
      init: VoiceSearchController(),
      builder: (controller) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Center(child: Text("Voice Search")),
          content: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.mic,
                  size: 100,
                  color: Colors.blue,
                ),
                const SizedBox(height: 20),
                Text(
                  controller.isListening.value
                      ? "Listening..."
                      : "Press the button below to start voice search",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                Text(
                  controller.searchText.value,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (!controller.initialized) {
                          Get.snackbar(
                              'Error', 'Speech recognition is not initialized');
                          return;
                        }

                        if (controller.isListening.value) {
                          controller.stopListening();
                        } else {
                          controller.startListening();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.isListening.value
                            ? Colors.red
                            : Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child:
                          Text(controller.isListening.value ? "Stop" : "Start"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Close"),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                if (controller.searchText.value.isNotEmpty) {
                  controller.parameters(controller.searchText.value);
                }
              },
              child: const Text("Search"),
            ),
          ],
        );
      },
    );
  }
}
