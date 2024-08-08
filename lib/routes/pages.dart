import 'package:get/get.dart';
import 'package:luvpark_get/activate_acc/index.dart';
import 'package:luvpark_get/login/bindings.dart';
import 'package:luvpark_get/login/view.dart';
import 'package:luvpark_get/main.dart';
import 'package:luvpark_get/mapa/index.dart';
import 'package:luvpark_get/onboarding/bindings.dart';
import 'package:luvpark_get/onboarding/view.dart';
import 'package:luvpark_get/otp_screen/index.dart';
import 'package:luvpark_get/parking/bindings.dart';
import 'package:luvpark_get/parking/view.dart';
import 'package:luvpark_get/parking_areas/index.dart';
import 'package:luvpark_get/parking_details/bindings.dart';
import 'package:luvpark_get/parking_details/view.dart';
import 'package:luvpark_get/permission/permission.dart';
import 'package:luvpark_get/registration/index.dart';
import 'package:luvpark_get/routes/routes.dart';
import 'package:luvpark_get/splash_screen/bindings.dart';
import 'package:luvpark_get/splash_screen/view.dart';
import 'package:luvpark_get/terms/bindings.dart';
import 'package:luvpark_get/terms/view.dart';

import '../landing/bindings.dart';
import '../landing/view.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
        name: Routes.onboarding,
        page: () => const MyOnboardingPage(),
        binding: OnboardingBinding()),
    GetPage(
        name: Routes.landing,
        page: () => const LandingScreen(),
        binding: LandingBinding()),
    GetPage(
        name: Routes.terms,
        page: () => const TermsOfUse(),
        binding: TermsOfUseBinding()),
    GetPage(
        name: Routes.login,
        page: () => LoginScreen(),
        binding: LoginScreenBinding()),
    // GetPage(
    //     name: Routes.dashboard,
    //     page: () => const DashboardScreen(),
    //     binding: DashboardBinding()),
    GetPage(
        name: Routes.registration,
        page: () => const RegistrationPage(),
        binding: RegistrationBinding()),
    GetPage(
      name: Routes.otp,
      page: () => const OtpScreen(),
      binding: OtpBinding(),
    ),

    GetPage(
      name: Routes.loading,
      page: () => const LoadingPage(),
    ),
    GetPage(
      name: Routes.activate,
      page: () => const ActivateAccount(),
      binding: ActivateAccBinding(),
    ),
    GetPage(
      name: Routes.permission,
      page: () => const PermissionHandlerScreen(),
    ),
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.parking,
      page: () => const ParkingScreen(),
      binding: ParkingBinding(),
    ),
    GetPage(
      name: Routes.parkingAreas,
      page: () => const ParkingAreas(),
      binding: ParkingAreasBinding(),
    ),
    GetPage(
      name: Routes.parkingDetails,
      page: () => const ParkingDetails(),
      binding: ParkingDetailsBinding(),
    ),
    GetPage(
      name: Routes.map,
      page: () => const DashboardMapScreen(),
      binding: DashboardMapBinding(),
    ),
  ];
}
