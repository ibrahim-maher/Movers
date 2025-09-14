
// ===================================
// shared/services/language/language_service.dart
// ===================================
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../storage/local_storage_service.dart';
import '../../../core/constants/storage_keys.dart';

class LanguageService extends GetxService {
  LocalStorageService? _storageService;
  final Rx<Locale> currentLocale = const Locale('en', 'US').obs;

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ar', 'SA'),
    Locale('fr', 'FR'),
    Locale('es', 'ES'),
  ];

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      // Wait a bit for storage service to be ready
      await Future.delayed(const Duration(milliseconds: 200));

      if (Get.isRegistered<LocalStorageService>()) {
        _storageService = Get.find<LocalStorageService>();
        await loadLanguage();
        print('✅ LanguageService initialized');
      } else {
        print('⚠️ LocalStorageService not available, using defaults');
        currentLocale.value = const Locale('en', 'US');
      }
    } catch (e) {
      print('❌ LanguageService initialization error: $e');
      currentLocale.value = const Locale('en', 'US');
    }
  }

  Future<void> loadLanguage() async {
    try {
      if (_storageService == null) return;

      final savedLanguage = _storageService!.getString(StorageKeys.languageCode);
      print('📖 Loading saved language: $savedLanguage');

      if (savedLanguage != null) {
        final locale = _getLocaleFromLanguageCode(savedLanguage);
        if (locale != null && _isSupportedLocale(locale)) {
          currentLocale.value = locale;
          await Get.updateLocale(locale);
          print('✅ Language loaded: ${locale.languageCode}');
          return;
        }
      }

      // Try device locale as fallback
      final deviceLocale = Get.deviceLocale;
      if (deviceLocale != null && _isSupportedLocale(deviceLocale)) {
        currentLocale.value = deviceLocale;
        await Get.updateLocale(deviceLocale);
        print('✅ Using device locale: ${deviceLocale.languageCode}');
      } else {
        // Use default English
        currentLocale.value = const Locale('en', 'US');
        await Get.updateLocale(currentLocale.value);
        print('✅ Using default locale: en');
      }
    } catch (e) {
      print('❌ Failed to load language: $e');
      currentLocale.value = const Locale('en', 'US');
      await Get.updateLocale(currentLocale.value);
    }
  }

  Future<void> setLanguage(String languageCode) async {
    try {
      print('🌐 Setting language to: $languageCode');

      final locale = _getLocaleFromLanguageCode(languageCode);
      if (locale == null || !_isSupportedLocale(locale)) {
        throw Exception('Unsupported language code: $languageCode');
      }

      // Update current locale
      currentLocale.value = locale;
      await Get.updateLocale(locale);

      // Save to storage if available
      if (_storageService != null) {
        _storageService!.setString(StorageKeys.languageCode, languageCode);
      }

      print('✅ Language changed to: $languageCode');
    } catch (e) {
      print('❌ Failed to set language: $e');
      // Don't rethrow, just log the error
    }
  }

  Locale? _getLocaleFromLanguageCode(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'en': return const Locale('en', 'US');
      case 'ar': return const Locale('ar', 'SA');
      case 'fr': return const Locale('fr', 'FR');
      case 'es': return const Locale('es', 'ES');
      default: return null;
    }
  }

  bool _isSupportedLocale(Locale locale) {
    return supportedLocales.any((supported) =>
    supported.languageCode == locale.languageCode);
  }

  // Getters
  String get currentLanguageCode => currentLocale.value.languageCode;
  String get currentCountryCode => currentLocale.value.countryCode ?? 'US';
  bool get isRTL => currentLanguageCode == 'ar';

  String getLanguageName(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'en': return 'English';
      case 'ar': return 'العربية';
      case 'fr': return 'Français';
      case 'es': return 'Español';
      default: return 'Unknown';
    }
  }

  List<Map<String, String>> getSupportedLanguages() {
    return [
      {'code': 'en', 'name': 'English', 'nativeName': 'English'},
      {'code': 'ar', 'name': 'Arabic', 'nativeName': 'العربية'},
      {'code': 'fr', 'name': 'French', 'nativeName': 'Français'},
      {'code': 'es', 'name': 'Spanish', 'nativeName': 'Español'},
    ];
  }

  Future<void> resetToDefault() async {
    await setLanguage('en');
  }
}