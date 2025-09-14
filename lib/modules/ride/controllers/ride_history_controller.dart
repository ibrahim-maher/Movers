import 'package:get/get.dart';

import '../models/ride_booking_model.dart';
import '../repositories/ride_repository.dart';

class RideHistoryController extends GetxController {
  final RideRepository _rideRepository = Get.find<RideRepository>();

  // Expose repository properties
  RxList<RideBookingModel> get userBookings => _rideRepository.userBookings;
  RxBool get isLoadingBookings => _rideRepository.isLoadingBookings;
  RxString get errorMessage => _rideRepository.errorMessage;

  // Filtered bookings
  final RxList<RideBookingModel> activeBookings = <RideBookingModel>[].obs;
  final RxList<RideBookingModel> pastBookings = <RideBookingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserBookings();
    _setupListeners();
  }

  void _setupListeners() {
    // Listen to bookings changes to filter them
    ever(userBookings, (_) => _filterBookings());
  }

  void _filterBookings() {
    final now = DateTime.now();
    
    // Active bookings are those with future dates or in progress
    final active = userBookings.where((booking) {
      // Consider bookings with status 'cancelled' or 'completed' as not active
      if (booking.statusId == '5' || booking.statusId == '4') { // Assuming 5 is cancelled and 4 is completed
        return false;
      }
      return booking.bookingDate.isAfter(now);
    }).toList();
    
    // Past bookings are those with past dates or completed/cancelled
    final past = userBookings.where((booking) {
      return booking.bookingDate.isBefore(now) || 
             booking.statusId == '5' || 
             booking.statusId == '4';
    }).toList();
    
    // Sort active bookings by date (soonest first)
    active.sort((a, b) => a.bookingDate.compareTo(b.bookingDate));
    
    // Sort past bookings by date (most recent first)
    past.sort((a, b) => b.bookingDate.compareTo(a.bookingDate));
    
    activeBookings.assignAll(active);
    pastBookings.assignAll(past);
  }

  Future<void> fetchUserBookings() async {
    await _rideRepository.fetchUserBookings();
  }

  Future<void> refreshBookings() async {
    await fetchUserBookings();
  }

  Future<bool> cancelBooking(String bookingId) async {
    return await _rideRepository.cancelBooking(bookingId);
  }

  void navigateToRideDetails(String rideId) {
    Get.toNamed('/ride/details/$rideId');
  }
}