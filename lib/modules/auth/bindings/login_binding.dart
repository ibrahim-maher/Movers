// login_binding.dart
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../controllers/auth_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Auth Controller (shared across all auth pages)
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);

    // Login Controller
    Get.lazyPut<LoginController>(() => LoginController());
  }
}