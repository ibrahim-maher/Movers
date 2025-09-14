// import 'package:flutter/material.dart';
// import 'package:local_auth/local_auth.dart';
//
// class BiometricLoginWidget extends StatelessWidget {
//   final VoidCallback onPressed;
//   final bool isAvailable;
//   final bool isLoading;
//   final List<BiometricType>? availableBiometrics;
//
//   const BiometricLoginWidget({
//     super.key,
//     required this.onPressed,
//     required this.isAvailable,
//     this.isLoading = false,
//     this.availableBiometrics,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (!isAvailable) {
//       return const SizedBox.shrink(); // Don't show if biometrics not available
//     }
//
//     return Column(
//       children: [
//         const SizedBox(height: 16),
//         const Row(
//           children: [
//             Expanded(child: Divider()),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text('Or'),
//             ),
//             Expanded(child: Divider()),
//           ],
//         ),
//         const SizedBox(height: 16),
//         InkWell(
//           onTap: isLoading ? null : onPressed,
//           borderRadius: BorderRadius.circular(50),
//           child: Container(
//             width: 64,
//             height: 64,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: Theme.of(context).colorScheme.primary,
//                 width: 2,
//               ),
//             ),
//             child: isLoading
//                 ? CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       Theme.of(context).colorScheme.primary,
//                     ),
//                   )
//                 : Icon(
//                     _getBiometricIcon(),
//                     size: 32,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'Login with Biometrics',
//           style: TextStyle(
//             color: Theme.of(context).colorScheme.primary,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
//
//   IconData _getBiometricIcon() {
//     if (availableBiometrics != null) {
//       if (availableBiometrics!.contains(BiometricType.face)) {
//         return Icons.face;
//       } else if (availableBiometrics!.contains(BiometricType.fingerprint)) {
//         return Icons.fingerprint;
//       }
//     }
//     // Default icon if we can't determine the specific biometric type
//     return Icons.fingerprint;
//   }
// }