import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../auth/services/token_service.dart';

class RideTrackingService extends GetxService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.moversapp.com/api';
  final TokenService _tokenService = Get.find<TokenService>();

  RideTrackingService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token to requests
        final token = _tokenService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<Map<String, dynamic>> getRideLocation(String rideId) async {
    try {
      final response = await _dio.get('$_baseUrl/rides/$rideId/location');
      return response.data['data'];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updateRideLocation(String rideId, LatLng location) async {
    try {
      await _dio.post(
        '$_baseUrl/rides/$rideId/location',
        data: {
          'latitude': location.latitude,
          'longitude': location.longitude,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getRideTrackingHistory(String rideId) async {
    try {
      final response = await _dio.get('$_baseUrl/rides/$rideId/tracking');
      return List<Map<String, dynamic>>.from(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updateRideStatus(String rideId, String statusId) async {
    try {
      await _dio.put(
        '$_baseUrl/rides/$rideId/status',
        data: {'status_id': statusId},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      final errorMessage = e.response?.data['message'] ?? 'An error occurred';
      return Exception(errorMessage);
    } else {
      return Exception('Network error occurred');
    }
  }
}