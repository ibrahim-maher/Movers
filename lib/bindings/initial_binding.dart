import 'package:get/get.dart';
import '../shared/services/firebase/firebase_service.dart';
import '../shared/services/storage/local_storage_service.dart';
import '../shared/services/connectivity/network_service.dart';
import '../shared/services/theme/theme_service.dart';
import '../shared/services/language/language_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core Services
    Get.put<LocalStorageService>(LocalStorageService(), permanent: true);
    Get.put<NetworkService>(NetworkService(), permanent: true);
    Get.put<FirebaseService>(FirebaseService(), permanent: true);
    Get.put<ThemeService>(ThemeService(), permanent: true);
    Get.put<LanguageService>(LanguageService(), permanent: true);
  }
}