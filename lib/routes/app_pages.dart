import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/bindings/login_binding.dart';
import '../modules/auth/pages/login_page.dart';
import '../modules/auth/pages/register_page.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/pages/home_page.dart';
import '../modules/load/pages/loads_list_page.dart';
import '../modules/onboarding/pages/splash_page.dart';
import '../modules/onboarding/pages/onboarding_page.dart';
import '../modules/onboarding/pages/language_selection_page.dart';
import '../modules/onboarding/bindings/splash_binding.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
// import '../modules/loads/pages/loads_list_page.dart';
// import '../modules/loads/bindings/loads_binding.dart';
// import '../modules/loads/pages/create_load_page.dart';
// import '../modules/loads/pages/load_details_page.dart';
// import '../modules/loads/pages/edit_load_page.dart';
// import '../modules/loads/pages/load_tracking_page.dart';
// import '../modules/rides/pages/rides_list_page.dart';
// import '../modules/rides/bindings/rides_binding.dart';
// import '../modules/rides/pages/ride_details_page.dart';
// import '../modules/rides/pages/book_ride_page.dart';
// import '../modules/rides/pages/ride_tracking_page.dart';
// import '../modules/rides/pages/ride_history_page.dart';
// import '../modules/parcels/pages/parcels_list_page.dart';
// import '../modules/parcels/bindings/parcels_binding.dart';
// import '../modules/parcels/pages/parcel_details_page.dart';
// import '../modules/parcels/pages/send_parcel_page.dart';
// import '../modules/parcels/pages/parcel_tracking_page.dart';
// import '../modules/parcels/pages/parcel_history_page.dart';
// import '../modules/profile/pages/profile_page.dart';
// import '../modules/profile/bindings/profile_binding.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    // Onboarding Routes
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.ONBOARDING,
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.LANGUAGE_SELECTION,
      page: () => const LanguageSelectionPage(),
    ),

    // Auth Routes
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),

    // Home Routes
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),

    // // Load Routes
    // GetPage(
    //   name: AppRoutes.LOADS_LIST,
    //   page: () => const LoadsListPage(),
    //   binding: LoadsBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.LOAD_DETAILS,
    //   page: () => const LoadDetailsPage(),
    //   binding: LoadsBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.CREATE_LOAD,
    //   page: () => const CreateLoadPage(),
    //   binding: LoadsBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.EDIT_LOAD,
    //   page: () => const EditLoadPage(),
    //   binding: LoadsBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.LOAD_TRACKING,
    //   page: () => const LoadTrackingPage(),
    //   binding: LoadsBinding(),
    // ),
    //
    // // Ride Routes
    // GetPage(
    //   name: AppRoutes.RIDES_LIST,
    //   page: () => const RidesListPage(),
    //   binding: RidesBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.RIDE_DETAILS,
    //   page: () => const RideDetailsPage(),
    //   binding: RidesBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.BOOK_RIDE,
    //   page: () => const BookRidePage(),
    //   binding: RidesBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.RIDE_TRACKING,
    //   page: () => const RideTrackingPage(),
    //   binding: RidesBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.RIDE_HISTORY,
    //   page: () => const RideHistoryPage(),
    //   binding: RidesBinding(),
    // ),
    //
    // // Parcel Routes
    // GetPage(
    //   name: AppRoutes.PARCELS_LIST,
    //   page: () => const ParcelsListPage(),
    //   binding: ParcelsBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.PARCEL_DETAILS,
    //   page: () => const ParcelDetailsPage(),
    //   binding: ParcelsBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.SEND_PARCEL,
    //   page: () => const SendParcelPage(),
    //   binding: ParcelsBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.PARCEL_TRACKING,
    //   page: () => const ParcelTrackingPage(),
    //   binding: ParcelsBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.PARCEL_HISTORY,
    //   page: () => const ParcelHistoryPage(),
    //   binding: ParcelsBinding(),
    // ),
    //
    // // Profile Routes
    // GetPage(
    //   name: AppRoutes.PROFILE,
    //   page: () => const ProfilePage(),
    //   binding: ProfileBinding(),
    // ),
  ];
}