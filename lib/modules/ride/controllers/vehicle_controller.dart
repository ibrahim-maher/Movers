// import 'package:get/get.dart';
//
// import '../models/vehicle_model.dart';
// import '../repositories/ride_repository.dart';
//
// class VehicleController extends GetxController {
//   final RideRepository _rideRepository = Get.find<RideRepository>();
//
//   // Expose repository properties
//   RxList<VehicleModel> get userVehicles => _rideRepository.userVehicles;
//   RxBool get isLoadingVehicles => _rideRepository.isLoadingVehicles;
//   RxString get errorMessage => _rideRepository.errorMessage;
//
//   // Selected vehicle
//   final Rx<VehicleModel?> selectedVehicle = Rx<VehicleModel?>(null);
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchUserVehicles();
//   }
//
//   Future<void> fetchUserVehicles() async {
//     await _rideRepository.fetchUserVehicles();
//   }
//
//   void selectVehicle(String vehicleId) {
//     selectedVehicle.value = userVehicles.firstWhereOrNull((v) => v.id == vehicleId);
//   }
//
//   void clearSelectedVehicle() {
//     selectedVehicle.value = null;
//   }
//
//   Future<void> refreshVehicles() async {
//     await fetchUserVehicles();
//   }
// }