import 'package:get/get.dart';
import '../modules/auth/services/token_service.dart';
import '../shared/services/storage/local_storage_service.dart';
import '../shared/services/language/language_service.dart';
import '../shared/services/firebase/firebase_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    print('🔧 InitialBinding: Registering services...');

    // Register services - they will initialize themselves
    Get.put<LocalStorageService>(LocalStorageService(), permanent: true);
    Get.put<FirebaseService>(FirebaseService(), permanent: true);
    Get.put<LanguageService>(LanguageService(), permanent: true);
    Get.put<TokenService>(TokenService(), permanent: true);
    print('✅ All services registered in InitialBinding');
  }
}