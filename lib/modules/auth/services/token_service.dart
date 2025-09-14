import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TokenService extends GetxService {
  final GetStorage _storage = GetStorage();
  
  // Storage keys
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';
  static const String _biometricEnabledKey = 'biometric_enabled';

  // Save auth tokens and user data
  Future<void> saveAuthData(String token, String refreshToken, Map<String, dynamic> userData) async {
    await _storage.write(_tokenKey, token);
    await _storage.write(_refreshTokenKey, refreshToken);
    await _storage.write(_userKey, userData);
  }

  Future<void> saveToken(String token) async {
    await _storage.write(_tokenKey, token);
    print('✅ Token saved: $token');
  }
  // Get auth token
  String? getToken() {
    return _storage.read<String>(_tokenKey);
  }

  // Get refresh token
  String? getRefreshToken() {
    return _storage.read<String>(_refreshTokenKey);
  }

  // Get user data
  Map<String, dynamic>? getUserData() {
    return _storage.read<Map<String, dynamic>>(_userKey);
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return getToken() != null;
  }

  // Clear all auth data (logout)
  Future<void> clearAuthData() async {
    await _storage.remove(_tokenKey);
    await _storage.remove(_refreshTokenKey);
    await _storage.remove(_userKey);
  }

  // Biometric authentication settings
  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(_biometricEnabledKey, enabled);
  }

  bool isBiometricEnabled() {
    return _storage.read<bool>(_biometricEnabledKey) ?? false;
  }
}