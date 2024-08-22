import 'package:get/get.dart';
import 'package:luvpark_get/about_us/index.dart';
import 'package:luvpark_get/mapa/utils/bindings.dart';
import 'package:luvpark_get/mapa/utils/view.dart';
import 'package:luvpark_get/faq/index.dart';
import 'package:luvpark_get/profile/index.dart';
import 'package:luvpark_get/profile/view.dart';
import 'package:luvpark_get/rate_booking/index.dart';
import 'package:luvpark_get/wallet_qr/index.dart';
import 'package:luvpark_get/wallet_recharge/index.dart';
import '../activate_acc/index.dart';
import '../booking/index.dart';
import '../booking/utils/booking_receipt/index.dart';
import '../booking_notice/index.dart';
import '../landing/bindings.dart';
import '../landing/view.dart';
import '../login/index.dart';
import '../main.dart';
import '../mapa/index.dart';
import '../onboarding/index.dart';
import '../parking/index.dart';
import '../parking_areas/index.dart';
import '../parking_details/index.dart';
import '../permission/permission.dart';

import '../registration/index.dart';
import '../registration/utils/otp_screen/index.dart';
import '../splash_screen/index.dart';
import '../terms/index.dart';
import '../wallet/index.dart';
import '../wallet_otp/index.dart';
import '../wallet_send/index.dart';
import 'routes.dart';

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
    GetPage(
      name: Routes.wallet,
      page: () => const WalletScreen(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: Routes.qrwallet,
      page: () => const QrWallet(),
      binding: QrWalletBinding(),
    ),
    GetPage(
      name: Routes.booking,
      page: () => const BookingPage(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: Routes.bookingNotice,
      page: () => const BookingNotice(),
      binding: BookingNoticeBinding(),
    ),
    GetPage(
      name: Routes.bookingReceipt,
      page: () => BookingReceipt(),
      binding: BookingReceiptBinding(),
    ),
    GetPage(
      name: Routes.walletsend,
      page: () => const WalletSend(),
      binding: WalletSendBinding(),
    ),
    GetPage(
      name: Routes.rateBooking,
      page: () => RateBooking(),
      binding: RateBookingBinding(),
    ),
    GetPage(
      name: Routes.walletotp,
      page: () => const WalletOtp(),
      binding: WalletOtpBinding(),
    ),
    GetPage(
      name: Routes.faqpage,
      page: () => const FaqPage(),
      binding: FaqPageBinding(),
    ),
    GetPage(
      name: Routes.mapFilter,
      page: () => const FilterMap(),
      binding: FilterMapBinding(),
    ),
    GetPage(
      name: Routes.walletrecharge,
      page: () => const WalletRechargeScreen(),
      binding: WalletRechargeBinding(),
    ),
    GetPage(
      name: Routes.aboutus,
      page: () => const AboutUs(),
      binding: AboutUsBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const Profile(),
      binding: ProfileScreenBinding(),
    ),
  ];
}
