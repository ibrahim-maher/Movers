import 'package:get/get.dart';

import '../controllers/load_controller.dart';
import '../repositories/load_repository.dart';
import '../services/load_service.dart';
import '../services/load_tracking_service.dart';

class LoadBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<LoadService>(() => LoadService());
    Get.lazyPut<LoadTrackingService>(() => LoadTrackingService());
    
    // Repository
    Get.lazyPut<LoadRepository>(() => LoadRepository());
    
    // Controller
    Get.lazyPut<LoadController>(() => LoadController());
  }
}