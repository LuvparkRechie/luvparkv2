import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  RxInt currentPage = 0.obs;
  PageController pageController = PageController();
  RxList<Map<String, dynamic>> sliderData = RxList([
    {
      "title": "Discover the closest parking area",
      "subTitle":
          "Need parking? Our app finds nearby spots in real-time based on your destination and location.",
      "icon": "find_parking",
    },
    {
      "title": "Book Parking",
      "subTitle":
          "No more driving around in circles! Once you find a spot you like, you can book it right from our app.",
      "icon": "lporn",
    },
    {
      "title": "Park",
      "subTitle":
          "Luvpark seamlessly integrates with Google Maps, enabling you to easily obtain directions and distance from your current location to your chosen parking spot, ensuring a smooth driving experience.",
      "icon": "lporn",
    },
    {
      "title": "Find my Vehicle",
      "subTitle":
          "Need help finding where you parked your vehicle? Worry no more – Luvpark has you covered. Our app can pinpoint your parked car from your current location by utilizing your active parking transaction.",
      "icon": "lporn",
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
