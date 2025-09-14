import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/language_model.dart';
import '../../../shared/services/language/language_service.dart';

class LanguageSelectionController extends GetxController {
  final LanguageService _languageService = Get.find<LanguageService>();

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
  }

  Future<void> changeLanguage(LanguageModel language) async {
    if (selectedLanguage.value == language) return;

    try {
      isChanging.value = true;

      // Change app locale
      await Get.updateLocale(language.locale);

      // Save language preference
      await _languageService.setLanguage(language.code);

      // Update selected language
      selectedLanguage.value = language;

      // Show success message
      Get.snackbar(
        'Success'.tr,
        'Language changed successfully'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // Go back to previous screen
      await Future.delayed(const Duration(milliseconds: 500));
      Get.back();

    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to change language'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isChanging.value = false;
    }
  }

  bool isSelected(LanguageModel language) {
    return selectedLanguage.value == language;
  }
}