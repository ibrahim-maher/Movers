// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../controllers/forgot_password_controller.dart';
// import '../widgets/auth_button.dart';
// import '../widgets/auth_form_field.dart';
//
// class ForgotPasswordPage extends GetView<ForgotPasswordController> {
//   const ForgotPasswordPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Forgot Password'),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24.0),
//             child: Obx(() {
//               // Show different UI based on the current step
//               switch (controller.currentStep.value) {
//                 case 0:
//                   return _buildEmailStep(context);
//                 case 1:
//                   return _buildOtpStep(context);
//                 case 2:
//                   return _buildResetPasswordStep(context);
//                 default:
//                   return _buildEmailStep(context);
//               }
//             }),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmailStep(BuildContext context) {
//     return Form(
//       key: controller.emailFormKey,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Icon
//           Icon(
//             Icons.lock_reset_outlined,
//             size: 80,
//             color: Theme.of(context).colorScheme.primary,
//           ),
//           const SizedBox(height: 24),
//
//           // Title
//           Text(
//             'Forgot Password',
//             textAlign: TextAlign.center,
//             style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//           const SizedBox(height: 8),
//
//           // Description
//           Text(
//             'Enter your email address and we will send you a verification code to reset your password.',
//             textAlign: TextAlign.center,
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//           const SizedBox(height: 32),
//
//           // Error Message
//           Obx(() {
//             if (controller.errorMessage.isNotEmpty) {
//               return Container(
//                 padding: const EdgeInsets.all(12),
//                 margin: const EdgeInsets.only(bottom: 16),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.errorContainer,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   controller.errorMessage.value,
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.onErrorContainer,
//                   ),
//                 ),
//               );
//             }
//             return const SizedBox.shrink();
//           }),
//
//           // Success Message
//           Obx(() {
//             if (controller.successMessage.isNotEmpty) {
//               return Container(
//                 padding: const EdgeInsets.all(12),
//                 margin: const EdgeInsets.only(bottom: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.green.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   controller.successMessage.value,
//                   style: const TextStyle(color: Colors.green),
//                 ),
//               );
//             }
//             return const SizedBox.shrink();
//           }),
//
//           // Email Field
//           AuthFormField(
//             controller: controller.emailController,
//             labelText: 'Email',
//             hintText: 'Enter your email',
//             keyboardType: TextInputType.emailAddress,
//             validator: controller.validateEmail,
//             prefixIcon: const Icon(Icons.email_outlined),
//             textInputAction: TextInputAction.done,
//             onFieldSubmitted: (_) => controller.sendResetEmail(),
//           ),
//           const SizedBox(height: 24),
//
//           // Send Reset Email Button
//           Obx(() => AuthButton(
//                 text: 'Send Reset Instructions',
//                 onPressed: controller.sendResetEmail,
//                 isLoading: controller.isLoading.value,
//               )),
//           const SizedBox(height: 16),
//
//           // Back to Login
//           TextButton(
//             onPressed: controller.navigateToLogin,
//             child: const Text('Back to Login'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOtpStep(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         // Icon
//         Icon(
//           Icons.sms_outlined,
//           size: 80,
//           color: Theme.of(context).colorScheme.primary,
//         ),
//         const SizedBox(height: 24),
//
//         // Title
//         Text(
//           'Enter Verification Code',
//           textAlign: TextAlign.center,
//           style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//         ),
//         const SizedBox(height: 8),
//
//         // Description
//         Text(
//           'We have sent a verification code to ${controller.emailController.text}',
//           textAlign: TextAlign.center,
//           style: Theme.of(context).textTheme.bodyMedium,
//         ),
//         const SizedBox(height: 32),
//
//         // Error Message
//         Obx(() {
//           if (controller.errorMessage.isNotEmpty) {
//             return Container(
//               padding: const EdgeInsets.all(12),
//               margin: const EdgeInsets.only(bottom: 16),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.errorContainer,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 controller.errorMessage.value,
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.onErrorContainer,
//                 ),
//               ),
//             );
//           }
//           return const SizedBox.shrink();
//         }),
//
//         // Success Message
//         Obx(() {
//           if (controller.successMessage.isNotEmpty) {
//             return Container(
//               padding: const EdgeInsets.all(12),
//               margin: const EdgeInsets.only(bottom: 16),
//               decoration: BoxDecoration(
//                 color: Colors.green.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 controller.successMessage.value,
//                 style: const TextStyle(color: Colors.green),
//               ),
//             );
//           }
//           return const SizedBox.shrink();
//         }),
//
//         // OTP Field
//         AuthFormField(
//           controller: controller.otpController,
//           labelText: 'Verification Code',
//           hintText: 'Enter 6-digit code',
//           keyboardType: TextInputType.number,
//           maxLength: 6,
//           prefixIcon: const Icon(Icons.pin_outlined),
//           textInputAction: TextInputAction.done,
//           onFieldSubmitted: (_) => controller.verifyOtp(),
//         ),
//         const SizedBox(height: 24),
//
//         // Verify OTP Button
//         Obx(() => AuthButton(
//               text: 'Verify Code',
//               onPressed: controller.verifyOtp,
//               isLoading: controller.isLoading.value,
//             )),
//         const SizedBox(height: 16),
//
//         // Resend Code
//         TextButton(
//           onPressed: () => controller.sendResetEmail(),
//           child: const Text('Resend Code'),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildResetPasswordStep(BuildContext context) {
//     return Form(
//       key: controller.resetPasswordFormKey,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Icon
//           Icon(
//             Icons.lock_open_outlined,
//             size: 80,
//             color: Theme.of(context).colorScheme.primary,
//           ),
//           const SizedBox(height: 24),
//
//           // Title
//           Text(
//             'Reset Password',
//             textAlign: TextAlign.center,
//             style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//           const SizedBox(height: 8),
//
//           // Description
//           Text(
//             'Create a new password for your account',
//             textAlign: TextAlign.center,
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//           const SizedBox(height: 32),
//
//           // Error Message
//           Obx(() {
//             if (controller.errorMessage.isNotEmpty) {
//               return Container(
//                 padding: const EdgeInsets.all(12),
//                 margin: const EdgeInsets.only(bottom: 16),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.errorContainer,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   controller.errorMessage.value,
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.onErrorContainer,
//                   ),
//                 ),
//               );
//             }
//             return const SizedBox.shrink();
//           }),
//
//           // Success Message
//           Obx(() {
//             if (controller.successMessage.isNotEmpty) {
//               return Container(
//                 padding: const EdgeInsets.all(12),
//                 margin: const EdgeInsets.only(bottom: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.green.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   controller.successMessage.value,
//                   style: const TextStyle(color: Colors.green),
//                 ),
//               );
//             }
//             return const SizedBox.shrink();
//           }),
//
//           // Password Field
//           AuthFormField(
//             controller: controller.passwordController,
//             labelText: 'New Password',
//             hintText: 'Enter new password',
//             obscureText: true,
//             validator: controller.validatePassword,
//             prefixIcon: const Icon(Icons.lock_outline),
//             textInputAction: TextInputAction.next,
//           ),
//           const SizedBox(height: 16),
//
//           // Confirm Password Field
//           AuthFormField(
//             controller: controller.confirmPasswordController,
//             labelText: 'Confirm Password',
//             hintText: 'Confirm new password',
//             obscureText: true,
//             validator: controller.validateConfirmPassword,
//             prefixIcon: const Icon(Icons.lock_outline),
//             textInputAction: TextInputAction.done,
//             onFieldSubmitted: (_) => controller.resetPassword(),
//           ),
//           const SizedBox(height: 24),
//
//           // Reset Password Button
//           Obx(() => AuthButton(
//                 text: 'Reset Password',
//                 onPressed: controller.resetPassword,
//                 isLoading: controller.isLoading.value,
//               )),
//         ],
//       ),
//     );
//   }
// }