import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../controllers/auth_controller.dart';
import '../services/auth_service.dart';
import '../repositories/auth_repository.dart';
import '../../../shared/services/storage/local_storage_service.dart';
import '../../../shared/services/firebase/firebase_service.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Register dependencies required by AuthController
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<AuthRepository>(() => AuthRepository(
      authService: Get.find<AuthService>(),
      storageService: Get.find<LocalStorageService>(),
      firebaseService: Get.find<FirebaseService>(),
    ));

    // Auth Controller (shared across auth pages)
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);

    // Login Controller
    Get.lazyPut<LoginController>(() => LoginController());
  }
}