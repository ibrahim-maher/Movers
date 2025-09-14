// App Config 
class AppConfig {
  static const String appName = 'Movers App';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'https://api.moversapp.com';
  static const String apiVersion = 'v1';

  // Animation durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // App Configuration
  static bool isProduction = true;
  static bool enableLogging = !isProduction;

  static void initialize() {
    // Initialize any required configurations
  }
}