import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/services/language/language_service.dart';
import '../../../shared/services/storage/local_storage_service.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../routes/app_routes.dart';
import '../models/language_model.dart';

class LanguageSelectionController extends GetxController {
  final LanguageService _languageService = Get.find<LanguageService>();
  final LocalStorageService _storageService = Get.find<LocalStorageService>();

  final RxList<LanguageModel> availableLanguages = <LanguageModel>[].obs;
  final Rx<LanguageModel?> selectedLanguage = Rx<LanguageModel?>(null);
  final RxBool isChanging = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeLanguages();
    _loadCurrentLanguage();
  }

  void _initializeLanguages() {
    availableLanguages.value = [
      LanguageModel(
        name: 'English',
        nativeName: 'English',
        code: 'en',
        countryCode: 'US',
        locale: const Locale('en', 'US'),
        flag: '🇺🇸',
      ),
      LanguageModel(
        name: 'Arabic',
        nativeName: 'العربية',
        code: 'ar',
        countryCode: 'SA',
        locale: const Locale('ar', 'SA'),
        flag: '🇸🇦',
      ),
      LanguageModel(
        name: 'French',
        nativeName: 'Français',
        code: 'fr',
        countryCode: 'FR',
        locale: const Locale('fr', 'FR'),
        flag: '🇫🇷',
      ),
      LanguageModel(
        name: 'Spanish',
        nativeName: 'Español',
        code: 'es',
        countryCode: 'ES',
        locale: const Locale('es', 'ES'),
        flag: '🇪🇸',
      ),
    ];
  }

  void _loadCurrentLanguage() {
    final currentLocale = Get.locale;
    selectedLanguage.value = availableLanguages.firstWhereOrNull(
          (lang) => lang.locale == currentLocale,
    ) ?? availableLanguages.first;
    print('📖 Loaded current language: ${selectedLanguage.value?.code}');
  }

  Future<void> changeLanguage(LanguageModel language) async {
    if (selectedLanguage.value == language) {
      print('⚠️ Language ${language.code} already selected, skipping');
      // Navigate to the next screen if the same language is selected
      await _proceedToNextScreen();
      return;
    }

    try {
      isChanging.value = true;
      print('🌐 Changing language to: ${language.code}');

      // Change app locale
      await Get.updateLocale(language.locale);

      // Save language preference
      await _languageService.setLanguage(language.code);

      // Update selected language
      selectedLanguage.value = language;

      // Mark as not first time
      await _storageService.setBool(StorageKeys.isFirstTime, false);
      print('✅ Set isFirstTime to false');

      // Show success message
      Get.snackbar(
        'Success'.tr,
        'Language changed successfully'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // Proceed to the next screen
      await _proceedToNextScreen();

    } catch (e) {
      print('❌ Failed to change language: $e');
      Get.snackbar(
        'Error'.tr,
        'Failed to change language'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isChanging.value = false;
    }
  }

  Future<void> _proceedToNextScreen() async {
    // Check onboarding status to determine the next route
    final hasCompletedOnboarding = _storageService.getBool(
      StorageKeys.hasCompletedOnboarding,
      defaultValue: false,
    );
    print('📋 Onboarding completed: $hasCompletedOnboarding');

    final nextRoute =
    hasCompletedOnboarding ? AppRoutes.LOGIN : AppRoutes.ONBOARDING;
    print('🧭 Navigating to: $nextRoute');

    // Delay navigation slightly for better UX
    await Future.delayed(const Duration(milliseconds: 500));
    Get.offAllNamed(nextRoute);
  }

  bool isSelected(LanguageModel language) {
    return selectedLanguage.value == language;
  }
}