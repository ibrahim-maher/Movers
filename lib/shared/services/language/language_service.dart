import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../storage/local_storage_service.dart';
import '../../../core/constants/storage_keys.dart';

class LanguageService extends GetxService {
  final LocalStorageService _storageService = Get.find<LocalStorageService>();

  final Rx<Locale> currentLocale = const Locale('en', 'US').obs;

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('ar', 'SA'), // Arabic
    Locale('fr', 'FR'), // French
    Locale('es', 'ES'), // Spanish
  ];

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadLanguage();
  }

  // Load saved language
  Future<void> loadLanguage() async {
    try {
      final savedLanguage = _storageService.getString(StorageKeys.languageCode);

      if (savedLanguage != null) {
        // Find the corresponding locale
        final locale = _getLocaleFromLanguageCode(savedLanguage);
        if (locale != null) {
          currentLocale.value = locale;
          await Get.updateLocale(locale);
        }
      } else {
        // Use device locale if supported, otherwise default to English
        final deviceLocale = Get.deviceLocale;
        if (deviceLocale != null && _isSupportedLocale(deviceLocale)) {
          currentLocale.value = deviceLocale;
          await Get.updateLocale(deviceLocale);
        }
      }
    } catch (e) {
      print('Failed to load language: $e');
      // Fallback to English
      currentLocale.value = const Locale('en', 'US');
      await Get.updateLocale(currentLocale.value);
    }
  }

  // Save language
  Future<void> setLanguage(String languageCode) async {
    try {
      final locale = _getLocaleFromLanguageCode(languageCode);

      if (locale != null && _isSupportedLocale(locale)) {
        await _storageService.setString(StorageKeys.languageCode, languageCode);
        currentLocale.value = locale;
        await Get.updateLocale(locale);

        print('Language changed to: $languageCode');
      } else {
        throw Exception('Unsupported language code: $languageCode');
      }
    } catch (e) {
      print('Failed to set language: $e');
      throw e;
    }
  }

  // Get locale from language code
  Locale? _getLocaleFromLanguageCode(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'en':
        return const Locale('en', 'US');
      case 'ar':
        return const Locale('ar', 'SA');
      case 'fr':
        return const Locale('fr', 'FR');
      case 'es':
        return const Locale('es', 'ES');
      default:
        return null;
    }
  }

  // Check if locale is supported
  bool _isSupportedLocale(Locale locale) {
    return supportedLocales.any((supportedLocale) =>
    supportedLocale.languageCode == locale.languageCode);
  }

  // Get current language code
  String get currentLanguageCode {
    return currentLocale.value.languageCode;
  }

  // Get current country code
  String get currentCountryCode {
    return currentLocale.value.countryCode ?? 'US';
  }

  // Check if current language is RTL
  bool get isRTL {
    return currentLanguageCode == 'ar';
  }

  // Get language name
  String getLanguageName(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      case 'fr':
        return 'Français';
      case 'es':
        return 'Español';
      default:
        return 'Unknown';
    }
  }

  // Get native language name
  String getNativeLanguageName(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      case 'fr':
        return 'Français';
      case 'es':
        return 'Español';
      default:
        return 'Unknown';
    }
  }

  // Get all supported languages
  List<Map<String, String>> getSupportedLanguages() {
    return [
      {'code': 'en', 'name': 'English', 'nativeName': 'English'},
      {'code': 'ar', 'name': 'Arabic', 'nativeName': 'العربية'},
      {'code': 'fr', 'name': 'French', 'nativeName': 'Français'},
      {'code': 'es', 'name': 'Spanish', 'nativeName': 'Español'},
    ];
  }

  // Reset to default language
  Future<void> resetToDefault() async {
    await setLanguage('en');
  }
}