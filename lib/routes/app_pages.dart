// app_pages.dart
import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/bindings/login_binding.dart';
import '../modules/auth/pages/login_page.dart';
import '../modules/auth/pages/register_page.dart';
import 'app_routes.dart';

// Onboarding
import '../modules/onboarding/pages/splash_page.dart';
import '../modules/onboarding/pages/onboarding_page.dart';
import '../modules/onboarding/pages/language_selection_page.dart';
import '../modules/onboarding/bindings/splash_binding.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';

// Auth
// import '../modules/auth/pages/login_page.dart';
// import '../modules/auth/pages/register_page.dart';
// import '../modules/auth/bindings/login_binding.dart';
// import '../modules/auth/bindings/register_binding.dart';

// Home
// import '../modules/home/pages/home_page.dart';
// import '../modules/home/bindings/home_binding.dart';

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

    // // Home Routes
    // GetPage(
    //   name: AppRoutes.HOME,
    //   page: () => const HomePage(),
    //   binding: HomeBinding(),
    // ),
  ];
}