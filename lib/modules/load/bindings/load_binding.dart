import 'package:get/get.dart';
import '../controllers/load_controller.dart';
import '../services/load_service.dart';

class LoadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoadService>(() => LoadService(), fenix: true);
    Get.lazyPut<LoadController>(() => LoadController());
  }
}
