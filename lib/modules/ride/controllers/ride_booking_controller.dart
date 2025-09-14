import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/ride_model.dart';
import '../repositories/ride_repository.dart';

class RideBookingController extends GetxController {
  final RideRepository _rideRepository = Get.find<RideRepository>();

  // Expose repository properties
  Rx<RideModel?> get selectedRide => _rideRepository.selectedRide;
  RxBool get isLoading => _rideRepository.isLoading;
  RxBool get isSubmitting => _rideRepository.isSubmitting;
  RxString get errorMessage => _rideRepository.errorMessage;

  // Form controllers
  final TextEditingController notesController = TextEditingController();
  
  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Selected seats
  final RxInt selectedSeats = 1.obs;
  
  // Total price
  final RxDouble totalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Get ride ID from route parameters
    final String? rideId = Get.parameters['id'];
    if (rideId != null) {
      fetchRideDetails(rideId);
    } else {
      Get.back(); // Go back if no ID provided
    }
    
    // Listen to selected seats changes to update total price
    ever(selectedSeats, (_) => _updateTotalPrice());
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  Future<void> fetchRideDetails(String rideId) async {
    await _rideRepository.fetchRideById(rideId);
    _updateTotalPrice();
  }

  void _updateTotalPrice() {
    if (selectedRide.value != null) {
      totalPrice.value = selectedRide.value!.price * selectedSeats.value;
    }
  }

  void incrementSeats() {
    if (selectedRide.value != null && 
        selectedSeats.value < selectedRide.value!.availableSeats) {
      selectedSeats.value++;
    }
  }

  void decrementSeats() {
    if (selectedSeats.value > 1) {
      selectedSeats.value--;
    }
  }

  Future<bool> bookRide() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }
    
    if (selectedRide.value == null) {
      return false;
    }
    
    final success = await _rideRepository.bookRide(
      selectedRide.value!.id,
      selectedSeats.value,
      notes: notesController.text.trim().isNotEmpty ? notesController.text.trim() : null,
    );
    
    return success;
  }

  // Validation
  String? validateSeats(String? value) {
    if (selectedRide.value == null) {
      return 'Ride not available';
    }
    
    final seats = int.tryParse(value ?? '') ?? 0;
    if (seats <= 0) {
      return 'Please select at least 1 seat';
    }
    if (seats > selectedRide.value!.availableSeats) {
      return 'Only ${selectedRide.value!.availableSeats} seats available';
    }
    return null;
  }
}