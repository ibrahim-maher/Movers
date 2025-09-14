import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/ride_model.dart';
import '../repositories/ride_repository.dart';

class RideListController extends GetxController {
  final RideRepository _rideRepository = Get.find<RideRepository>();

  // Expose repository properties
  RxList<RideModel> get rides => _rideRepository.rides;
  RxBool get isLoading => _rideRepository.isLoading;
  RxString get errorMessage => _rideRepository.errorMessage;

  // Search and filter
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString selectedDepartureLocation = ''.obs;
  final RxString selectedDestinationLocation = ''.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxList<RideModel> filteredRides = <RideModel>[].obs;

  // Unique locations for filtering
  final RxList<String> departureLocations = <String>[].obs;
  final RxList<String> destinationLocations = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRides();
    _setupListeners();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _setupListeners() {
    // Listen to search query changes
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      _applyFilters();
    });

    // Listen to rides changes
    ever(rides, (_) {
      _extractLocations();
      _applyFilters();
    });

    // Listen to filter changes
    ever(selectedDepartureLocation, (_) => _applyFilters());
    ever(selectedDestinationLocation, (_) => _applyFilters());
    ever(selectedDate, (_) => _applyFilters());
  }

  void _extractLocations() {
    final departures = rides.map((ride) => ride.departureLocation).toSet().toList();
    final destinations = rides.map((ride) => ride.destinationLocation).toSet().toList();
    
    departures.sort();
    destinations.sort();
    
    departureLocations.assignAll(departures);
    destinationLocations.assignAll(destinations);
  }

  void _applyFilters() {
    List<RideModel> result = List.from(rides);

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((ride) {
        return ride.title.toLowerCase().contains(query) ||
               ride.description.toLowerCase().contains(query) ||
               ride.departureLocation.toLowerCase().contains(query) ||
               ride.destinationLocation.toLowerCase().contains(query);
      }).toList();
    }

    // Apply departure location filter
    if (selectedDepartureLocation.isNotEmpty) {
      result = result.where((ride) => ride.departureLocation == selectedDepartureLocation.value).toList();
    }

    // Apply destination location filter
    if (selectedDestinationLocation.isNotEmpty) {
      result = result.where((ride) => ride.destinationLocation == selectedDestinationLocation.value).toList();
    }

    // Apply date filter
    if (selectedDate.value != null) {
      result = result.where((ride) {
        final rideDate = DateTime(
          ride.departureDate.year,
          ride.departureDate.month,
          ride.departureDate.day,
        );
        final filterDate = DateTime(
          selectedDate.value!.year,
          selectedDate.value!.month,
          selectedDate.value!.day,
        );
        return rideDate.isAtSameMomentAs(filterDate);
      }).toList();
    }

    // Sort by departure date (soonest first)
    result.sort((a, b) => a.departureDate.compareTo(b.departureDate));

    filteredRides.assignAll(result);
  }

  Future<void> fetchRides() async {
    await _rideRepository.fetchRides();
  }

  Future<void> refreshRides() async {
    await fetchRides();
  }

  void clearFilters() {
    searchController.clear();
    selectedDepartureLocation.value = '';
    selectedDestinationLocation.value = '';
    selectedDate.value = null;
  }

  void selectDepartureLocation(String location) {
    if (selectedDepartureLocation.value == location) {
      selectedDepartureLocation.value = ''; // Toggle off if already selected
    } else {
      selectedDepartureLocation.value = location;
    }
  }

  void selectDestinationLocation(String location) {
    if (selectedDestinationLocation.value == location) {
      selectedDestinationLocation.value = ''; // Toggle off if already selected
    } else {
      selectedDestinationLocation.value = location;
    }
  }

  void selectDate(DateTime date) {
    if (selectedDate.value != null &&
        selectedDate.value!.year == date.year &&
        selectedDate.value!.month == date.month &&
        selectedDate.value!.day == date.day) {
      selectedDate.value = null; // Toggle off if already selected
    } else {
      selectedDate.value = date;
    }
  }

  void navigateToRideDetails(String rideId) {
    Get.toNamed('/ride/details/$rideId');
  }
}