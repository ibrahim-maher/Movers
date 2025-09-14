// register_controller.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../shared/services/firebase/firebase_service.dart';
import '../../../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class RegisterController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final AuthService _authService = AuthService();

  // Form controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;
  final RxBool acceptTerms = false.obs;
  final RxString fullNameError = ''.obs;
  final RxString emailError = ''.obs;
  final RxString phoneError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString confirmPasswordError = ''.obs;

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  // Toggle accept terms
  void toggleAcceptTerms(bool? value) {
    acceptTerms.value = value ?? false;
  }

  // Validate full name
  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      fullNameError.value = 'Full name is required';
      return fullNameError.value;
    }

    if (value.trim().length < 2) {
      fullNameError.value = 'Full name must be at least 2 characters';
      return fullNameError.value;
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      fullNameError.value = 'Full name can only contain letters and spaces';
      return fullNameError.value;
    }

    fullNameError.value = '';
    return null;
  }

  // Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      emailError.value = 'Email is required';
      return emailError.value;
    }

    if (!GetUtils.isEmail(value)) {
      emailError.value = 'Please enter a valid email address';
      return emailError.value;
    }

    emailError.value = '';
    return null;
  }

  // Validate phone (optional)
  String? validatePhone(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!GetUtils.isPhoneNumber(value)) {
        phoneError.value = 'Please enter a valid phone number';
        return phoneError.value;
      }
    }

    phoneError.value = '';
    return null;
  }

  // Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      passwordError.value = 'Password is required';
      return passwordError.value;
    }

    if (value.length < 8) {
      passwordError.value = 'Password must be at least 8 characters';
      return passwordError.value;
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      passwordError.value = 'Password must contain at least one uppercase letter';
      return passwordError.value;
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      passwordError.value = 'Password must contain at least one lowercase letter';
      return passwordError.value;
    }

    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      passwordError.value = 'Password must contain at least one number';
      return passwordError.value;
    }

    passwordError.value = '';
    return null;
  }

  // Validate confirm password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      return confirmPasswordError.value;
    }

    if (value != passwordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
      return confirmPasswordError.value;
    }

    confirmPasswordError.value = '';
    return null;
  }

  // Clear all errors
  void clearErrors() {
    fullNameError.value = '';
    emailError.value = '';
    phoneError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
  }

  // Check password strength
  double getPasswordStrength() {
    final password = passwordController.text;
    if (password.isEmpty) return 0.0;

    double strength = 0.0;

    // Length check
    if (password.length >= 8) strength += 0.2;
    if (password.length >= 12) strength += 0.1;

    // Character variety checks
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.1;

    return strength.clamp(0.0, 1.0);
  }

  // Get password strength text
  String getPasswordStrengthText() {
    final strength = getPasswordStrength();
    if (strength < 0.3) return 'Weak';
    if (strength < 0.7) return 'Medium';
    return 'Strong';
  }

  // Get password strength color
  Color getPasswordStrengthColor() {
    final strength = getPasswordStrength();
    if (strength < 0.3) return Colors.red;
    if (strength < 0.7) return Colors.orange;
    return Colors.green;
  }

  // Register with email and password
  Future<void> registerWithEmailAndPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (!acceptTerms.value) {
      Get.snackbar(
        'Terms Required'.tr,
        'Please accept the terms and conditions to continue'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      clearErrors();

      final fullName = fullNameController.text.trim();
      final email = emailController.text.trim();
      final phone = phoneController.text.trim();
      final password = passwordController.text.trim();

      // Create user with Firebase Auth
      final credential = await _firebaseService.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Update Firebase Auth profile
        await credential.user!.updateDisplayName(fullName);

        // Create user document in Firestore
        final userModel = UserModel(
          id: credential.user!.uid,
          email: email,
          displayName: fullName,
          phoneNumber: phone,
          photoURL: '',
          emailVerified: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _authService.createUserDocument(userModel);

        // Send email verification
        await credential.user!.sendEmailVerification();

        // Log analytics event
        await _firebaseService.logEvent(
          name: 'sign_up_success',
          parameters: {
            'method': 'email_password',
          },
        );

        // Show success message
        Get.snackbar(
          'Registration Successful'.tr,
          'Welcome! Please check your email to verify your account.'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );

        // Navigation will be handled by AuthController's auth state listener
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak';
          passwordError.value = errorMessage;
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists with this email address';
          emailError.value = errorMessage;
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          emailError.value = errorMessage;
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection';
          break;
        default:
          errorMessage = e.message ?? 'An error occurred during registration';
      }

      Get.snackbar(
        'Registration Failed'.tr,
        errorMessage.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // Log error
      await _firebaseService.logError(
        exception: e,
        reason: 'Registration failed',
      );

      // Log analytics event
      await _firebaseService.logEvent(
        name: 'sign_up_failed',
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
        reason: 'Unexpected registration error',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Register with Google
  Future<void> registerWithGoogle() async {
    try {
      isLoading.value = true;

      final result = await _authService.signInWithGoogle();

      if (result != null) {
        // Log analytics event
        await _firebaseService.logEvent(
          name: 'sign_up_success',
          parameters: {
            'method': 'google',
          },
        );

        Get.snackbar(
          'Registration Successful'.tr,
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
        default:
          errorMessage = e.message ?? 'Google registration failed';
      }

      Get.snackbar(
        'Google Registration Failed'.tr,
        errorMessage.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // Log error
      await _firebaseService.logError(
        exception: e,
        reason: 'Google registration failed',
      );
    } catch (e) {
      if (e.toString().contains('sign_in_canceled')) {
        // User canceled the sign-in
        return;
      }

      Get.snackbar(
        'Error'.tr,
        'Google registration failed: ${e.toString()}'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // Log error
      await _firebaseService.logError(
        exception: e,
        reason: 'Google registration unexpected error',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Navigate to login page
  void goToLogin() {
    Get.offNamed(AppRoutes.LOGIN);
  }

  // Show terms and conditions
  void showTermsAndConditions() {
    Get.defaultDialog(
      title: 'Terms and Conditions'.tr,
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'By creating an account, you agree to our Terms of Service and Privacy Policy.',
                style: Get.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                '1. You must be at least 18 years old to use this service.',
                style: Get.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                '2. You are responsible for maintaining the security of your account.',
                style: Get.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                '3. We collect and process your data as described in our Privacy Policy.',
                style: Get.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                '4. We reserve the right to suspend or terminate accounts that violate our terms.',
                style: Get.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
      textConfirm: 'Accept'.tr,
      textCancel: 'Cancel'.tr,
      onConfirm: () {
        acceptTerms.value = true;
        Get.back();
      },
      onCancel: () {
        acceptTerms.value = false;
        Get.back();
      },
    );
  }

  // Show privacy policy
  void showPrivacyPolicy() {
    Get.defaultDialog(
      title: 'Privacy Policy'.tr,
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'We respect your privacy and are committed to protecting your personal data.',
                style: Get.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Information we collect:',
                style: Get.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Text(
                '• Personal information (name, email, phone)',
                style: Get.textTheme.bodySmall,
              ),
              Text(
                '• Location data for delivery services',
                style: Get.textTheme.bodySmall,
              ),
              Text(
                '• Usage data and analytics',
                style: Get.textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Text(
                'We use this information to provide and improve our services.',
                style: Get.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
      textConfirm: 'OK'.tr,
      onConfirm: () => Get.back(),
    );
  }
}