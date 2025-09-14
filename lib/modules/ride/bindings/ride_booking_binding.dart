import 'package:get/get.dart';

import '../controllers/ride_booking_controller.dart';

class RideBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RideBookingController>(() => RideBookingController());
  }
}