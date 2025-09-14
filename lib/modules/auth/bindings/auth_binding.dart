import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../controllers/auth_controller.dart';
import '../repositories/auth_repository.dart';
import '../services/auth_service.dart';
import '../../../shared/services/storage/local_storage_service.dart';
import '../../../shared/services/firebase/firebase_service.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    // Auth Service
    Get.lazyPut<AuthService>(() => AuthService());

    // Auth Repository
    Get.lazyPut<AuthRepository>(() => AuthRepository(
      authService: Get.find<AuthService>(),
      storageService: Get.find<LocalStorageService>(),
      firebaseService: Get.find<FirebaseService>(),
    ));

    // Auth Controller (shared across all auth pages)
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);

    // Register Controller
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}