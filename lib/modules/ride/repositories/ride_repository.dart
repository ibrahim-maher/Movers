import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/booking_request_model.dart';
import '../models/ride_booking_model.dart';
import '../models/ride_model.dart';
import '../models/route_model.dart';
import '../models/vehicle_model.dart';
import '../services/ride_service.dart';
import '../services/ride_tracking_service.dart';

class RideRepository extends GetxService {
  final RideService _rideService = Get.find<RideService>();
  final RideTrackingService _trackingService = Get.find<RideTrackingService>();

  // Observable lists
  final RxList<RideModel> rides = <RideModel>[].obs;
  final RxList<RideBookingModel> userBookings = <RideBookingModel>[].obs;
  final RxList<VehicleModel> userVehicles = <VehicleModel>[].obs;
  
  // Selected ride
  final Rx<RideModel?> selectedRide = Rx<RideModel?>(null);
  final Rx<RouteModel?> selectedRoute = Rx<RouteModel?>(null);
  
  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isLoadingBookings = false.obs;
  final RxBool isLoadingVehicles = false.obs;
  final RxBool isLoadingRoute = false.obs;
  final RxBool isSubmitting = false.obs;

  // Error message
  final RxString errorMessage = ''.obs;

  Future<void> fetchRides() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final ridesList = await _rideService.getRides();
      rides.assignAll(ridesList);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRideById(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final ride = await _rideService.getRideById(id);
      selectedRide.value = ride;
      
      // Also fetch the route for this ride
      await fetchRouteForRide(id);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserBookings() async {
    try {
      isLoadingBookings.value = true;
      
      final bookingsList = await _rideService.getUserBookings();
      userBookings.assignAll(bookingsList);
    } catch (e) {
      // Silent fail for bookings
    } finally {
      isLoadingBookings.value = false;
    }
  }

  Future<void> fetchUserVehicles() async {
    try {
      isLoadingVehicles.value = true;
      
      final vehiclesList = await _rideService.getUserVehicles();
      userVehicles.assignAll(vehiclesList);
    } catch (e) {
      // Silent fail for vehicles
    } finally {
      isLoadingVehicles.value = false;
    }
  }

  Future<void> fetchRouteForRide(String rideId) async {
    try {
      isLoadingRoute.value = true;
      
      final route = await _rideService.getRouteForRide(rideId);
      selectedRoute.value = route;
    } catch (e) {
      // Silent fail for route
      selectedRoute.value = null;
    } finally {
      isLoadingRoute.value = false;
    }
  }

  Future<bool> bookRide(String rideId, int seats, {String? notes}) async {
    try {
      isSubmitting.value = true;
      errorMessage.value = '';
      
      final request = BookingRequestModel(
        rideId: rideId,
        seats: seats,
        notes: notes,
      );
      
      final booking = await _rideService.bookRide(request);
      userBookings.add(booking);
      
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    try {
      isSubmitting.value = true;
      errorMessage.value = '';
      
      await _rideService.cancelBooking(bookingId);
      
      // Remove from the list
      userBookings.removeWhere((booking) => booking.id == bookingId);
      
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<Map<String, dynamic>?> getRideLocation(String rideId) async {
    try {
      return await _trackingService.getRideLocation(rideId);
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateRideLocation(String rideId, LatLng location) async {
    try {
      await _trackingService.updateRideLocation(rideId, location);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getRideTrackingHistory(String rideId) async {
    try {
      return await _trackingService.getRideTrackingHistory(rideId);
    } catch (e) {
      return [];
    }
  }

  Future<bool> updateRideStatus(String rideId, String statusId) async {
    try {
      isSubmitting.value = true;
      errorMessage.value = '';
      
      await _trackingService.updateRideStatus(rideId, statusId);
      
      // Refresh the ride details
      await fetchRideById(rideId);
      
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}