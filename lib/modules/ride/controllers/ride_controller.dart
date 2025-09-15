// import 'package:get/get.dart';
//
// import '../models/ride_booking_model.dart';
// import '../models/ride_model.dart';
// import '../models/route_model.dart';
// import '../models/vehicle_model.dart';
// import '../repositories/ride_repository.dart';
//
// class RideController extends GetxController {
//   final RideRepository _rideRepository = Get.find<RideRepository>();
//
//   // Expose repository properties
//   RxList<RideModel> get rides => _rideRepository.rides;
//   RxList<RideBookingModel> get userBookings => _rideRepository.userBookings;
//   RxList<VehicleModel> get userVehicles => _rideRepository.userVehicles;
//   Rx<RideModel?> get selectedRide => _rideRepository.selectedRide;
//   Rx<RouteModel?> get selectedRoute => _rideRepository.selectedRoute;
//   RxBool get isLoading => _rideRepository.isLoading;
//   RxBool get isLoadingBookings => _rideRepository.isLoadingBookings;
//   RxBool get isLoadingVehicles => _rideRepository.isLoadingVehicles;
//   RxBool get isLoadingRoute => _rideRepository.isLoadingRoute;
//   RxBool get isSubmitting => _rideRepository.isSubmitting;
//   RxString get errorMessage => _rideRepository.errorMessage;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchRides();
//     fetchUserBookings();
//   }
//
//   Future<void> fetchRides() async {
//     await _rideRepository.fetchRides();
//   }
//
//   Future<void> fetchRideById(String id) async {
//     await _rideRepository.fetchRideById(id);
//   }
//
//   Future<void> fetchUserBookings() async {
//     await _rideRepository.fetchUserBookings();
//   }
//
//   Future<void> fetchUserVehicles() async {
//     await _rideRepository.fetchUserVehicles();
//   }
//
//   Future<void> refreshData() async {
//     await fetchRides();
//     await fetchUserBookings();
//   }
//
//   Future<bool> bookRide(String rideId, int seats, {String? notes}) async {
//     return await _rideRepository.bookRide(rideId, seats, notes: notes);
//   }
//
//   Future<bool> cancelBooking(String bookingId) async {
//     return await _rideRepository.cancelBooking(bookingId);
//   }
//
//   bool hasUserBookedRide(String rideId) {
//     return userBookings.any((booking) => booking.rideId == rideId);
//   }
//
//   RideBookingModel? getUserBookingForRide(String rideId) {
//     return userBookings.firstWhereOrNull((booking) => booking.rideId == rideId);
//   }
// }