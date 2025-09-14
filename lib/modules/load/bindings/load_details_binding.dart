import 'package:get/get.dart';

import '../controllers/load_details_controller.dart';

class LoadDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoadDetailsController>(() => LoadDetailsController());
  }
}