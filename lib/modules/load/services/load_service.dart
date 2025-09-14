import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../auth/services/token_service.dart';
import '../models/create_load_request_model.dart';
import '../models/load_category_model.dart';
import '../models/load_model.dart';
import '../models/load_status_model.dart';

class LoadService extends GetxService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.moversapp.com/api';
  final TokenService _tokenService = Get.find<TokenService>();

  LoadService() {
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

  Future<List<LoadModel>> getLoads() async {
    try {
      final response = await _dio.get('$_baseUrl/loads');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => LoadModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<LoadModel> getLoadById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/loads/$id');
      return LoadModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<LoadModel> createLoad(CreateLoadRequestModel request) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/loads',
        data: request.toJson(),
      );
      return LoadModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<LoadModel> updateLoad(String id, CreateLoadRequestModel request) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/loads/$id',
        data: request.toJson(),
      );
      return LoadModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteLoad(String id) async {
    try {
      await _dio.delete('$_baseUrl/loads/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<LoadCategoryModel>> getCategories() async {
    try {
      final response = await _dio.get('$_baseUrl/load-categories');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => LoadCategoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<LoadStatusModel>> getStatuses() async {
    try {
      final response = await _dio.get('$_baseUrl/load-statuses');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => LoadStatusModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updateLoadStatus(String id, String statusId) async {
    try {
      await _dio.put(
        '$_baseUrl/loads/$id/status',
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