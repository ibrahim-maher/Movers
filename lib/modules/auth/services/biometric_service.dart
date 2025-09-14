// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:local_auth/error_codes.dart' as auth_error;
//
// class BiometricService extends GetxService {
//   final LocalAuthentication _localAuth = LocalAuthentication();
//
//   Future<bool> isBiometricAvailable() async {
//     try {
//       // Check if biometric authentication is available
//       final bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
//       final bool canAuthenticate = canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();
//       return canAuthenticate;
//     } on PlatformException catch (_) {
//       return false;
//     }
//   }
//
//   Future<List<BiometricType>> getAvailableBiometrics() async {
//     try {
//       return await _localAuth.getAvailableBiometrics();
//     } on PlatformException catch (_) {
//       return [];
//     }
//   }
//
//   Future<bool> authenticate() async {
//     try {
//       return await _localAuth.authenticate(
//         localizedReason: 'Authenticate to access your account',
//         options: const AuthenticationOptions(
//           stickyAuth: true,
//           biometricOnly: true,
//         ),
//       );
//     } on PlatformException catch (e) {
//       if (e.code == auth_error.notAvailable) {
//         // Biometric authentication is not available
//         return false;
//       } else if (e.code == auth_error.notEnrolled) {
//         // No biometrics enrolled on this device
//         return false;
//       } else {
//         // Other errors
//         return false;
//       }
//     }
//   }
// }