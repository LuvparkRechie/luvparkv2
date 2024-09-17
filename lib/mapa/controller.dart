//mapa controller

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/custom_widgets/alert_dialog.dart';
import 'package:luvpark_get/custom_widgets/variables.dart';
import 'package:luvpark_get/functions/functions.dart';
import 'package:luvpark_get/http/api_keys.dart';
import 'package:luvpark_get/http/http_request.dart';
import 'package:luvpark_get/location_auth/location_auth.dart';
import 'package:luvpark_get/mapa/utils/legend/legend_dialog.dart';
import 'package:luvpark_get/routes/routes.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../custom_widgets/app_color.dart';
import 'utils/marker_data_dialog/marker_data_dialog.dart';
import 'utils/suggestions/suggestions.dart';

// ignore: deprecated_member_use
class DashboardMapController extends GetxController
    with GetTickerProviderStateMixin, WidgetsBindingObserver {
  // Dependencies
  final GlobalKey<ScaffoldState> dashboardScaffoldKey =
      GlobalKey<ScaffoldState>();
  final GlobalKey headerKey = GlobalKey();
  final TextEditingController searchCon = TextEditingController();
  final PanelController panelController = PanelController();
  late AnimationController animationController;

  RxBool isSidebarVisible = false.obs;
  bool isFilter = false;
  GoogleMapController? gMapController;
  CameraPosition? initialCameraPosition;
  RxList<Marker> markers = <Marker>[].obs;
  RxList<dynamic> userBal = <dynamic>[].obs;
  RxList<dynamic> dataNearest = [].obs;
  List markerData = [];
  //drawerdata
  var userProfile;
  Circle circle = const Circle(circleId: CircleId('dottedCircle'));
  RxList suggestions = [].obs;
  RxString myProfPic = "".obs;
  Polyline polyline = const Polyline(
    polylineId: PolylineId('dottedPolyLine'),
  );

  LatLng searchCoordinates = const LatLng(0, 0);

//PIn icon
  List<String> searchImage = ['assets/dashboard_icon/location_pin.png'];

  // Configuration Variables
  RxString ddRadius = "10".obs;
  String pTypeCode = "";
  String amenities = "";
  String vtypeId = "";
  RxString addressText = "".obs;
  String isAllowOverNight = "";
  RxString myName = "".obs;
  // State Variables
  RxBool netConnected = true.obs;
  RxBool isLoading = true.obs;
  RxBool isGetNearData = false.obs;
  RxBool isMarkerTapped = false.obs;
  //Panel variables
  RxDouble headerHeight = 0.0.obs;
  RxDouble minHeight = 0.0.obs;
  RxBool isClearSearch = true.obs;
  //Last Booking variables
  RxBool hasLastBooking = false.obs;
  RxBool isSearch = false.obs;
  RxString plateNo = "".obs;
  RxString brandName = "".obs;
  late StreamController<void> _dataController;
  late StreamSubscription<void> dataSubscription;
  LatLng currentCoord = LatLng(0, 0);
//panel gg
  RxDouble panelHeightOpen = 180.0.obs;
  RxDouble initFabHeight = 80.0.obs;
  RxDouble fabHeight = 0.0.obs;
  RxDouble panelHeightClosed = 60.0.obs;
  RxBool isOPenFab = false.obs;
  bool isKeyboardVisible = false;

  @override
  void onInit() {
    super.onInit();

    ddRadius.value = "10";
    pTypeCode = "";
    amenities = "";
    vtypeId = "";
    addressText = "".obs;
    isAllowOverNight = "";
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    getLastBooking();
    getUserData();
    getDefaultLocation();
    fabHeight.value = panelHeightOpen.value + 30;
    _dataController = StreamController<void>();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    super.onClose();
    gMapController!.dispose();

    animationController.dispose();
    _dataController.close();
    dataSubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    print("adfsaf %dfaf");
    panelController.open();
  }

  double getPanelHeight() {
    double bottomInset = MediaQuery.of(Get.context!).viewInsets.bottom;
    double height = suggestions.isEmpty
        ? bottomInset != 0
            ? bottomInset + 20
            : 180
        : bottomInset != 0
            ? bottomInset + 20
            : MediaQuery.of(Get.context!).size.height * 0.70;

    panelHeightOpen.value = height;

    return height;
  }

  void onPanelSlide(double pos) {
    fabHeight.value = pos * (panelHeightOpen.value - panelHeightClosed.value) +
        initFabHeight.value;
  }

  void streamData() {
    dataSubscription = _dataController.stream.listen((data) {});
    fetchDataPeriodically();
  }

  void fetchDataPeriodically() async {
    dataSubscription = Stream.periodic(const Duration(seconds: 10), (count) {
      fetchData();
    }).listen((event) {});
  }

  Future<void> fetchData() async {
    await Future.delayed(const Duration(seconds: 10));
    getBalance();
  }

  Future<void> refresher() async {
    netConnected.value = true;
    isLoading.value = true;
    getLastBooking();
    getUserData();
    getDefaultLocation();
  }

  void getBalance() async {
    final item = await Authentication().getUserId();
    String subApi = "${ApiKeys.gApiSubFolderGetBalance}?user_id=$item";

    HttpRequest(api: subApi).get().then((returnBalance) async {
      if (returnBalance["items"].isNotEmpty) {
        userBal.value = returnBalance["items"];
      }
    });
  }

  void getUserData() async {
    String? userData = await Authentication().getUserData();
    final item = await Authentication().getUserData2();
    final profPic = await Authentication().getUserProfilePic();

    userProfile = item;
    myProfPic.value = profPic;

    userProfile = item;
    if (jsonDecode(userData!)["first_name"] == null) {
      myName.value = "";
    } else {
      myName.value = jsonDecode(userData)["first_name"];
    }
    streamData();
  }

  //GEt nearest data based on
  getDefaultLocation() {
    isLoading.value = true;
    isFilter = false;
    LocationService.grantPermission(Get.context!, (isGranted) async {
      if (isGranted) {
        List ltlng = await Functions.getCurrentPosition();
        LatLng coordinates = LatLng(ltlng[0]["lat"], ltlng[0]["long"]);
        searchCoordinates = coordinates;
        currentCoord = coordinates;
        bridgeLocation(coordinates);
      } else {
        isLoading.value = true;
        Get.toNamed(Routes.permission);
      }
    });
  }

  void bridgeLocation(coordinates) {
    CustomDialog().mapLoading(
        Variables.convertDistance(ddRadius.value.toString()).toString());
    Functions.getUserBalance(Get.context!, (dataBalance) async {
      userBal.value = dataBalance[0]["items"];
      if (!dataBalance[0]["has_net"]) {
        Get.back();
        netConnected.value = false;
        isLoading.value = false;
        gMapController!.dispose();

        animationController.dispose();
        _dataController.close();
        dataSubscription.cancel();
      } else {
        isLoading.value = true;
        getNearest(dataBalance[0]["items"], coordinates);
      }
    });
  }

  void getNearest(dynamic userData, LatLng coordinates) async {
    String params =
        "${ApiKeys.gApiSubGetNearybyParkings}?is_allow_overnight=$isAllowOverNight&parking_type_code=$pTypeCode&current_latitude=${currentCoord.latitude}&current_longitude=${currentCoord.longitude}&search_latitude=${coordinates.latitude}&search_longitude=${coordinates.longitude}&radius=${Variables.convertToMeters(ddRadius.value.toString())}&parking_amenity_code=$amenities&vehicle_type_id=$vtypeId";
    print(" params$params");
    try {
      var returnData = await HttpRequest(api: params).get();

      Get.back();

      if (returnData == "No Internet") {
        handleNoInternet();
        return;
      }
      if (returnData == null) {
        handleServerError();
        return;
      }
      if (returnData["items"].isEmpty) {
        handleNoParkingFound(returnData["items"]);
        return;
      }

      handleData(returnData["items"]);
    } catch (e) {
      handleServerError();
    }
  }

  void handleNoInternet() {
    netConnected.value = false;
    isLoading.value = false;
    CustomDialog().internetErrorDialog(Get.context!, () {
      Get.back();
    });
    return;
  }

  void handleServerError() {
    netConnected.value = true;
    isLoading.value = false;
    CustomDialog().serverErrorDialog(Get.context!, () {
      Get.back();
    });
    return;
  }

  void handleNoParkingFound(dynamic nearData) {
    netConnected.value = true;
    isLoading.value = false;
    markers.clear();
    bool isDouble = ddRadius.value.contains(".");
    String message = isFilter
        ? "There are no parking areas available based on your filter."
        : "No parking area found within \n${(isDouble ? double.parse(ddRadius.value) : int.parse(ddRadius.value)) >= 1 ? '${ddRadius.value} Km' : '${double.parse(ddRadius.value) * 1000} meters'}, please change location.";

    CustomDialog().errorDialog(Get.context!, "Luvpark", message, () {
      Get.back();
      showDottedCircle(nearData);
    });
  }

  void handleData(dynamic nearData) async {
    markers.clear();

    if (double.parse(userBal[0]["amount_bal"].toString()) >=
        double.parse(userBal[0]["min_wallet_bal"].toString())) {
      showDottedCircle(nearData);

      buildMarkers(nearData);
      netConnected.value = true;
      bool isShowPopUp = await Authentication().getPopUpNearest();
      if (dataNearest.isNotEmpty && !isShowPopUp) {
        Future.delayed(const Duration(seconds: 1), () {
          Authentication().setShowPopUpNearest(true);

          showLegend(() {
            showNearestSuggestDialog();
          });
        });
      }
    }

    update();
  }

//Based on radius
  void showDottedCircle(nearData) {
    if (double.parse(userBal[0]["amount_bal"].toString()) >=
        double.parse(userBal[0]["min_wallet_bal"].toString())) {
      initialCameraPosition = CameraPosition(
        target: searchCoordinates,
        zoom: nearData.isEmpty ? 14 : 16,
        tilt: 0,
        bearing: 0,
      );

      animateCamera();
    }
  }

  //Get last available booking
  Future<void> getLastBooking() async {
    dynamic data = await Authentication().getLastBooking();
    if (data.isEmpty || data == null) {
      hasLastBooking.value = false;
    } else {
      hasLastBooking.value = true;
      plateNo.value = data["plate_no"];
      brandName.value = data["brand_name"];
    }
  }

  //Book now last booking
  Future<void> bookNow() async {
    CustomDialog().loadingDialog(Get.context!);
    final data = await Authentication().getLastBooking();

    List lastBooking = dataNearest;
    lastBooking = lastBooking.where((e) {
      return int.parse(e["park_area_id"].toString()) ==
          int.parse(data["park_area_id"].toString());
    }).toList();

    LatLng destLoc =
        LatLng(lastBooking[0]["pa_latitude"], lastBooking[0]["pa_longitude"]);
    if (lastBooking[0]["is_allow_reserve"] == "N") {
      Get.back();
      CustomDialog().errorDialog(
        Get.context!,
        "LuvPark",
        "This area is not available at the moment.",
        () {
          Get.back();
        },
      );
      return;
    }

    Functions.getUserBalance(Get.context!, (dataBalance) async {
      final userdata = dataBalance[0];
      final items = userdata["items"];

      if (userdata["success"]) {
        if (double.parse(items[0]["amount_bal"].toString()) <
            double.parse(items[0]["min_wallet_bal"].toString())) {
          Get.back();
          CustomDialog().errorDialog(
            Get.context!,
            "Attention",
            "Your balance is below the required minimum for this feature. "
                "Please ensure a minimum balance of ${items[0]["min_wallet_bal"]} tokens to access the requested service.",
            () {
              Get.back();
            },
          );
          return;
        } else {
          Functions.computeDistanceResorChckIN(Get.context!, destLoc,
              (success) {
            Get.back();
            if (success["success"]) {
              Get.toNamed(Routes.booking, arguments: {
                "currentLocation": success["location"],
                "areaData": lastBooking[0],
                "canCheckIn": success["can_checkIn"],
                "userData": items,
              });
            }
          });
        }
      } else {
        Get.back();
      }
    });
  }

  //Book marker dialog
  Future<void> bookMarkerNow(data, Function cb) async {
    CustomDialog().loadingDialog(Get.context!);
    LatLng destLoc = LatLng(data[0]["pa_latitude"], data[0]["pa_longitude"]);

    if (data[0]["is_allow_reserve"] == "N") {
      cb(true);
      Get.back();
      CustomDialog().errorDialog(
        Get.context!,
        "LuvPark",
        "This area is not available at the moment.",
        () {
          Get.back();
        },
      );
      return;
    }

    Functions.getUserBalance(Get.context!, (dataBalance) async {
      final userdata = dataBalance[0];
      final items = userdata["items"];

      if (userdata["success"]) {
        if (double.parse(items[0]["amount_bal"].toString()) <
            double.parse(items[0]["min_wallet_bal"].toString())) {
          cb(true);
          Get.back();
          CustomDialog().errorDialog(
            Get.context!,
            "Attention",
            "Your balance is below the required minimum for this feature. "
                "Please ensure a minimum balance of ${items[0]["min_wallet_bal"]} tokens to access the requested service.",
            () {
              Get.back();
            },
          );
          return;
        } else {
          Functions.computeDistanceResorChckIN(Get.context!, destLoc,
              (success) {
            cb(true);
            Get.back();
            if (success["success"]) {
              Get.toNamed(Routes.booking, arguments: {
                "currentLocation": success["location"],
                "areaData": data[0],
                "canCheckIn": success["can_checkIn"],
                "userData": items,
              });
            }
          });
        }
      } else {
        cb(true);
        Get.back();
      }
    });
  }

  //get curr location
  Future<void> getCurrentLoc() async {
    ddRadius.value = "10";
    pTypeCode = "";
    amenities = "";
    vtypeId = "";
    addressText = "".obs;
    isAllowOverNight = "";

    getDefaultLocation();
  }

  //get curr location
  Future<void> getFilterNearest(data) async {
    List ltlng = await Functions.getCurrentPosition();
    LatLng coordinates = LatLng(ltlng[0]["lat"], ltlng[0]["long"]);
    ddRadius.value = data[0]["radius"];
    pTypeCode = data[0]["park_type"];
    amenities = data[0]["amen"];
    vtypeId = data[0]["vh_type"];
    isAllowOverNight = data[0]["ovp"];
    searchCoordinates = coordinates;
    isFilter = true;
    bridgeLocation(coordinates);
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

  void onCameraMoveStarted() {
    isGetNearData.value = false;
    if (panelController.isPanelOpen) {
      panelController.close();
    }
  }

  void onCameraIdle() async {
    isGetNearData.value = true;
    if (suggestions.isEmpty) {
      panelController.open();
    }
  }

  void animateCamera() {
    double filterRadius = Variables.convertToMeters(ddRadius.value);

    circle = Circle(
      circleId: const CircleId('dottedCircle'),
      center: LatLng(searchCoordinates.latitude, searchCoordinates.longitude),
      radius: filterRadius,
      strokeWidth: 0,
      fillColor: AppColor.primaryColor.withOpacity(.03),
    );
    polyline = Polyline(
      polylineId: const PolylineId('dottedCircle'),
      color: AppColor.mainColor,
      width: 4,
      patterns: [
        PatternItem.dash(20),
        PatternItem.gap(20),
      ],
      points: List<LatLng>.generate(
        360,
        (index) => calculateNewCoordinates(
          searchCoordinates.latitude,
          searchCoordinates.longitude,
          filterRadius,
          double.parse(
            index.toString(),
          ),
        ),
      ),
    );
    isLoading.value = false;

    if (gMapController != null) {
      gMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(initialCameraPosition!.target.latitude,
                  initialCameraPosition!.target.longitude),
              zoom: dataNearest.isEmpty ? 14 : 16),
        ),
      );
    }
  }

  void onDrawerOpen() async {
    String? userData = await Authentication().getUserData();
    final item = await Authentication().getUserData2();
    final profPic = await Authentication().getUserProfilePic();

    userProfile = item;
    myProfPic.value = profPic;

    userProfile = item;
    if (jsonDecode(userData!)["first_name"] == null) {
      myName.value = "";
    } else {
      myName.value = jsonDecode(userData)["first_name"];
    }
    update();
  }

  String getIconAssetForPwd(String parkingTypeCode, String vehicleTypes) {
    switch (parkingTypeCode) {
      case "S":
        if (vehicleTypes.contains("Motorcycle") &&
            vehicleTypes.contains("Trikes and Cars")) {
          return 'assets/dashboard_icon/street/cmp_street.png';
        } else if (vehicleTypes.contains("Motorcycle")) {
          return 'assets/dashboard_icon/street/motor_pwd_street.png';
        } else {
          return 'assets/dashboard_icon/street/car_pwd_street.png';
        }
      case "P":
        if (vehicleTypes.contains("Motorcycle") &&
            vehicleTypes.contains("Trikes and Cars")) {
          return 'assets/dashboard_icon/private/cmp_private.png';
        } else if (vehicleTypes.contains("Motorcycle")) {
          return 'assets/dashboard_icon/private/motor_pwd_private.png';
        } else {
          return 'assets/dashboard_icon/private/car_pwd_private.png';
        }
      case "C":
        if (vehicleTypes.contains("Motorcycle") &&
            vehicleTypes.contains("Trikes and Cars")) {
          return 'assets/dashboard_icon/commercial/cmp_commercial.png';
        } else if (vehicleTypes.contains("Motorcycle")) {
          return 'assets/dashboard_icon/commercial/motor_pwd_commercial.png';
        } else {
          return 'assets/dashboard_icon/commercial/car_pwd_commercial.png';
        }
      default:
        return 'assets/dashboard_icon/valet/valet.png';
    }
  }

  String getIconAssetForNonPwd(String parkingTypeCode, String vehicleTypes) {
    switch (parkingTypeCode) {
      case "S":
        if (vehicleTypes.contains("Motorcycle") &&
            vehicleTypes.contains("Trikes and Cars")) {
          return 'assets/dashboard_icon/street/car_motor_street.png';
        } else if (vehicleTypes.contains("Motorcycle")) {
          return 'assets/dashboard_icon/street/motor_street.png';
        } else {
          return 'assets/dashboard_icon/street/car_street.png';
        }
      case "P":
        if (vehicleTypes.contains("Motorcycle") &&
            vehicleTypes.contains("Trikes and Cars")) {
          return 'assets/dashboard_icon/private/car_motor_private.png';
        } else if (vehicleTypes.contains("Motorcycle")) {
          return 'assets/dashboard_icon/private/motor_private.png';
        } else {
          return 'assets/dashboard_icon/private/car_private.png';
        }
      case "C":
        if (vehicleTypes.contains("Motorcycle") &&
            vehicleTypes.contains("Trikes and Cars")) {
          return 'assets/dashboard_icon/commercial/car_motor_commercial.png';
        } else if (vehicleTypes.contains("Motorcycle")) {
          return 'assets/dashboard_icon/commercial/motor_commercial.png';
        } else {
          return 'assets/dashboard_icon/commercial/car_commercial.png';
        }
      case "V":
        return 'assets/dashboard_icon/valet/valet.png'; // Valet
      default:
        return 'assets/dashboard_icon/default.png'; // Fallback icon
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
          iconAsset =
              getIconAssetForPwd(items["parking_type_code"], vehicleTypes);
        } else {
          iconAsset =
              getIconAssetForNonPwd(items["parking_type_code"], vehicleTypes);
        }

        final Uint8List markerIcon =
            await Variables.getBytesFromAsset(iconAsset, 0.5);

        markers.add(
          Marker(
            infoWindow: InfoWindow(title: items["park_area_name"]),
            // ignore: deprecated_member_use
            icon: BitmapDescriptor.fromBytes(markerIcon),
            markerId: MarkerId(ctr.toString()),
            position: LatLng(double.parse(items["pa_latitude"].toString()),
                double.parse(items["pa_longitude"].toString())),
            onTap: () async {
              markerData.clear();
              CustomDialog().loadingDialog(Get.context!);

              markerData.add(items);

              List ltlng = await Functions.getCurrentPosition();
              LatLng coordinates = LatLng(ltlng[0]["lat"], ltlng[0]["long"]);
              LatLng dest = LatLng(
                  double.parse(items["pa_latitude"].toString()),
                  double.parse(items["pa_longitude"].toString()));
              final estimatedData = await Functions.fetchETA(coordinates, dest);

              markerData = markerData.map((e) {
                e["distance_display"] = "${estimatedData[0]["distance"]} away";
                e["time_arrival"] = estimatedData[0]["time"];
                return e;
              }).toList();
              Get.back();

              if (estimatedData[0]["error"] == "No Internet") {
                CustomDialog().internetErrorDialog(Get.context!, () {
                  Get.back();
                });

                return;
              }
              onMarkerTapped(markerData);
            },
          ),
        );
      }
    }
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
        } else {
          suggestions.value = [];
        }
      } else {
        suggestions.value = [];
      }
    } catch (e) {
      CustomDialog().internetErrorDialog(Get.context!, () {
        suggestions.value = [];
        Get.back();
      });
    }
  }

  void showLegend(VoidCallback cb) {
    Get.dialog(LegendDialogScreen(
      callback: cb,
    ));
  }

  void showNearestSuggestDialog() {
    Get.dialog(SuggestionsScreen(
      data: dataNearest,
    ));
  }

  LatLng calculateNewCoordinates(
      double lat, double lon, double radiusInMeters, double angleInDegrees) {
    const double PI = 3.141592653589793;

    double angleInRadians = angleInDegrees * PI / 180.0;
    double radiusInDegrees =
        radiusInMeters / 111320.0; // Approx. meters per degree latitude

    // Calculate the new latitude
    double newLat = lat + radiusInDegrees * cos(angleInRadians);

    // Calculate the new longitude
    double newLon =
        lon + (radiusInDegrees / cos(lat * PI / 180.0)) * sin(angleInRadians);

    // Normalize the longitude to be within -180 to 180 degrees
    if (newLon > 180.0) newLon -= 360.0;
    if (newLon < -180.0) newLon += 360.0;

    return LatLng(newLat, newLon);
  }

  //onMarker tapped
  void onMarkerTapped(data) {
    isMarkerTapped.value = false;
    isGetNearData.value = true;

    // isMarkerTapped.value = !isMarkerTapped.value;
    // isGetNearData.value = !isGetNearData.value;

    Get.bottomSheet(
      DialogMarker(
          markerData: data,
          cb: (datas) {
            isMarkerTapped.value = false;
            isGetNearData.value = true;
          }),
      barrierColor: Colors.black.withOpacity(.1),
      isScrollControlled: true, // Ensure the height is respected
    );
  }

  //on[ anel slide]
}
