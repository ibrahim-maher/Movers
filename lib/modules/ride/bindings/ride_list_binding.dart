import 'package:get/get.dart';

import '../controllers/ride_list_controller.dart';

class RideListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RideListController>(() => RideListController());
  }
}