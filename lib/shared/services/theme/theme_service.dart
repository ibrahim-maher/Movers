import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../storage/local_storage_service.dart';
import '../../../core/constants/storage_keys.dart';

class ThemeService extends GetxService {
  final LocalStorageService _storageService = Get.find<LocalStorageService>();

  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadTheme();
  }

  // Load saved theme
  Future<void> loadTheme() async {
    try {
      final savedTheme = _storageService.getString(StorageKeys.themeMode);

      if (savedTheme != null) {
        switch (savedTheme) {
          case 'light':
            themeMode.value = ThemeMode.light;
            break;
          case 'dark':
            themeMode.value = ThemeMode.dark;
            break;
          case 'system':
          default:
            themeMode.value = ThemeMode.system;
            break;
        }
      }

      // Apply the theme
      Get.changeThemeMode(themeMode.value);

    } catch (e) {
      print('Failed to load theme: $e');
      themeMode.value = ThemeMode.system;
    }
  }

  // Save theme
  Future<void> saveTheme(ThemeMode mode) async {
    try {
      String themeString;
      switch (mode) {
        case ThemeMode.light:
          themeString = 'light';
          break;
        case ThemeMode.dark:
          themeString = 'dark';
          break;
        case ThemeMode.system:
        default:
          themeString = 'system';
          break;
      }

      await _storageService.setString(StorageKeys.themeMode, themeString);
      themeMode.value = mode;

      // Apply the theme
      Get.changeThemeMode(mode);

      // Show confirmation
      Get.snackbar(
        'Theme Changed',
        'Theme updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

    } catch (e) {
      print('Failed to save theme: $e');
      Get.snackbar(
        'Error',
        'Failed to change theme',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Switch to light theme
  Future<void> switchToLight() async {
    await saveTheme(ThemeMode.light);
  }

  // Switch to dark theme
  Future<void> switchToDark() async {
    await saveTheme(ThemeMode.dark);
  }

  // Switch to system theme
  Future<void> switchToSystem() async {
    await saveTheme(ThemeMode.system);
  }

  // Toggle between light and dark
  Future<void> toggleTheme() async {
    if (themeMode.value == ThemeMode.light) {
      await switchToDark();
    } else if (themeMode.value == ThemeMode.dark) {
      await switchToLight();
    } else {
      // If system, switch to opposite of current system theme
      final brightness = Get.mediaQuery.platformBrightness;
      if (brightness == Brightness.dark) {
        await switchToLight();
      } else {
        await switchToDark();
      }
    }
  }

  // Check if current theme is dark
  bool get isDarkMode {
    if (themeMode.value == ThemeMode.system) {
      return Get.mediaQuery.platformBrightness == Brightness.dark;
    }
    return themeMode.value == ThemeMode.dark;
  }

  // Check if current theme is light
  bool get isLightMode {
    if (themeMode.value == ThemeMode.system) {
      return Get.mediaQuery.platformBrightness == Brightness.light;
    }
    return themeMode.value == ThemeMode.light;
  }

  // Check if using system theme
  bool get isSystemMode {
    return themeMode.value == ThemeMode.system;
  }

  // Get theme mode string
  String get themeModeString {
    switch (themeMode.value) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
      default:
        return 'System';
    }
  }
}