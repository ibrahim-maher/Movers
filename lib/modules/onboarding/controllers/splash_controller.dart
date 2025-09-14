import 'package:get/get.dart';
import '../../../shared/services/storage/local_storage_service.dart';
import '../../../shared/services/firebase/firebase_service.dart';
import '../../../routes/app_routes.dart';
import '../../../core/constants/storage_keys.dart';

class SplashController extends GetxController {
  final LocalStorageService _storageService = Get.find<LocalStorageService>();
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  final RxBool isLoading = true.obs;
  final RxString loadingMessage = 'Initializing...'.tr.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize Firebase services
      loadingMessage.value = 'Connecting to services...'.tr;
      await _firebaseService.initialize();

      // Simulate loading time for better UX
      await Future.delayed(const Duration(seconds: 2));

      // Check if user has completed onboarding
      await _checkOnboardingStatus();

    } catch (e) {
      // Handle initialization error
      Get.snackbar(
        'Error'.tr,
        'Failed to initialize app. Please try again.'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      final hasCompletedOnboarding = await _storageService.getBool(
        StorageKeys.hasCompletedOnboarding,
      );

      final isLoggedIn = await _storageService.getBool(
        StorageKeys.isLoggedIn,
      );

      // Navigate based on app state
      if (hasCompletedOnboarding == true) {
        if (isLoggedIn == true) {
          // User is logged in, go to home
          Get.offAllNamed(AppRoutes.HOME);
        } else {
          // User needs to login
          Get.offAllNamed(AppRoutes.LOGIN);
        }
      } else {
        // Show onboarding
        Get.offAllNamed(AppRoutes.ONBOARDING);
      }
    } catch (e) {
      // If there's an error, show onboarding as fallback
      Get.offAllNamed(AppRoutes.ONBOARDING);
    }
  }

  void skipToLogin() {
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  void skipToHome() {
    Get.offAllNamed(AppRoutes.HOME);
  }
}