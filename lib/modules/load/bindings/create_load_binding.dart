import 'package:get/get.dart';

import '../controllers/create_load_controller.dart';

class CreateLoadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateLoadController>(() => CreateLoadController());
  }
}