// app_routes.dart
abstract class AppRoutes {
  AppRoutes._();

  // Onboarding Routes
  static const SPLASH = '/';
  static const ONBOARDING = '/onboarding';
  static const LANGUAGE_SELECTION = '/language-selection';

  // Auth Routes
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const OTP_VERIFICATION = '/otp-verification';



  // Main App Routes
  static const HOME = '/home';
  static const DASHBOARD = '/dashboard';

  // Load Routes
  static const LOADS_LIST = '/loads';
  static const LOAD_DETAILS = '/load-details';
  static const CREATE_LOAD = '/create-load';
  static const EDIT_LOAD = '/edit-load';
  static const LOAD_TRACKING = '/load-tracking';

  // Ride Routes
  static const RIDES_LIST = '/rides';
  static const RIDE_DETAILS = '/ride-details';
  static const BOOK_RIDE = '/book-ride';
  static const RIDE_TRACKING = '/ride-tracking';
  static const RIDE_HISTORY = '/ride-history';

  // Parcel Routes
  static const PARCELS_LIST = '/parcels';
  static const PARCEL_DETAILS = '/parcel-details';
  static const SEND_PARCEL = '/send-parcel';
  static const PARCEL_TRACKING = '/parcel-tracking';
  static const PARCEL_HISTORY = '/parcel-history';

  // Bid Routes
  static const BIDS_LIST = '/bids';
  static const BID_DETAILS = '/bid-details';
  static const PLACE_BID = '/place-bid';
  static const BID_MANAGEMENT = '/bid-management';
  static const BID_HISTORY = '/bid-history';

  // Payment Routes
  static const PAYMENT = '/payment';
  static const PAYMENT_METHODS = '/payment-methods';
  static const ADD_PAYMENT_METHOD = '/add-payment-method';
  static const PAYMENT_HISTORY = '/payment-history';
  static const TRANSACTION_DETAILS = '/transaction-details';

  // Profile Routes
  static const PROFILE = '/profile';
  static const EDIT_PROFILE = '/edit-profile';
  static const SETTINGS = '/settings';
  static const PREFERENCES = '/preferences';
  static const ACCOUNT = '/account';

  // Notification Routes
  static const NOTIFICATIONS = '/notifications';
  static const NOTIFICATION_SETTINGS = '/notification-settings';
}