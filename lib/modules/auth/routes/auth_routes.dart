// import 'package:get/get.dart';
//
// import '../bindings/auth_binding.dart';
// import '../bindings/forgot_password_binding.dart';
// import '../bindings/login_binding.dart';
// import '../bindings/register_binding.dart' hide LoginBinding;
// import '../middleware/auth_middleware.dart';
// import '../pages/forgot_password_page.dart';
// import '../pages/login_page.dart';
// import '../pages/otp_verification_page.dart';
// import '../pages/register_page.dart';
//
// class AuthRoutes {
//   static final routes = [
//     GetPage(
//       name: '/auth/login',
//       page: () => const LoginPage(),
//       binding: LoginBinding(),
//       middlewares: [AuthMiddleware()],
//     ),
//     GetPage(
//       name: '/auth/register',
//       page: () => const RegisterPage(),
//       binding: RegisterBinding(),
//     ),
//     // GetPage(
//     //   name: '/auth/forgot-password',
//     //   page: () => const ForgotPasswordPage(),
//     //   binding: ForgotPasswordBinding(),
//     // ),
//     // GetPage(
//     //   name: '/auth/otp-verification',
//     //   page: () => const OtpVerificationPage(),
//     //   binding: ForgotPasswordBinding(),
//     // ),
//   ];
// }