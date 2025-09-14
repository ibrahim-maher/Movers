import 'package:get/get.dart';

import '../controllers/load_list_controller.dart';

class LoadListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoadListController>(() => LoadListController());
  }
}