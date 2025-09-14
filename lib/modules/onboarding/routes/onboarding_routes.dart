import 'package:get/get.dart';

import '../bindings/onboarding_binding.dart';
import '../bindings/splash_binding.dart';
import '../pages/language_selection_page.dart';
import '../pages/onboarding_page.dart';
import '../pages/splash_page.dart';

class OnboardingRoutes {
  static final routes = [
    GetPage(
      name: '/splash',
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: '/onboarding',
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: '/language',
      page: () => const LanguageSelectionPage(),
      binding: OnboardingBinding(),
    ),
  ];
}