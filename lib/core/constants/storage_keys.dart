class StorageKeys {
  StorageKeys._();

  // Onboarding
  static const String hasCompletedOnboarding = 'has_completed_onboarding';

  // Authentication
  static const String isLoggedIn = 'is_logged_in';
  static const String userToken = 'user_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';

  // App Settings
  static const String languageCode = 'language_code';
  static const String themeMode = 'theme_mode';
  static const String isFirstTime = 'is_first_time';

  // User Preferences
  static const String notificationsEnabled = 'notifications_enabled';
  static const String pushNotificationsEnabled = 'push_notifications_enabled';
  static const String locationPermissionGranted = 'location_permission_granted';

  // Cache
  static const String lastSyncTime = 'last_sync_time';
  static const String cachedUserData = 'cached_user_data';
}