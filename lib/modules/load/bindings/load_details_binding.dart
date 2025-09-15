import 'package:get/get.dart';
import '../controllers/load_details_controller.dart';
import '../services/load_service.dart';

class LoadDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoadService>(() => LoadService(), fenix: true);
    Get.lazyPut<LoadDetailsController>(() => LoadDetailsController());
  }
}