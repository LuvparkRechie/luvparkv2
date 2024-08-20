import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/variables.dart';
import 'package:luvpark_get/functions/functions.dart';
import 'package:luvpark_get/http/api_keys.dart';
import 'package:luvpark_get/http/http_request.dart';
import 'package:luvpark_get/location_auth/location_auth.dart';
import 'package:luvpark_get/routes/routes.dart';
import 'package:map_picker/map_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// ignore: deprecated_member_use
class DashboardMapController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Dependencies
  final GlobalKey<ScaffoldState> dashboardScaffoldKey =
      GlobalKey<ScaffoldState>();
  final GlobalKey headerKey = GlobalKey();
  final TextEditingController searchCon = TextEditingController();
  final PanelController panelController = PanelController();
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;
  RxBool isSidebarVisible = false.obs;
  GoogleMapController? gMapController;
  CameraPosition? initialCameraPosition;
  RxList<Marker> markers = <Marker>[].obs;
  RxList<dynamic> userBal = <dynamic>[].obs;
  RxList<dynamic> dataNearest = [].obs;
  //drawerdata
  var userProfile;
  Circle circle = const Circle(circleId: CircleId('dottedCircle'));
  RxList suggestions = [].obs;
  Polyline polyline = const Polyline(
    polylineId: PolylineId('dottedPolyLine'),
  );
  MapPickerController mapPickerController = MapPickerController();
  LatLng searchCoordinates = const LatLng(0, 0);

  // Configuration Variables
  String? ddRadius = "10";
  String pTypeCode = "";
  String amenities = "";
  String vtypeId = "";
  RxString addressText = "".obs;
  String isAllowOverNight = "";
  RxString myName = "".obs;
  // State Variables
  RxBool netConnected = true.obs;
  RxBool isLoading = true.obs;
  RxBool isLoadingMap = true.obs;
  RxBool isGetNearData = false.obs;
  RxBool isMarkerTapped = false.obs;
  //Panel variables
  RxDouble headerHeight = 0.0.obs;
  RxDouble minHeight = 0.0.obs;
  @override
  void onInit() {
    super.onInit();
    ddRadius = "10";
    pTypeCode = "";
    amenities = "";
    vtypeId = "";
    addressText = "".obs;
    isAllowOverNight = "";
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0), // Start off-screen to the left
      end: Offset.zero, // End at the screen edge
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    getUserData(false);
  }

  @override
  void dispose() {
    super.dispose();
    gMapController!.dispose();
  }

  //get curr location
  Future<void> getCurrentLoc() async {
    ddRadius = "10";
    pTypeCode = "";
    amenities = "";
    vtypeId = "";
    addressText = "".obs;
    isAllowOverNight = "";

    getUserData(false);
  }

  //get curr location
  Future<void> getFilterNearest(data) async {
    ddRadius = data[0]["radius"];
    pTypeCode = data[0]["park_type"];
    amenities = data[0]["amen"];
    vtypeId = data[0]["vh_type"];
    isAllowOverNight = data[0]["ovp"];

    getUserData(false);
  }

  //toggle
  void toggleSidebar() {
    if (isSidebarVisible.value) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
    isSidebarVisible.value = !isSidebarVisible.value;
  }

//MAP SETUP
  void onMapCreated(GoogleMapController controller) {
    DefaultAssetBundle.of(Get.context!)
        .loadString('assets/custom_map_style/map_style.json')
        .then((String style) {
      controller.setMapStyle(style);
    });
    gMapController = controller;
    animateCamera();
  }

  void onTap(bool connected) {
    netConnected.value = connected;
  }

  void onCameraMoveStarted() {
    mapPickerController.mapMoving!();
    isGetNearData.value = false;
  }

  Future<void> onCameraIdle() async {
    mapPickerController.mapFinishedMoving!();
    String? address = await Functions.getAddress(
      initialCameraPosition!.target.latitude,
      initialCameraPosition!.target.longitude,
    );

    addressText.value = address!;

    initialCameraPosition = CameraPosition(
      target: LatLng(initialCameraPosition!.target.latitude,
          initialCameraPosition!.target.longitude),
      zoom: 17,
      tilt: 0,
      bearing: 0,
    );
    polyline = Polyline(
      polylineId: const PolylineId('dottedCircle'),
      color: AppColor.primaryColor,
      width: 2,
      patterns: [
        PatternItem.dash(20),
        PatternItem.gap(20),
      ],
      points: List<LatLng>.generate(
          360,
          (index) => calculateNewCoordinates(
              initialCameraPosition!.target.latitude,
              initialCameraPosition!.target.longitude,
              200,
              double.parse(index.toString()))),
    );
    isGetNearData.value = true;
  }

  void onCameraMove(CameraPosition cameraPosition) {
    if (!isMarkerTapped.value) {
      initialCameraPosition = cameraPosition;
    }
  }

  void animateCamera() {
    if (gMapController != null) {
      gMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(initialCameraPosition!.target.latitude,
                  initialCameraPosition!.target.longitude),
              zoom: 17),
        ),
      );
    }
  }

//END OF MAP SETUP
  void getUserData(isSearch) async {
    isLoading.value = true;
    isLoadingMap.value = true;
    String? userData = await Authentication().getUserData();
    final item = await Authentication().getUserData2();

    userProfile = item;
    if (jsonDecode(userData!)["first_name"] == null) {
      myName.value = "";
    } else {
      myName.value = jsonDecode(userData)["first_name"];
    }

    LocationService.grantPermission(Get.context!, (isGranted) {
      if (isGranted) {
        Functions.getUserBalance(Get.context!, (dataBalance) async {
          userBal.value = dataBalance[0]["items"];
          if (!dataBalance[0]["has_net"]) {
            netConnected.value = false;
            isLoading.value = false;
            isLoadingMap.value = false;
          } else {
            isLoading.value = false;
            if (isSearch) {
              getNearest(dataBalance[0]["items"], searchCoordinates);
            } else {
              List ltlng = await Functions.getCurrentPosition();
              LatLng coordinates = LatLng(ltlng[0]["lat"], ltlng[0]["long"]);
              searchCoordinates = coordinates;
              getNearest(dataBalance[0]["items"], coordinates);
            }
          }
        });
      } else {
        isLoading.value = true;
        Get.toNamed(Routes.permission);
      }
    });
  }

  void getNearest(List<dynamic> uData, LatLng coordinates) async {
    // initialCameraPosition = null;

    String params =
        "${ApiKeys.gApiSubFolderGetNearestSpace}?is_allow_overnight=$isAllowOverNight&parking_type_code=$pTypeCode&latitude=${coordinates.latitude}&longitude=${coordinates.longitude}&radius=$ddRadius&parking_amenity_code=$amenities&vehicle_type_id=$vtypeId";
    print("nearest params $params");
    try {
      var returnData = await HttpRequest(api: params).get();
      if (returnData == "No Internet") {
        handleNoInternet();
        return;
      }
      if (returnData == null) {
        handleServerError();
        return;
      }
      if (returnData["items"].isEmpty) {
        handleNoParkingFound();
        return;
      }
      buildMarkers(returnData["items"]);
      handleData(returnData, uData, coordinates);
    } catch (e) {
      handleServerError();
    }
  }

  Future<void> buildMarkers(data) async {
    dataNearest.value = data;
    int ctr = 0;

    if (dataNearest.isNotEmpty) {
      for (int i = 0; i < dataNearest.length; i++) {
        ctr++;
        var items = dataNearest[i];

        final String isPwd = items["is_pwd"] ?? "N";
        final String vehicleTypes = items["vehicle_types_list"];

        String iconAsset;
        if (isPwd == "Y") {
          if (vehicleTypes.contains("Motorcycle") &&
              vehicleTypes.contains("Trikes and Cars")) {
            iconAsset =
                'assets/dashboard_icon/cmp.png'; // Icon for both Motor and Cars with PWD indication
          } else if (vehicleTypes.contains("Motorcycle")) {
            iconAsset =
                'assets/dashboard_icon/mp.png'; // Icon for Motorcycles with PWD indication
          } else {
            iconAsset =
                'assets/dashboard_icon/cp.png'; // Default icon with PWD indication
          }
        } else {
          if (vehicleTypes.contains("Motorcycle") &&
              vehicleTypes.contains("Trikes and Cars")) {
            iconAsset =
                'assets/dashboard_icon/mc.png'; // Icon for both Motor and Cars
          } else if (vehicleTypes.contains("Motorcycle")) {
            iconAsset =
                'assets/dashboard_icon/m.png'; // Icon for Motorcycles only
          } else {
            iconAsset = 'assets/dashboard_icon/c.png'; // Icon for Cars only
          }
        }

        final Uint8List markerIcon =
            await Variables.getBytesFromAsset(iconAsset, 0.7);

        markers.add(
          Marker(
              // ignore: deprecated_member_use
              icon: BitmapDescriptor.fromBytes(markerIcon),
              markerId: MarkerId(ctr.toString()),
              position: LatLng(double.parse(items["pa_latitude"].toString()),
                  double.parse(items["pa_longitude"].toString())),
              onTap: () {
                print("marker tap ${ctr.toString()}");
                isMarkerTapped.value = true;
                mapPickerController.mapFinishedMoving;
              }),
        );
      }
    }
  }

  void handleNoInternet() {
    netConnected.value = false;
    isLoadingMap.value = true;
    CustomDialog().internetErrorDialog(Get.context!, () {
      Get.back();
    });
  }

  void handleServerError() {
    netConnected.value = true;
    isLoadingMap.value = false;
    CustomDialog().errorDialog(Get.context!, "Internet Error",
        "Error while connecting to server, Please contact support.", () {
      Get.back();
    });
  }

  void handleNoParkingFound() {
    netConnected.value = true;
    isLoadingMap.value = false;
    initialCameraPosition = CameraPosition(
      target: searchCoordinates,
      zoom: 14,
      tilt: 0,
      bearing: 0,
    );
    markers.clear();
    bool isDouble = ddRadius!.contains(".");
    CustomDialog().errorDialog(Get.context!, "Luvpark",
        "No parking area found within \n${(isDouble ? double.parse(ddRadius!) : int.parse(ddRadius!)) >= 1 ? '${ddRadius!} Km' : '${double.parse(ddRadius!) * 1000} meters'}, please change location.",
        () {
      Get.back();
    });
  }

  void handleData(
      dynamic returnData, List<dynamic> uData, LatLng coordinates) async {
    markers.clear();

    if (double.parse(uData[0]["amount_bal"].toString()) >=
        double.parse(uData[0]["min_wallet_bal"].toString())) {
      initialCameraPosition = CameraPosition(
        target: coordinates,
        zoom: uData.isEmpty ? 14 : 17,
        tilt: 0,
        bearing: 0,
      );
      circle = Circle(
        circleId: const CircleId('dottedCircle'),
        center: LatLng(initialCameraPosition!.target.latitude,
            initialCameraPosition!.target.longitude),
        radius: 200,
        strokeWidth: 0,
        fillColor: AppColor.primaryColor.withOpacity(.03),
      );
      polyline = Polyline(
        polylineId: const PolylineId('dottedCircle'),
        color: AppColor.primaryColor,
        width: 2,
        patterns: [
          PatternItem.dash(20),
          PatternItem.gap(20),
        ],
        points: List<LatLng>.generate(
            360,
            (index) => calculateNewCoordinates(
                initialCameraPosition!.target.latitude,
                initialCameraPosition!.target.longitude,
                200,
                double.parse(index.toString()))),
      );

      netConnected.value = true;
      isLoadingMap.value = false;
    }

    update();
  }

  //SEARCH PLACE
  Future<void> fetchSuggestions() async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${searchCon.text}&location=${initialCameraPosition!.target.latitude},${initialCameraPosition!.target.longitude}&radius=${double.parse(ddRadius.toString())}&key=${Variables.mapApiKey}';

    var links = http.get(Uri.parse(url));

    try {
      final response = await HttpRequest.fetchDataWithTimeout(links);
      suggestions.value = [];
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final predictions = data['predictions'];

        if (predictions != null) {
          for (var prediction in predictions) {
            suggestions.add(
                "${prediction['description']}=Rechie=${prediction['place_id']}=structured=${prediction["structured_formatting"]["main_text"]}");
          }
          update();
        } else {
          suggestions.value = [];
          update();
        }
      } else {
        suggestions.value = [];
        update();
      }
    } catch (e) {
      suggestions.value = [];
      update();
      CustomDialog().internetErrorDialog(Get.context!, () {
        Get.back();
      });
    }
  }

  //calculate coordinates
  LatLng calculateNewCoordinates(
      double lat, double lon, double radiusInMeters, double angleInDegrees) {
    // ignore: non_constant_identifier_names
    double PI = 3.141592653589793238;

    double angleInRadians = angleInDegrees * PI / 180;

    // Constants for Earth's radius and degrees per meter
    const earthRadiusInMeters = 6371000; // Approximate Earth radius in meters
    const degreesPerMeterLatitude = 1 / earthRadiusInMeters * 180 / pi;
    final degreesPerMeterLongitude =
        1 / (earthRadiusInMeters * cos(lat * PI / 180)) * 180 / pi;

    // Calculate the change in latitude and longitude in degrees
    double degreesOfLatitude = radiusInMeters * degreesPerMeterLatitude;
    double degreesOfLongitude = radiusInMeters * degreesPerMeterLongitude;

    // Calculate the new latitude and longitude
    double newLat = lat + degreesOfLatitude * sin(angleInRadians);
    double newLon = lon + degreesOfLongitude * cos(angleInRadians);
    return LatLng(newLat, newLon);
  }

//Display Text as marker
  Widget printScreen(Color color, String index, String rate) {
    return Container(
      height: 50,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    "P",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            Container(width: 5),
            Text(
              "₱$rate",
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }
}
