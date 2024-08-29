import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  RxInt currentPage = 0.obs;
  PageController pageController = PageController();
  RxList<Map<String, dynamic>> sliderData = RxList([
    {
      "title": "Need parking?",
      "subTitle":
          "LuvPark finds nearby spots in real-time based on your destination and location.",
      "icon": "onboard1",
    },
    {
      "title": "Easy booking",
      "subTitle":
          "Book your parking spot with ease using LuvPark’s state-of-the-art parking system.",
      "icon": "onboard2",
    },
    {
      "title": "Pick & Park",
      "subTitle":
          "Discover the perfect parking spot with LuvPark—tailored just for you!",
      "icon": "onboard3",
    },
    {
      "title": "Locate your car",
      "subTitle":
          "Lost track of your car? We make it easy with our state of the art real-time tracking.",
      "icon": "onboard4",
    }
  ]);

  void onPageChanged(int index) {
    currentPage.value = index;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
  }

  OnboardingController();
}
