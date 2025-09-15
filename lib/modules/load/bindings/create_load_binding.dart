import 'package:get/get.dart';
import '../controllers/create_load_controller.dart';
import '../services/load_service.dart';

class CreateLoadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoadService>(() => LoadService(), fenix: true);
    Get.lazyPut<CreateLoadController>(() => CreateLoadController());
  }
}