import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../shared/services/firebase/firebase_service.dart';
import '../../../shared/services/storage/local_storage_service.dart';
import '../../../modules/auth/services/token_service.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../routes/app_routes.dart';
import '../services/auth_service.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final AuthService _authService = AuthService();
  final LocalStorageService _storageService = Get.find<LocalStorageService>();
  final TokenService _tokenService = Get.find<TokenService>();
  final AuthController _authController = Get.find<AuthController>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;
  final RxBool rememberMe = false.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    print('🚀 LoginController initialized');
    _storageService.debugPrint();
    _loadSavedCredentials();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _loadSavedCredentials() {
    // Implement secure storage for saved credentials if needed
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      emailError.value = 'Email is required'.tr;
      return emailError.value;
    }
    if (!GetUtils.isEmail(value)) {
      emailError.value = 'Please enter a valid email'.tr;
      return emailError.value;
    }
    emailError.value = '';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      passwordError.value = 'Password is required'.tr;
      return passwordError.value;
    }
    if (value.length < 6) {
      passwordError.value = 'Password must be at least 6 characters'.tr;
      return passwordError.value;
    }
    passwordError.value = '';
    return null;
  }

  void clearErrors() {
    emailError.value = '';
    passwordError.value = '';
  }

  Future<void> signInWithEmailAndPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      clearErrors();

      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final credential = await _firebaseService.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Save authentication state
        await _tokenService.saveToken(credential.user!.uid);
        await _storageService.setString(StorageKeys.userId, credential.user!.uid);
        await _storageService.setString(StorageKeys.userEmail, credential.user!.email ?? '');
        await _storageService.setString(StorageKeys.userName, credential.user!.displayName ?? 'User');
        await _storageService.setBool(StorageKeys.isLoggedIn, true);

        print('✅ Login successful: ${credential.user!.email}');
        await _firebaseService.logEvent(
          name: 'login_success',
          parameters: {'method': 'email_password'},
        );

        Get.snackbar(
          'Success'.tr,
          'Welcome back!'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed(AppRoutes.HOME);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email address'.tr;
          emailError.value = errorMessage;
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password'.tr;
          passwordError.value = errorMessage;
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address'.tr;
          emailError.value = errorMessage;
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled'.tr;
          break;
        case 'too-many-requests':
          errorMessage = 'Too many failed attempts. Please try again later'.tr;
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection'.tr;
          break;
        default:
          errorMessage = e.message ?? 'An error occurred during sign in'.tr;
      }

      Get.snackbar(
        'Sign In Failed'.tr,
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      await _firebaseService.logError(
        exception: e,
        reason: 'Login failed: ${e.code}',
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'An unexpected error occurred: $e'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      await _firebaseService.logError(
        exception: e,
        reason: 'Unexpected login error',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      final result = await _authService.signInWithGoogle();
      if (result != null) {
        // Save authentication state
        await _tokenService.saveToken(result.user!.uid);
        await _storageService.setString(StorageKeys.userId, result.user!.uid);
        await _storageService.setString(StorageKeys.userEmail, result.user!.email ?? '');
        await _storageService.setString(StorageKeys.userName, result.user!.displayName ?? 'User');
        await _storageService.setBool(StorageKeys.isLoggedIn, true);

        await _firebaseService.logEvent(
          name: 'login_success',
          parameters: {'method': 'google'},
        );

        Get.snackbar(
          'Success'.tr,
          'Welcome!'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed(AppRoutes.HOME);
      }
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Google sign-in failed: $e'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      await _firebaseService.logError(
        exception: e,
        reason: 'Google sign-in failed',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.toNamed(AppRoutes.REGISTER);
  }

  void goToForgotPassword() {
    Get.toNamed(AppRoutes.FORGOT_PASSWORD);
  }

  void quickDemoLogin() async {
    emailController.text = 'demo@example.com';
    passwordController.text = 'demo123';
    await signInWithEmailAndPassword();
  }
}