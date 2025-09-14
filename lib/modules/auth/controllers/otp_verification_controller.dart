// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../repositories/auth_repository.dart';
//
// class OtpVerificationController extends GetxController {
//   final AuthRepository _authRepository = Get.find<AuthRepository>();
//
//   // Form controller
//   final TextEditingController otpController = TextEditingController();
//
//   // Form key
//   final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
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
//   // Email for verification
//   late final String email;
//
//   // Timer for resend countdown
//   final RxInt resendCountdown = 60.obs;
//   Timer? _resendTimer;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Get email from arguments
//     if (Get.arguments != null && Get.arguments['email'] != null) {
//       email = Get.arguments['email'];
//       startResendTimer();
//     } else {
//       // If no email provided, go back to login
//       Get.back();
//     }
//   }
//
//   @override
//   void onClose() {
//     otpController.dispose();
//     _resendTimer?.cancel();
//     super.onClose();
//   }
//
//   void startResendTimer() {
//     resendCountdown.value = 60;
//     _resendTimer?.cancel();
//     _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (resendCountdown.value > 0) {
//         resendCountdown.value--;
//       } else {
//         timer.cancel();
//       }
//     });
//   }
//
//   Future<bool> verifyOtp() async {
//     if (!otpFormKey.currentState!.validate()) {
//       return false;
//     }
//
//     isLoading.value = true;
//     errorMessage.value = '';
//     successMessage.value = '';
//
//     try {
//       final success = await _authRepository.verifyOtp(
//         email,
//         otpController.text.trim(),
//       );
//
//       if (success) {
//         successMessage.value = 'OTP verified successfully';
//         // Navigate based on the verification purpose
//         // This could be different based on the flow (registration, password reset, etc.)
//         if (Get.arguments != null && Get.arguments['purpose'] == 'reset_password') {
//           Get.toNamed('/auth/reset-password', arguments: {
//             'email': email,
//             'otp': otpController.text.trim(),
//           });
//         } else {
//           Get.back(result: true);
//         }
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
//   Future<void> resendOtp() async {
//     if (resendCountdown.value > 0) {
//       return; // Still in countdown, can't resend yet
//     }
//
//     isLoading.value = true;
//     errorMessage.value = '';
//
//     try {
//       final success = await _authRepository.forgotPassword(email);
//
//       if (success) {
//         successMessage.value = 'OTP resent successfully';
//         startResendTimer();
//       } else {
//         errorMessage.value = 'Failed to resend OTP. Please try again.';
//       }
//     } catch (e) {
//       errorMessage.value = 'An error occurred. Please try again.';
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Validation
//   String? validateOtp(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'OTP is required';
//     }
//     if (value.length != 6 || !GetUtils.isNumericOnly(value)) {
//       return 'Please enter a valid 6-digit OTP';
//     }
//     return null;
//   }
// }