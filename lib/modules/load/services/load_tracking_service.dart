import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../auth/services/token_service.dart';
import '../models/load_tracking_model.dart';

class LoadTrackingService extends GetxService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.moversapp.com/api';
  final TokenService _tokenService = Get.find<TokenService>();

  LoadTrackingService() {
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

  Future<List<LoadTrackingModel>> getTrackingHistory(String loadId) async {
    try {
      final response = await _dio.get('$_baseUrl/loads/$loadId/tracking');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => LoadTrackingModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<LoadTrackingModel> addTrackingUpdate(
    String loadId,
    String statusId,
    String location,
    double latitude,
    double longitude,
    String? notes,
  ) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/loads/$loadId/tracking',
        data: {
          'status_id': statusId,
          'location': location,
          'latitude': latitude,
          'longitude': longitude,
          'notes': notes,
        },
      );
      return LoadTrackingModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<LoadTrackingModel> getLatestTracking(String loadId) async {
    try {
      final response = await _dio.get('$_baseUrl/loads/$loadId/tracking/latest');
      return LoadTrackingModel.fromJson(response.data['data']);
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