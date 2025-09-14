import 'package:get/get.dart';

import '../controllers/ride_controller.dart';
import '../repositories/ride_repository.dart';
import '../services/ride_service.dart';
import '../services/ride_tracking_service.dart';

class RideBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<RideService>(() => RideService());
    Get.lazyPut<RideTrackingService>(() => RideTrackingService());
    
    // Repository
    Get.lazyPut<RideRepository>(() => RideRepository());
    
    // Controller
    Get.lazyPut<RideController>(() => RideController());
  }
}