import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/token_service.dart';

class AuthMiddleware extends GetMiddleware {
  final TokenService _tokenService = Get.find<TokenService>();

  @override
  RouteSettings? redirect(String? route) {
    // If user is already logged in and trying to access auth pages,
    // redirect to home page
    if (_tokenService.isLoggedIn() && 
        (route == '/auth/login' || 
         route == '/auth/register' || 
         route == '/auth/forgot-password')) {
      return const RouteSettings(name: '/load/list');
    }
    
    // If user is not logged in and trying to access protected pages,
    // redirect to login page
    if (!_tokenService.isLoggedIn() && 
        !(route == '/auth/login' || 
          route == '/auth/register' || 
          route == '/auth/forgot-password' || 
          route == '/auth/otp-verification')) {
      return const RouteSettings(name: '/auth/login');
    }
    
    return null;
  }
}