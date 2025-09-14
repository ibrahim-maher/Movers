// API Constants 
// lib/core/constants/api_constants.dart

class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://api.movers.com/v1';
  static const String baseUrlStaging = 'https://staging-api.movers.com/v1';
  static const String baseUrlDev = 'https://dev-api.movers.com/v1';

  // API Versions
  static const String apiVersion = 'v1';
  static const String apiKey = 'your-api-key';

  // Headers
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
  static const String acceptLanguage = 'Accept-Language';
  static const String userAgent = 'User-Agent';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String socialLogin = '/auth/social-login';
  static const String deleteAccount = '/auth/delete-account';

  // User/Profile Endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  static const String changePassword = '/user/change-password';
  static const String uploadAvatar = '/user/upload-avatar';
  static const String preferences = '/user/preferences';
  static const String notifications = '/user/notifications';
  static const String notificationSettings = '/user/notification-settings';

  // Load Endpoints
  static const String loads = '/loads';
  static const String myLoads = '/loads/my-loads';
  static const String createLoad = '/loads/create';
  static const String updateLoad = '/loads/update';
  static const String deleteLoad = '/loads/delete';
  static const String loadDetails = '/loads'; // + /{id}
  static const String loadTracking = '/loads'; // + /{id}/tracking
  static const String loadCategories = '/loads/categories';
  static const String searchLoads = '/loads/search';

  // Ride Endpoints
  static const String rides = '/rides';
  static const String myRides = '/rides/my-rides';
  static const String availableRides = '/rides/available';
  static const String bookRide = '/rides/book';
  static const String cancelRide = '/rides/cancel';
  static const String rideDetails = '/rides'; // + /{id}
  static const String rideTracking = '/rides'; // + /{id}/tracking
  static const String rideHistory = '/rides/history';
  static const String searchRides = '/rides/search';

  // Parcel Endpoints
  static const String parcels = '/parcels';
  static const String myParcels = '/parcels/my-parcels';
  static const String sendParcel = '/parcels/send';
  static const String cancelParcel = '/parcels/cancel';
  static const String parcelDetails = '/parcels'; // + /{id}
  static const String parcelTracking = '/parcels'; // + /{id}/tracking
  static const String parcelHistory = '/parcels/history';
  static const String parcelSizes = '/parcels/sizes';
  static const String calculateParcelCost = '/parcels/calculate-cost';

  // Bid Endpoints
  static const String bids = '/bids';
  static const String myBids = '/bids/my-bids';
  static const String placeBid = '/bids/place';
  static const String acceptBid = '/bids/accept';
  static const String rejectBid = '/bids/reject';
  static const String bidDetails = '/bids'; // + /{id}
  static const String bidHistory = '/bids/history';
  static const String activeBids = '/bids/active';

  // Payment Endpoints
  static const String payments = '/payments';
  static const String paymentMethods = '/payments/methods';
  static const String addPaymentMethod = '/payments/methods/add';
  static const String removePaymentMethod = '/payments/methods/remove';
  static const String processPayment = '/payments/process';
  static const String paymentHistory = '/payments/history';
  static const String paymentStatus = '/payments/status'; // + /{id}
  static const String refundPayment = '/payments/refund';
  static const String invoices = '/payments/invoices';

  // Notification Endpoints
  static const String getNotifications = '/notifications';
  static const String markNotificationRead = '/notifications/mark-read';
  static const String markAllNotificationsRead = '/notifications/mark-all-read';
  static const String deleteNotification = '/notifications/delete';
  static const String updateNotificationSettings = '/notifications/settings';

  // Location Endpoints
  static const String geocode = '/location/geocode';
  static const String reverseGeocode = '/location/reverse-geocode';
  static const String searchPlaces = '/location/search-places';
  static const String calculateRoute = '/location/calculate-route';
  static const String updateLocation = '/location/update';

  // File Upload Endpoints
  static const String uploadFile = '/files/upload';
  static const String uploadImage = '/files/upload-image';
  static const String deleteFile = '/files/delete';

  // Dashboard Endpoints
  static const String dashboardStats = '/dashboard/stats';
  static const String recentActivity = '/dashboard/recent-activity';
  static const String quickActions = '/dashboard/quick-actions';

  // System Endpoints
  static const String appVersion = '/system/app-version';
  static const String systemStatus = '/system/status';
  static const String supportTickets = '/support/tickets';
  static const String createSupportTicket = '/support/tickets/create';

  // Rating Endpoints
  static const String submitRating = '/ratings/submit';
  static const String getRatings = '/ratings'; // + /{entityType}/{entityId}
  static const String myRatings = '/ratings/my-ratings';

  // Search and Filter
  static const String search = '/search';
  static const String filters = '/filters';
  static const String suggestions = '/suggestions';

  // Chat/Messaging Endpoints
  static const String conversations = '/chat/conversations';
  static const String messages = '/chat/messages';
  static const String sendMessage = '/chat/send-message';
  static const String markMessageRead = '/chat/mark-read';

  // Analytics Endpoints
  static const String trackEvent = '/analytics/track';
  static const String userEvents = '/analytics/user-events';

  // Vehicle Endpoints
  static const String vehicles = '/vehicles';
  static const String myVehicles = '/vehicles/my-vehicles';
  static const String addVehicle = '/vehicles/add';
  static const String updateVehicle = '/vehicles/update';
  static const String deleteVehicle = '/vehicles/delete';
  static const String vehicleTypes = '/vehicles/types';

  // Feedback Endpoints
  static const String submitFeedback = '/feedback/submit';
  static const String getFeedback = '/feedback';

  // HTTP Methods
  static const String get = 'GET';
  static const String post = 'POST';
  static const String put = 'PUT';
  static const String delete = 'DELETE';
  static const String patch = 'PATCH';

  // HTTP Status Codes
  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusNoContent = 204;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusMethodNotAllowed = 405;
  static const int statusConflict = 409;
  static const int statusUnprocessableEntity = 422;
  static const int statusInternalServerError = 500;
  static const int statusBadGateway = 502;
  static const int statusServiceUnavailable = 503;
  static const int statusGatewayTimeout = 504;

  // Query Parameters
  static const String page = 'page';
  static const String limit = 'limit';
  static const String search_param = 'search';
  static const String sort = 'sort';
  static const String order = 'order';
  static const String filter = 'filter';
  static const String include = 'include';
  static const String fields = 'fields';

  // Sort Orders
  static const String ascending = 'asc';
  static const String descending = 'desc';

  // Common Sort Fields
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
  static const String name = 'name';
  static const String price = 'price';
  static const String rating = 'rating';
  static const String distance = 'distance';
}