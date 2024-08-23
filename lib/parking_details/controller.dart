import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/variables.dart';
import 'package:luvpark_get/functions/functions.dart';
import 'package:luvpark_get/http/api_keys.dart';
import 'package:luvpark_get/http/http_request.dart';
import 'package:luvpark_get/routes/routes.dart';

class ParkingDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  GoogleMapController? gMapController;
  final dataNearest = Get.arguments;
  var carsData = <Widget>[];
  RxBool btnLoading = false.obs;
  RxBool isNetConnected = true.obs;
  RxBool isLoading = true.obs;
  RxBool isOpen = false.obs;
  RxList amenData = <dynamic>[].obs;
  RxList carsInfo = <dynamic>[].obs;
  RxList<Marker> markers = <Marker>[].obs;
  Rx<Polyline> polyline = const Polyline(
    polylineId: PolylineId('dottedPolyLine'),
  ).obs;
  LatLng center = const LatLng(0, 0);
  LatLng destLoc = const LatLng(0, 0);
  CameraPosition? intialPosition;
  RxList vehicleTypes = <dynamic>[].obs;

  String finalSttime = "";
  String finalEndtime = "";

  @override
  void onInit() {
    super.onInit();
    final vehicleTypesList = dataNearest['vehicle_types_list'] as String;
    vehicleTypes.value = _parseVehicleTypes(vehicleTypesList);
    finalSttime = formatTime(dataNearest["start_time"]);
    finalEndtime = formatTime(dataNearest["end_time"]);
    isOpen.value = Functions.checkAvailability(finalSttime, finalEndtime);
    destLoc = LatLng(dataNearest["pa_latitude"], dataNearest["pa_longitude"]);
    refreshAmenData();
  }

  String formatTime(String time) {
    return "${time.substring(0, 2)}:${time.substring(2)}";
  }

  Future<void> refreshAmenData() async {
    isNetConnected.value = true;
    isLoading.value = true;

    getAmenities();
  }

  void onMapCreated(GoogleMapController controller) {
    gMapController = controller;
    DefaultAssetBundle.of(Get.context!)
        .loadString('assets/custom_map_style/map_style.json')
        .then((style) => controller.setMapStyle(style));
  }

  void buildBounds(LatLng currLoc, LatLng destLoc) {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        currLoc.latitude < destLoc.latitude
            ? currLoc.latitude
            : destLoc.latitude,
        currLoc.longitude < destLoc.longitude
            ? currLoc.longitude
            : destLoc.longitude,
      ),
      northeast: LatLng(
        currLoc.latitude > destLoc.latitude
            ? currLoc.latitude
            : destLoc.latitude,
        currLoc.longitude > destLoc.longitude
            ? currLoc.longitude
            : destLoc.longitude,
      ),
    );

    center = LatLng(
      (bounds.southwest.latitude + bounds.northeast.latitude) / 2,
      (bounds.southwest.longitude + bounds.northeast.longitude) / 2,
    );
    intialPosition = CameraPosition(
      target: center,
      zoom: 12.0,
    );

    isNetConnected.value = true;
    isLoading.value = false;

    gMapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 130));
  }

  Future<void> getAmenities() async {
    final response = await HttpRequest(
            api:
                "${ApiKeys.gApiSubFolderGetAmenities}?park_area_id=${dataNearest["park_area_id"]}")
        .get();

    if (response == "No Internet") {
      isNetConnected.value = false;
      CustomDialog().internetErrorDialog(Get.context!, () => Get.back());
      return;
    }

    if (response == null || response["items"] == null) {
      isNetConnected.value = true;
      isLoading.value = false;
      CustomDialog().errorDialog(
        Get.context!,
        "Error",
        "Error while connecting to server, Please contact support.",
        () => Get.back(),
      );
      return;
    }

    if (response["items"].isNotEmpty) {
      amenData.value = response["items"];
      fetchRoute();
    } else {
      isNetConnected.value = true;
      isLoading.value = false;
      CustomDialog().errorDialog(
        Get.context!,
        "luvpark",
        "No amenities found in this area.",
        () => Get.back(),
      );
    }
  }

  Future<void> fetchRoute() async {
    Functions.getLocation(Get.context!, (location) async {
      LatLng currentLocation = location;

      await Functions.getAddress(
          currentLocation.latitude, currentLocation.longitude);

      getCustomMarker([
        {"marker": "my_marker", "loc": currentLocation},
        {"marker": "dest_marker", "loc": destLoc}
      ]);

      buildBounds(currentLocation, destLoc);

      final estimatedData = await Functions.fetchETA(currentLocation, destLoc);
      polyline.value = Polyline(
        polylineId: const PolylineId('polylineId'),
        color: Colors.blue,
        width: 5,
        points: estimatedData[0]['poly_line'],
      );
    });
  }

  Future<void> getCustomMarker(List<Map<String, dynamic>> dataMarker) async {
    final List<Marker> newMarkers = [];
    for (int i = 0; i < dataMarker.length; i++) {
      final data = dataMarker[i];
      final Uint8List bytes = await Variables.capturePng(
        Get.context!,
        printScreen(
            data["marker"], i == 0 ? Colors.white : AppColor.primaryColor),
        30,
        false,
      );

      newMarkers.add(
        Marker(
          markerId: MarkerId(i == 0
              ? "CurrentLocation"
              : dataNearest["park_area_name"].toString()),
          infoWindow: InfoWindow(
              title: i == 0
                  ? "Current Location"
                  : dataNearest["park_area_name"].toString()),
          position: data["loc"],
          // ignore: deprecated_member_use
          icon: BitmapDescriptor.fromBytes(bytes),
        ),
      );
    }

    markers.addAll(newMarkers);
  }

  double getIconSize() {
    double screenWidth = MediaQuery.of(Get.context!).size.width;
    return screenWidth * 0.05;
  }

  Widget printScreen(String imgName, Color color) {
    return Container(
      width: 120,
      height: 120,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Image.asset("assets/images/$imgName.png", fit: BoxFit.contain),
      ),
    );
  }

//BUtton click
  void onClickBooking() {
    btnLoading.value = true;
    if (dataNearest["is_allow_reserve"] == "N") {
      btnLoading.value = false;
      CustomDialog().errorDialog(
          Get.context!, "LuvPark", "This area is not available at the moment.",
          () {
        Get.back();
      });
    } else {
      Functions.getUserBalance(Get.context!, (dataBalance) async {
        final userdata = dataBalance[0];
        final items = userdata["items"];

        if (userdata["success"]) {
          if (double.parse(items[0]["amount_bal"].toString()) <
              double.parse(items[0]["min_wallet_bal"].toString())) {
            btnLoading.value = false;
            CustomDialog().errorDialog(
                Get.context!,
                "Attention",
                "Your balance is below the required minimum for this feature. "
                    "Please ensure a minimum balance of ${items[0]["min_wallet_bal"]} tokens to access the requested service.",
                () {
              Get.back();
            });
            return;
          } else {
            Functions.computeDistanceResorChckIN(Get.context!, destLoc,
                (success) {
              btnLoading.value = false;
              if (success["success"]) {
                Get.toNamed(Routes.booking, arguments: {
                  "currentLocation": success["location"],
                  "areaData": dataNearest,
                  "canCheckIn": success["can_checkIn"],
                  "userData": items,
                });
              }
            });
          }
        }
      });
    }
  }

  List<Map<String, String>> _parseVehicleTypes(String vhTpList) {
    final types = vhTpList.split(' | ');
    final parsedTypes = <Map<String, String>>[];
    Color color;

    for (var type in types) {
      final parts = type.split('(');
      if (parts.length < 2) continue;

      final name = parts[0].trim();
      final count = parts[1].split('/')[0].trim();

      final lowerCaseName = name.toLowerCase();
      String iconKey;
      if (lowerCaseName.contains("motorcycle")) {
        color = const Color(0xFFD65F5F);
        iconKey = "scooter";
      } else if (lowerCaseName.contains("trikes")) {
        color = const Color(0xFFDCA945);
        iconKey = "car";
      } else {
        color = const Color.fromARGB(255, 69, 145, 220);
        iconKey = "delivery";
      }

      final colorString = '#${color.value.toRadixString(16).padLeft(8, '0')}';
      parsedTypes.add({
        'name': name,
        'count': count,
        'color': colorString,
        'icon': iconKey,
      });
    }
    return parsedTypes;
  }
}
