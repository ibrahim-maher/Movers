// ===================================
// modules/home/bindings/home_binding.dart - SIMPLE VERSION
// ===================================
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../services/dashboard_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardService>(() => DashboardService());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
