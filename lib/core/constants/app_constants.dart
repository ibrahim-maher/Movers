// App Constants 
// lib/core/constants/app_constants.dart

class AppConstants {
  // App Information
  static const String appName = 'Movers App';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Company Information
  static const String companyName = 'Movers Company';
  static const String supportEmail = 'support@movers.com';
  static const String supportPhone = '+1234567890';

  // App Settings
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache
  static const int cacheMaxAge = 3600; // 1 hour in seconds
  static const int imageCacheMaxAge = 86400; // 24 hours in seconds

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;

  // Location
  static const double defaultLatitude = 24.7136;
  static const double defaultLongitude = 46.6753; // Riyadh coordinates
  static const double locationUpdateDistanceFilter = 10.0; // meters
  static const Duration locationUpdateInterval = Duration(seconds: 5);

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayTimeFormat = 'hh:mm a';

  // Currency
  static const String defaultCurrency = 'SAR';
  static const String currencySymbol = 'ر.س';

  // Social Media
  static const String facebookUrl = 'https://facebook.com/moversapp';
  static const String twitterUrl = 'https://twitter.com/moversapp';
  static const String instagramUrl = 'https://instagram.com/moversapp';
  static const String linkedinUrl = 'https://linkedin.com/company/moversapp';

  // Legal
  static const String privacyPolicyUrl = 'https://movers.com/privacy';
  static const String termsOfServiceUrl = 'https://movers.com/terms';
  static const String aboutUsUrl = 'https://movers.com/about';

  // Rating
  static const double minRating = 1.0;
  static const double maxRating = 5.0;
  static const double defaultRating = 3.0;

  // Notification Types
  static const String notificationTypeGeneral = 'general';
  static const String notificationTypeBooking = 'booking';
  static const String notificationTypePayment = 'payment';
  static const String notificationTypePromotion = 'promotion';

  // Load Status
  static const String loadStatusPending = 'pending';
  static const String loadStatusConfirmed = 'confirmed';
  static const String loadStatusInProgress = 'in_progress';
  static const String loadStatusCompleted = 'completed';
  static const String loadStatusCancelled = 'cancelled';

  // Ride Status
  static const String rideStatusAvailable = 'available';
  static const String rideStatusBooked = 'booked';
  static const String rideStatusInProgress = 'in_progress';
  static const String rideStatusCompleted = 'completed';
  static const String rideStatusCancelled = 'cancelled';

  // Parcel Status
  static const String parcelStatusPending = 'pending';
  static const String parcelStatusPickedUp = 'picked_up';
  static const String parcelStatusInTransit = 'in_transit';
  static const String parcelStatusDelivered = 'delivered';
  static const String parcelStatusReturned = 'returned';

  // Bid Status
  static const String bidStatusOpen = 'open';
  static const String bidStatusClosed = 'closed';
  static const String bidStatusAccepted = 'accepted';
  static const String bidStatusRejected = 'rejected';
  static const String bidStatusExpired = 'expired';

  // Payment Status
  static const String paymentStatusPending = 'pending';
  static const String paymentStatusCompleted = 'completed';
  static const String paymentStatusFailed = 'failed';
  static const String paymentStatusRefunded = 'refunded';
  static const String paymentStatusCancelled = 'cancelled';

  // Vehicle Types
  static const String vehicleTypeSmallCar = 'small_car';
  static const String vehicleTypeSedanCar = 'sedan_car';
  static const String vehicleTypeSUV = 'suv';
  static const String vehicleTypePickupTruck = 'pickup_truck';
  static const String vehicleTypeSmallTruck = 'small_truck';
  static const String vehicleTypeLargeTruck = 'large_truck';

  // Parcel Sizes
  static const String parcelSizeSmall = 'small';
  static const String parcelSizeMedium = 'medium';
  static const String parcelSizeLarge = 'large';
  static const String parcelSizeExtraLarge = 'extra_large';

  // Error Messages
  static const String errorGeneral = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorTimeout = 'Request timeout. Please try again.';
  static const String errorServer = 'Server error. Please try again later.';
  static const String errorUnauthorized = 'Unauthorized access. Please login again.';
  static const String errorNotFound = 'Resource not found.';
  static const String errorValidation = 'Please check your input and try again.';
}