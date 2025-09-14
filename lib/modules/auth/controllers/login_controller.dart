// login_controller.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../shared/services/firebase/firebase_service.dart';
import '../../../routes/app_routes.dart';
import '../services/auth_service.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final AuthService _authService = AuthService();
  final AuthController _authController = Get.find<AuthController>();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;
  final RxBool rememberMe = false.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Load saved credentials if remember me was checked
  void _loadSavedCredentials() {
    // This could be implemented with secure storage
    // For now, we'll skip this for security reasons
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Toggle remember me
  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  // Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      emailError.value = 'Email is required';
      return emailError.value;
    }

    if (!GetUtils.isEmail(value)) {
      emailError.value = 'Please enter a valid email';
      return emailError.value;
    }

    emailError.value = '';
    return null;
  }

  // Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      passwordError.value = 'Password is required';
      return passwordError.value;
    }

    if (value.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      return passwordError.value;
    }

    passwordError.value = '';
    return null;
  }

  // Clear errors
  void clearErrors() {
    emailError.value = '';
    passwordError.value = '';
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      clearErrors();

      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      // Sign in with Firebase Auth
      final credential = await _firebaseService.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Log analytics event
        await _firebaseService.logEvent(
          name: 'login_success',
          parameters: {
            'method': 'email_password',
          },
        );

        // Show success message
        Get.snackbar(
          'Success'.tr,
          'Welcome back!'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigation will be handled by AuthController's auth state listener
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email address';
          emailError.value = errorMessage;
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password';
          passwordError.value = errorMessage;
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          emailError.value = errorMessage;
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many failed attempts. Please try again later';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection';
          break;
        default:
          errorMessage = e.message ?? 'An error occurred during sign in';
      }

      Get.snackbar(
        'Sign In Failed'.tr,
        errorMessage.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // Log error
      await _firebaseService.logError(
        exception: e,
        reason: 'Login failed',
      );

      // Log analytics event
      await _firebaseService.logEvent(
        name: 'login_failed',
        parameters: {
          'error_code': e.code,
          'method': 'email_password',
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'An unexpected error occurred: ${e.toString()}'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // Log error
      await _firebaseService.logError(
        exception: e,
        reason: 'Unexpected login error',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final result = await _authService.signInWithGoogle();

      if (result != null) {
        // Log analytics event
        await _firebaseService.logEvent(
          name: 'login_success',
          parameters: {
            'method': 'google',
          },
        );

        Get.snackbar(
          'Success'.tr,
          'Welcome!'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage = 'An account already exists with a different sign-in method';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid credential. Please try again';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Google sign-in is not enabled';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled';
          break;
        case 'user-not-found':
          errorMessage = 'No account found. Please create an account first';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided';
          break;
        default:
          errorMessage = e.message ?? 'Google sign-in failed';
      }

      Get.snackbar(
        'Google Sign In Failed'.tr,
        errorMessage.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // Log error
      await _firebaseService.logError(
        exception: e,
        reason: 'Google sign-in failed',
      );
    } catch (e) {
      if (e.toString().contains('sign_in_canceled')) {
        // User canceled the sign-in
        return;
      }

      Get.snackbar(
        'Error'.tr,
        'Google sign-in failed: ${e.toString()}'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // Log error
      await _firebaseService.logError(
        exception: e,
        reason: 'Google sign-in unexpected error',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Navigate to register page
  void goToRegister() {
    Get.toNamed(AppRoutes.REGISTER);
  }

  // Navigate to forgot password page
  void goToForgotPassword() {
    Get.toNamed(AppRoutes.FORGOT_PASSWORD);
  }

  // Quick demo login (for testing purposes)
  void quickDemoLogin() async {
    emailController.text = 'demo@example.com';
    passwordController.text = 'demo123';
    await signInWithEmailAndPassword();
  }
}