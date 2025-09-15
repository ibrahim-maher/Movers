// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
//
// import '../../auth/services/token_service.dart';
// import '../models/booking_request_model.dart';
// import '../models/ride_booking_model.dart';
// import '../models/ride_model.dart';
// import '../models/route_model.dart';
// import '../models/vehicle_model.dart';
//
// class RideService extends GetxService {
//   final Dio _dio = Dio();
//   final String _baseUrl = 'https://api.moversapp.com/api';
//   final TokenService _tokenService = Get.find<TokenService>();
//
//   RideService() {
//     _dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) {
//         // Add auth token to requests
//         final token = _tokenService.getToken();
//         if (token != null) {
//           options.headers['Authorization'] = 'Bearer $token';
//         }
//         return handler.next(options);
//       },
//     ));
//   }
//
//   Future<List<RideModel>> getRides() async {
//     try {
//       final response = await _dio.get('$_baseUrl/rides');
//       final List<dynamic> data = response.data['data'];
//       return data.map((json) => RideModel.fromJson(json)).toList();
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   Future<RideModel> getRideById(String id) async {
//     try {
//       final response = await _dio.get('$_baseUrl/rides/$id');
//       return RideModel.fromJson(response.data['data']);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   Future<List<RideBookingModel>> getUserBookings() async {
//     try {
//       final response = await _dio.get('$_baseUrl/bookings');
//       final List<dynamic> data = response.data['data'];
//       return data.map((json) => RideBookingModel.fromJson(json)).toList();
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   Future<RideBookingModel> bookRide(BookingRequestModel request) async {
//     try {
//       final response = await _dio.post(
//         '$_baseUrl/bookings',
//         data: request.toJson(),
//       );
//       return RideBookingModel.fromJson(response.data['data']);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   Future<void> cancelBooking(String bookingId) async {
//     try {
//       await _dio.delete('$_baseUrl/bookings/$bookingId');
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   Future<List<VehicleModel>> getUserVehicles() async {
//     try {
//       final response = await _dio.get('$_baseUrl/vehicles');
//       final List<dynamic> data = response.data['data'];
//       return data.map((json) => VehicleModel.fromJson(json)).toList();
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   Future<RouteModel> getRouteForRide(String rideId) async {
//     try {
//       final response = await _dio.get('$_baseUrl/rides/$rideId/route');
//       return RouteModel.fromJson(response.data['data']);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   Exception _handleError(DioException e) {
//     if (e.response != null) {
//       final errorMessage = e.response?.data['message'] ?? 'An error occurred';
//       return Exception(errorMessage);
//     } else {
//       return Exception('Network error occurred');
//     }
//   }
// }