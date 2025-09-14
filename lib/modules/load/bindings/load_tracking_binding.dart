import 'package:get/get.dart';

import '../controllers/load_tracking_controller.dart';

class LoadTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoadTrackingController>(() => LoadTrackingController());
  }
}