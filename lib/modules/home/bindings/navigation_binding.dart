// lib/modules/home/bindings/navigation_binding.dart

import 'package:get/get.dart';
import '../controllers/NavigationController.dart';
import '../controllers/home_controller.dart';
import '../../../shared/services/firebase/firebase_service.dart';
import '../../../shared/services/storage/local_storage_service.dart';
import '../../../shared/services/connectivity/network_service.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure required services are available
    Get.lazyPut<FirebaseService>(() => FirebaseService(), fenix: true);
    Get.lazyPut<LocalStorageService>(() => LocalStorageService(), fenix: true);
    Get.lazyPut<NetworkService>(() => NetworkService(), fenix: true);

    // Register NavigationController
    Get.lazyPut<NavigationController>(() => NavigationController(), fenix: true);

    // Register HomeController (needed for home page)
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }
}