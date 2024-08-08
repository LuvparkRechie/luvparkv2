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

class ParkingDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  GoogleMapController? gMapController;
  final dataNearest = Get.arguments;
  var carsData = <Widget>[];
  RxBool isNetConnected = true.obs;
  RxBool isLoadingRoute = true.obs;
  RxBool isLoadingAmen = true.obs;
  RxBool isOpen = false.obs;
  RxList amenData = <dynamic>[].obs;
  RxList carsInfo = <dynamic>[].obs;
  RxList<Marker> markers = <Marker>[].obs;
  Rx<Polyline> polyline = const Polyline(
    polylineId: PolylineId('dottedPolyLine'),
  ).obs;
  LatLng center = const LatLng(0, 0);

  String finalSttime = "";
  String finalEndtime = "";

  @override
  void onInit() {
    super.onInit();
    finalSttime = formatTime(dataNearest["start_time"]);
    finalEndtime = formatTime(dataNearest["end_time"]);
    isOpen.value = Functions.checkAvailability(finalSttime, finalEndtime);
    refreshAmenData();
  }

  String formatTime(String time) {
    return "${time.substring(0, 2)}:${time.substring(2)}";
  }

  Future<void> refreshAmenData() async {
    isNetConnected.value = true;
    isLoadingRoute.value = true;
    getAmenities();
  }

  Future<void> getAmenities() async {
    final response = await HttpRequest(
            api:
                "${ApiKeys.gApiSubFolderGetAmenities}?park_area_id=${dataNearest["park_area_id"]}")
        .get();

    if (response == "No Internet") {
      isNetConnected.value = false;
      isLoadingAmen.value = false;
      CustomDialog().internetErrorDialog(Get.context!, () => Get.back());
      return;
    }

    if (response == null || response["items"] == null) {
      isNetConnected.value = true;
      isLoadingAmen.value = false;
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
      isLoadingAmen.value = false;
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
      LatLng destLoc =
          LatLng(dataNearest["pa_latitude"], dataNearest["pa_longitude"]);

      await Functions.getAddress(
          currentLocation.latitude, currentLocation.longitude);
      getCustomMarker([
        {"marker": "my_marker", "loc": currentLocation},
        {"marker": "dest_marker", "loc": destLoc}
      ]);
      buildBounds(currentLocation, destLoc);

      final estimatedData = await Functions.fetchETA(currentLocation, destLoc);
      print("estimatedData $estimatedData");
      // if (estimatedData[] != "No Internet") {
      //   polyline.value = Polyline(
      //     polylineId: const PolylineId('polylineId'),
      //     color: Colors.blue,
      //     width: 5,
      //     points: estimatedData[0]['poly_line'],
      //   );
      //   buildBounds(currentLocation, destLoc);
      // }
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
          icon: BitmapDescriptor.fromBytes(bytes),
        ),
      );
    }

    markers.addAll(newMarkers);
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

    gMapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 130));
    isLoadingRoute.value = false;
  }

  double getIconSize() {
    double screenWidth = MediaQuery.of(Get.context!).size.width;
    return screenWidth * 0.05;
  }

  @override
  void onClose() {
    super.onClose();
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
}
