// lib/routes/app_pages.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/bindings/login_binding.dart';
import '../modules/auth/pages/login_page.dart';
import '../modules/auth/pages/register_page.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/bindings/navigation_binding.dart';
import '../modules/home/pages/home_page.dart';
import '../modules/home/pages/main_navigation_page.dart';
import '../modules/load/routes/load_routes.dart';
import '../modules/onboarding/pages/splash_page.dart';
import '../modules/onboarding/pages/onboarding_page.dart';
import '../modules/onboarding/pages/language_selection_page.dart';
import '../modules/onboarding/bindings/splash_binding.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String mainNavigation = '/main';

  static final routes = [
    ...LoadRoutes.routes,

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

    // Main Navigation with Bottom Tabs
    GetPage(
      name: mainNavigation,
      page: () => const MainNavigationPage(),
      binding: NavigationBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Home Routes (redirects to main navigation)
    GetPage(
      name: AppRoutes.HOME,
      page: () => const MainNavigationPage(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: home,
      page: () => const MainNavigationPage(),
      binding: NavigationBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: dashboard,
      page: () => const MainNavigationPage(),
      binding: NavigationBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Standalone Home Page (if needed for direct access)
    GetPage(
      name: '/home-only',
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),


    GetPage(
      name: '/rides',
      page: () => const Scaffold(
        body: Center(
          child: Text(
            'Find Rides\nComing Soon',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    ),
    GetPage(
      name: '/send-parcel',
      page: () => const Scaffold(
        body: Center(
          child: Text(
            'Send Parcel\nComing Soon',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    ),
    GetPage(
      name: '/bids',
      page: () => const Scaffold(
        body: Center(
          child: Text(
            'Place Bid\nComing Soon',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    ),
    GetPage(
      name: '/notifications',
      page: () => const Scaffold(
        body: Center(
          child: Text(
            'Notifications\nComing Soon',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    ),
    GetPage(
      name: '/profile',
      page: () => const Scaffold(
        body: Center(
          child: Text(
            'Profile\nComing Soon',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    ),
  ];
}