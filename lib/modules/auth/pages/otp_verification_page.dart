// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../controllers/otp_verification_controller.dart';
// import '../widgets/auth_button.dart';
// import '../widgets/auth_form_field.dart';
//
// class OtpVerificationPage extends GetView<OtpVerificationController> {
//   const OtpVerificationPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Verification'),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24.0),
//             child: Form(
//               key: controller.otpFormKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Icon
//                   Icon(
//                     Icons.sms_outlined,
//                     size: 80,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                   const SizedBox(height: 24),
//
//                   // Title
//                   Text(
//                     'Enter Verification Code',
//                     textAlign: TextAlign.center,
//                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                   const SizedBox(height: 8),
//
//                   // Description
//                   Text(
//                     'We have sent a verification code to ${controller.email}',
//                     textAlign: TextAlign.center,
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   const SizedBox(height: 32),
//
//                   // Error Message
//                   Obx(() {
//                     if (controller.errorMessage.isNotEmpty) {
//                       return Container(
//                         padding: const EdgeInsets.all(12),
//                         margin: const EdgeInsets.only(bottom: 16),
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).colorScheme.errorContainer,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           controller.errorMessage.value,
//                           style: TextStyle(
//                             color: Theme.of(context).colorScheme.onErrorContainer,
//                           ),
//                         ),
//                       );
//                     }
//                     return const SizedBox.shrink();
//                   }),
//
//                   // Success Message
//                   Obx(() {
//                     if (controller.successMessage.isNotEmpty) {
//                       return Container(
//                         padding: const EdgeInsets.all(12),
//                         margin: const EdgeInsets.only(bottom: 16),
//                         decoration: BoxDecoration(
//                           color: Colors.green.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           controller.successMessage.value,
//                           style: const TextStyle(color: Colors.green),
//                         ),
//                       );
//                     }
//                     return const SizedBox.shrink();
//                   }),
//
//                   // OTP Field
//                   AuthFormField(
//                     controller: controller.otpController,
//                     labelText: 'Verification Code',
//                     hintText: 'Enter 6-digit code',
//                     keyboardType: TextInputType.number,
//                     validator: controller.validateOtp,
//                     maxLength: 6,
//                     prefixIcon: const Icon(Icons.pin_outlined),
//                     textInputAction: TextInputAction.done,
//                     onFieldSubmitted: (_) => controller.verifyOtp(),
//                   ),
//                   const SizedBox(height: 24),
//
//                   // Verify OTP Button
//                   Obx(() => AuthButton(
//                         text: 'Verify Code',
//                         onPressed: controller.verifyOtp,
//                         isLoading: controller.isLoading.value,
//                       )),
//                   const SizedBox(height: 16),
//
//                   // Resend Code
//                   Obx(() => Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text("Didn't receive the code?"),
//                           TextButton(
//                             onPressed: controller.resendCountdown.value > 0
//                                 ? null
//                                 : controller.resendOtp,
//                             child: controller.resendCountdown.value > 0
//                                 ? Text('Resend in ${controller.resendCountdown.value}s')
//                                 : const Text('Resend'),
//                           ),
//                         ],
//                       )),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }