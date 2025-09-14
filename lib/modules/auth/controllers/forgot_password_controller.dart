// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../repositories/auth_repository.dart';
//
// class ForgotPasswordController extends GetxController {
//   final AuthRepository _authRepository = Get.find<AuthRepository>();
//
//   // Form controllers
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//
//   Form keys
//   final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
//   final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();
//
//   // Loading state
//   final RxBool isLoading = false.obs;
//
//   // Error message
//   final RxString errorMessage = ''.obs;
//
//   // Success message
//   final RxString successMessage = ''.obs;
//
//   // Step in the forgot password flow
//   // 0: Enter email, 1: Enter OTP, 2: Reset password
//   final RxInt currentStep = 0.obs;
//
//   @override
//   void onClose() {
//     emailController.dispose();
//     otpController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.onClose();
//   }
//
//   Future<bool> sendResetEmail() async {
//     if (!emailFormKey.currentState!.validate()) {
//       return false;
//     }
//
//     isLoading.value = true;
//     errorMessage.value = '';
//     successMessage.value = '';
//
//     try {
//       final success = await _authRepository.forgotPassword(emailController.text.trim());
//
//       if (success) {
//         successMessage.value = 'Reset instructions sent to your email';
//         currentStep.value = 1; // Move to OTP verification step
//         return true;
//       } else {
//         errorMessage.value = 'Failed to send reset email. Please try again.';
//         return false;
//       }
//     } catch (e) {
//       errorMessage.value = 'An error occurred. Please try again.';
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<bool> verifyOtp() async {
//     if (otpController.text.isEmpty) {
//       errorMessage.value = 'Please enter the OTP';
//       return false;
//     }
//
//     isLoading.value = true;
//     errorMessage.value = '';
//     successMessage.value = '';
//
//     try {
//       final success = await _authRepository.verifyOtp(
//         emailController.text.trim(),
//         otpController.text.trim(),
//       );
//
//       if (success) {
//         successMessage.value = 'OTP verified successfully';
//         currentStep.value = 2; // Move to reset password step
//         return true;
//       } else {
//         errorMessage.value = 'Invalid OTP. Please try again.';
//         return false;
//       }
//     } catch (e) {
//       errorMessage.value = 'An error occurred. Please try again.';
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<bool> resetPassword() async {
//     if (!resetPasswordFormKey.currentState!.validate()) {
//       return false;
//     }
//
//     isLoading.value = true;
//     errorMessage.value = '';
//     successMessage.value = '';
//
//     try {
//       final success = await _authRepository.resetPassword(
//         emailController.text.trim(),
//         otpController.text.trim(),
//         passwordController.text,
//         confirmPasswordController.text,
//       );
//
//       if (success) {
//         successMessage.value = 'Password reset successfully';
//         Get.offAllNamed('/auth/login'); // Navigate back to login
//         return true;
//       } else {
//         errorMessage.value = 'Failed to reset password. Please try again.';
//         return false;
//       }
//     } catch (e) {
//       errorMessage.value = 'An error occurred. Please try again.';
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void navigateToLogin() {
//     Get.back(); // Go back to login page
//   }
//
//   // Validation
//   String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Email is required';
//     }
//     if (!GetUtils.isEmail(value)) {
//       return 'Please enter a valid email';
//     }
//     return null;
//   }
//
//   String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Password is required';
//     }
//     if (value.length < 6) {
//       return 'Password must be at least 6 characters';
//     }
//     return null;
//   }
//
//   String? validateConfirmPassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Confirm password is required';
//     }
//     if (value != passwordController.text) {
//       return 'Passwords do not match';
//     }
//     return null;
//   }
// }