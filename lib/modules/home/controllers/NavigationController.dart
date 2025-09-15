// lib/modules/home/controllers/navigation_controller.dart

import 'package:get/get.dart';
import '../../../shared/services/firebase/firebase_service.dart';
import '../../load/bindings/load_binding.dart';
import '../../load/controllers/load_controller.dart';
import '../../load/services/load_service.dart';

class NavigationController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  final RxInt currentIndex = 0.obs;
  final RxBool canPop = false.obs;

  @override
  void onInit() {
    super.onInit();
    LoadBinding().dependencies();


    _setupBackButtonHandler();
  }

  void _setupBackButtonHandler() {
    canPop.value = currentIndex.value != 0;
  }

  void changePage(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
      canPop.value = index != 0;

      // Track analytics
      _firebaseService.logEvent(
        name: 'navigation_tab_changed',
        parameters: {
          'tab_index': index,
          'tab_name': _getTabName(index),
        },
      );
    }
  }

  String _getTabName(int index) {
    switch (index) {
      case 0:
        return 'home';
      case 1:
        return 'my_loads';
      case 2:
        return 'booked_lorries';
      case 3:
        return 'profile';
      default:
        return 'unknown';
    }
  }

  bool onWillPop() {
    if (currentIndex.value != 0) {
      changePage(0);
      return false;
    }
    return true;
  }

  void goToHome() {
    changePage(0);
  }

  void goToLoads() {
    changePage(1);
  }

  void goToRides() {
    changePage(2);
  }

  void goToProfile() {
    changePage(3);
  }
}