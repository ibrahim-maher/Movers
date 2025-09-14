import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../shared/services/storage/local_storage_service.dart';
import '../../../shared/services/language/language_service.dart';
import '../../../modules/auth/services/token_service.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final LocalStorageService _storageService = Get.find<LocalStorageService>();
  final LanguageService _languageService = Get.find<LanguageService>();
  final TokenService _tokenService = Get.find<TokenService>();
  final RxBool isLoading = true.obs;
  final RxString loadingMessage = 'Initializing...'.obs;
  bool _hasNavigated = false;

  @override
  void onInit() {
    super.onInit();
    print('🚀 SplashController initialized');
    _storageService.debugPrint();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    if (_hasNavigated) {
      print('🛑 Navigation already performed, skipping');
      return;
    }

    try {
      print('📱 Starting app initialization...');

      // Wait for services
      await _waitForServices();

      // Debug storage
      _storageService.debugPrint();

      // Show loading for minimum time
      loadingMessage.value = 'Loading...'.tr;
      await Future.delayed(const Duration(seconds: 1));

      // Check app state and navigate
      await _checkAppStateAndNavigate();

    } catch (e) {
      print('❌ App initialization error: $e');
      _navigateToSafePage();
    }
  }

  Future<void> _waitForServices() async {
    print('⏳ Waiting for services...');
    int attempts = 0;
    const maxAttempts = 25; // 5 seconds with 200ms intervals

    while (attempts < maxAttempts) {
      if (Get.isRegistered<LocalStorageService>() &&
          Get.isRegistered<LanguageService>() &&
          Get.isRegistered<TokenService>()) {
        print('✅ All required services ready');
        return;
      }
      await Future.delayed(const Duration(milliseconds: 200));
      attempts++;
    }
    print('⚠️ Services not fully available after $maxAttempts attempts');
  }

  Future<void> _checkAppStateAndNavigate() async {
    print('🔍 Checking app state...');

    final isFirstTime = _storageService.getBool(StorageKeys.isFirstTime, defaultValue: true);
    final hasCompletedOnboarding = _storageService.getBool(StorageKeys.hasCompletedOnboarding, defaultValue: false);
    final isLoggedIn = _storageService.getBool(StorageKeys.isLoggedIn, defaultValue: false);
    final authToken = _tokenService.getToken();
    final currentUser = FirebaseAuth.instance.currentUser;

    print('📋 First time: $isFirstTime');
    print('📋 Onboarding completed: $hasCompletedOnboarding');
    print('🔐 Logged in (storage): $isLoggedIn');
    print('🔐 Token exists: ${authToken != null}');
    print('👤 Firebase user: ${currentUser?.email ?? 'null'}');

    if (isFirstTime) {
      print('👋 First time user - going to language selection');
      _navigateToRoute(AppRoutes.LANGUAGE_SELECTION);
      return;
    }

    if (!hasCompletedOnboarding) {
      print('📖 Going to onboarding');
      _navigateToRoute(AppRoutes.ONBOARDING);
      return;
    }

    if (isLoggedIn && authToken != null && currentUser != null) {
      print('🏠 Going to home');
      _navigateToRoute(AppRoutes.HOME);
    } else {
      print('🔑 Going to login');
      _navigateToRoute(AppRoutes.LOGIN);
    }
  }

  void _navigateToRoute(String route) {
    if (_hasNavigated) {
      print('⚠️ Navigation already occurred, ignoring: $route');
      return;
    }

    _hasNavigated = true;
    isLoading.value = false;

    print('🧭 Navigating to: $route');
    Get.offAllNamed(route);
  }

  void _navigateToSafePage() {
    print('🆘 Navigating to safe page (login)');
    _navigateToRoute(AppRoutes.LOGIN);
  }
}