import 'package:get/get.dart';

import '../controllers/ride_tracking_controller.dart';

class RideTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RideTrackingController>(() => RideTrackingController());
  }
}