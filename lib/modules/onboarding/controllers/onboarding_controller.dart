import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/onboarding_item_model.dart';
import '../../../shared/services/storage/local_storage_service.dart';
import '../../../routes/app_routes.dart';
import '../../../core/constants/storage_keys.dart';

class OnboardingController extends GetxController {
  final LocalStorageService _storageService = Get.find<LocalStorageService>();

  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;
  final RxBool isLastPage = false.obs;

  final List<OnboardingItem> onboardingItems = [
    OnboardingItem(
      title: 'onboarding_title_1'.tr,
      subtitle: 'onboarding_subtitle_1'.tr,
      image: 'assets/images/illustrations/onboarding/welcome.svg',
    ),
    OnboardingItem(
      title: 'onboarding_title_2'.tr,
      subtitle: 'onboarding_subtitle_2'.tr,
      image: 'assets/images/illustrations/onboarding/features.svg',
    ),
    OnboardingItem(
      title: 'onboarding_title_3'.tr,
      subtitle: 'onboarding_subtitle_3'.tr,
      image: 'assets/images/illustrations/onboarding/get_started.svg',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(_onPageChanged);
  }

  @override
  void onClose() {
    pageController.removeListener(_onPageChanged);
    pageController.dispose();
    super.onClose();
  }

  void _onPageChanged() {
    currentIndex.value = pageController.page?.round() ?? 0;
    isLastPage.value = currentIndex.value == onboardingItems.length - 1;
  }

  void nextPage() {
    if (currentIndex.value < onboardingItems.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void previousPage() {
    if (currentIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  Future<void> completeOnboarding() async {
    try {
      // Mark onboarding as completed
      await _storageService.setBool(
        StorageKeys.hasCompletedOnboarding,
        true,
      );

      // Navigate to login/signup page
      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to save onboarding status'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void goToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}