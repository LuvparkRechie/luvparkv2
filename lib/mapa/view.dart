import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_body.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';
import 'package:luvpark_get/custom_widgets/variables.dart';
import 'package:luvpark_get/functions/functions.dart';
import 'package:luvpark_get/internet/internet_conn.dart';
import 'package:luvpark_get/routes/routes.dart';
import 'package:map_picker/map_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'controller.dart';

class DashboardMapScreen extends GetView<DashboardMapController> {
  const DashboardMapScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(DashboardMapController());
    final DashboardMapController ct = Get.find<DashboardMapController>();

    return Obx(() {
      if (!ct.netConnected.value) {
        return const CustomScaffold(children: InternetConn());
      } else if (ct.isLoading.value) {
        return const PopScope(
          canPop: false,
          child: CustomScaffold(
            children: Center(
              child: SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      } else {
        if (double.parse(ct.userBal[0]["amount_bal"].toString()) >=
            double.parse(ct.userBal[0]["min_wallet_bal"].toString())) {
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          ));
          if (ct.isLoadingMap.value) {
            return PopScope(
              canPop: false,
              child: CustomScaffold(
                  children: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                        width: 100,
                        height: 100,
                        image: AssetImage("assets/images/logo.png")),
                    FadeIn(
                      delay: const Duration(milliseconds: 400),
                      child: Shimmer.fromColors(
                        baseColor: Colors.black,
                        highlightColor: Colors.grey[100]!,
                        child: const CustomParagraph(
                            text: 'Getting nearest parking area for you.'),
                      ),
                    ),
                  ],
                ),
              )),
            );
          } else {
            return PopScope(
              canPop: false,
              child: Scaffold(
                extendBody: true,
                extendBodyBehindAppBar: true,
                key: ct.scaffoldKey,
                drawer: Drawer(
                  child: Container(
                    color: AppColor.bodyColor,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        DrawerHeader(
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor,
                            borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(20)),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30,
                                child: Icon(Icons.person,
                                    size: 30, color: Colors.blueAccent),
                              ),
                              SizedBox(height: 10),
                              CustomTitle(
                                text: "Rechie Arnado",
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              CustomParagraph(
                                text: "rechkings20@gmail.com",
                                color: Colors.white70,
                              )
                            ],
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person,
                              color: Colors.blueAccent),
                          title: const CustomParagraph(text: "My Parking"),
                          onTap: () {
                            Get.offAndToNamed(Routes.parking);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.wallet,
                              color: Colors.blueAccent),
                          title: const CustomParagraph(text: "Wallet"),
                          onTap: () {
                            Get.toNamed(Routes.wallet);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings,
                              color: Colors.blueAccent),
                          title: const CustomParagraph(text: "Settings"),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const CustomParagraph(
                            text: "Logout",
                            color: Colors.red,
                          ),
                          onTap: () {
                            // Handle logout
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(child: accessMaps(context, ct, ct.scaffoldKey)),
                    Visibility(
                      visible: !ct.isSidebarVisible.value,
                      child: SlidingUpPanel(
                        maxHeight:
                            MediaQuery.of(Get.context!).viewInsets.bottom != 0
                                ? ct.suggestions.isEmpty
                                    ? (MediaQuery.of(Get.context!)
                                            .viewInsets
                                            .bottom +
                                        20)
                                    : (MediaQuery.of(context).size.height *
                                            .70 -
                                        MediaQuery.of(Get.context!)
                                            .viewInsets
                                            .bottom)
                                : ct.suggestions.isEmpty
                                    ? ct.minHeight.value
                                    : MediaQuery.of(context).size.height * .70,
                        minHeight: ct.minHeight.value,
                        parallaxEnabled: true,
                        parallaxOffset: .3,
                        controller: ct.panelController,
                        header: Container(
                            key: ct.headerKey,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(7)),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Builder(builder: (context) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                final RenderBox renderBox = ct
                                    .headerKey.currentContext!
                                    .findRenderObject() as RenderBox;
                                final double height = renderBox.size.height;
                                if (ct.headerHeight.value != height) {
                                  ct.headerHeight.value = height;
                                  ct.minHeight.value = ct.headerHeight.value;
                                }
                              });
                              return _panel(ct);
                            })),
                        panel: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(7)),
                            color: Colors.white,
                          ),
                          child: _panelContent(ct),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          return PopScope(
              canPop: false,
              child: CustomScaffold(children: accessList(context, ct)));
        }
      }
    });
  }

  Widget _panelContent(ct) {
    return StretchingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      child: ListView.builder(
          padding: EdgeInsets.fromLTRB(15, ct.minHeight.value + 10, 15, 5),
          itemCount: ct.suggestions.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () async {
                      FocusManager.instance.primaryFocus!.unfocus();
                      await Functions.searchPlaces(
                          context, ct.suggestions[index].split("=Rechie=")[0],
                          (searchedPlace) {
                        if (searchedPlace.isEmpty) {
                          return;
                        } else {
                          ct.searchCoordinates =
                              LatLng(searchedPlace[0], searchedPlace[1]);
                          ct.getUserData(true);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          const Image(
                            image:
                                AssetImage("assets/dashboard_icon/parking.png"),
                            width: 34,
                            height: 34,
                          ),
                          Container(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTitle(
                                  text: ct.suggestions[index]
                                          .split("=structured=")[1]
                                          .contains(",")
                                      ? ct.suggestions[index]
                                          .split("=structured=")[1]
                                          .split(",")[0]
                                      : ct.suggestions[index]
                                          .split("=structured=")[1],
                                  maxlines: 1,
                                  fontSize: 16,
                                ),
                                CustomParagraph(
                                  text: ct.suggestions[index]
                                      .split("=Rechie=")[0],
                                  fontSize: 12,
                                  maxlines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  letterSpacing: -0.41,
                                )
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: AppColor.primaryColor,
                          )
                        ],
                      ),
                    )),
                const Divider()
              ],
            );
          }),
    );
  }

  Widget _panel(ct) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
                width: 71,
                height: 6,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(56),
                    color: const Color(0xffd9d9d9))),
          ),
          Container(height: 20),
          Obx(
            () => CustomParagraph(
              text: "${Variables.greeting()}, ${ct.myName.value}",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.41,
            ),
          ),
          const CustomTitle(
            text: "Where do you want to go today?",
            color: Color(0xFF131313),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.41,
          ),
          Container(height: 20),
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: const Color(0xFFFBFBFB),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0x1C2563EB)),
                borderRadius: BorderRadius.circular(48),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/dashboard_icon/search.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: TextField(
                    controller: ct.searchCon,
                    decoration: InputDecoration(
                      hintText: 'Search parking',
                      hintStyle: paragraphStyle(),
                      border: InputBorder.none,
                    ),
                    style: paragraphStyle(color: Colors.black),
                    onChanged: (text) {
                      ct.fetchSuggestions();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 24,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage("assets/dashboard_icon/google_voice.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget accessMaps(BuildContext context, DashboardMapController cs,
      GlobalKey<ScaffoldState> scafKey) {
    return cs.initialCameraPosition == null
        ? const Center(
            child: Text("Loading Map"),
          )
        : Stack(
            children: [
              MapPicker(
                iconWidget: SvgPicture.asset(
                  "assets/dashboard_icon/location_icon.svg",
                  height: 40,
                  width: 40,
                ),
                //add map picker controller
                mapPickerController: cs.mapPickerController,
                child: GoogleMap(
                  mapType: MapType.normal,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  buildingsEnabled: false,
                  tiltGesturesEnabled: true,
                  initialCameraPosition: cs.initialCameraPosition!,
                  markers: Set<Marker>.of(cs.markers),
                  polylines: {cs.polyline},
                  circles: {cs.circle},
                  onMapCreated: cs.onMapCreated,
                  onCameraMoveStarted: cs.onCameraMoveStarted,
                  onCameraMove: cs.onCameraMove,
                  onCameraIdle: () async {
                    cs.onCameraIdle();
                  },
                ),
              ),
              Visibility(
                visible: cs.isGetNearData.value,
                child: Positioned(
                  left: MediaQuery.of(context).size.width / 3.5,
                  top: (MediaQuery.of(context).size.height -
                          cs.minHeight.value) /
                      3,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF0078FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: const Center(
                      child: CustomParagraph(
                        text: "Search this area >",
                        color: Colors.white,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w600,
                        maxlines: 1,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                left: 10,
                bottom: 25,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: Color(0xFFDFE7EF)),
                          borderRadius: BorderRadius.circular(57),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x0C000000),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(),
                            child: const Image(
                              image:
                                  AssetImage("assets/dashboard_icon/car.png"),
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(width: 5),
                          const CustomTitle(text: "Land Cruiser", fontSize: 14),
                          Container(width: 5),
                          CustomLinkLabel(
                            text: "YKB-7635",
                            fontSize: 14,
                            color: AppColor.primaryColor,
                          )
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.parkingAreas,
                            arguments: cs.dataNearest);
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(10),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFFDFE7EF)),
                              borderRadius: BorderRadius.circular(57),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x0C000000),
                                blurRadius: 15,
                                offset: Offset(0, 5),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: const Image(
                            image:
                                AssetImage("assets/dashboard_icon/vh_list.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: Container(
                  width: 178,
                  padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFFDFE7EF)),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x0C000000),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 45,
                        height: 38,
                        child: Image(
                          image: AssetImage("assets/images/logo.png"),
                          width: 37,
                          height: 32,
                        ),
                      ),
                      Container(width: 8),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomParagraph(
                              text: "My balance",
                              maxlines: 1,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                            CustomTitle(
                              text: toCurrencyString(22.toString()),
                              maxlines: 1,
                              fontSize: 18,
                              letterSpacing: -0.41,
                              fontWeight: FontWeight.w900,
                            )
                          ],
                        ),
                      ),
                      Container(width: 8),
                      Icon(
                        Icons.chevron_right_outlined,
                        color: AppColor.secondaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                child: Container(
                  width: 45,
                  height: 45,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFFDFE7EF)),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x0C000000),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: IconButton(
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      progress: cs.animationController.view,
                      color: Colors.blue,
                      size: 30,
                    ),
                    onPressed: () {
                      scafKey.currentState?.openDrawer();
                    },
                  ),
                ),
              ),
            ],
          );
  }

  Widget accessList(BuildContext context, DashboardMapController cs) {
    return StretchingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          itemCount: 4,
          itemBuilder: (context, index) {
            return const ListTile(
              title: Text("Title"),
              leading: Icon(Icons.car_crash),
              subtitle: Text("Subtitle"),
            );
          }),
    );
  }
}
