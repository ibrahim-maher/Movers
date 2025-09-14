import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/load_model.dart';
import '../models/load_status_model.dart';
import '../models/load_tracking_model.dart';
import '../repositories/load_repository.dart';

class LoadTrackingController extends GetxController {
  final LoadRepository _loadRepository = Get.find<LoadRepository>();

  // Load ID
  late final String loadId;
  
  // Expose repository properties
  Rx<LoadModel?> get selectedLoad => _loadRepository.selectedLoad;
  RxList<LoadStatusModel> get statuses => _loadRepository.statuses;
  RxBool get isLoading => _loadRepository.isLoading;
  RxBool get isSubmitting => _loadRepository.isSubmitting;
  RxString get errorMessage => _loadRepository.errorMessage;

  // Tracking data
  final RxList<LoadTrackingModel> trackingHistory = <LoadTrackingModel>[].obs;
  final RxBool isLoadingTracking = false.obs;
  final Rx<LoadTrackingModel?> latestTracking = Rx<LoadTrackingModel?>(null);
  
  // Map controller
  Rx<GoogleMapController?> mapController = Rx<GoogleMapController?>(null);
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final Rx<CameraPosition> initialCameraPosition = CameraPosition(
    target: const LatLng(0, 0),
    zoom: 2,
  ).obs;
  
  // Form controllers for adding tracking update
  final TextEditingController locationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final RxString selectedStatusId = ''.obs;
  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;
  
  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    // Get load ID from route parameters
    loadId = Get.parameters['id'] ?? '';
    if (loadId.isEmpty) {
      Get.back(); // Go back if no ID provided
      return;
    }
    
    fetchLoadDetails();
  }

  @override
  void onClose() {
    locationController.dispose();
    notesController.dispose();
    mapController.value?.dispose();
    super.onClose();
  }

  Future<void> fetchLoadDetails() async {
    await _loadRepository.fetchLoadById(loadId);
    if (selectedLoad.value != null) {
      fetchTrackingData();
    } else {
      Get.back(); // Go back if load not found
    }
  }

  Future<void> fetchTrackingData() async {
    try {
      isLoadingTracking.value = true;
      
      // Fetch tracking history
      final history = await _loadRepository.getTrackingHistory(loadId);
      trackingHistory.assignAll(history);
      
      // Fetch latest tracking
      final latest = await _loadRepository.getLatestTracking(loadId);
      latestTracking.value = latest;
      
      // Update map
      if (latest != null) {
        updateMapPosition(LatLng(latest.latitude, latest.longitude));
        selectedStatusId.value = latest.statusId;
      } else if (selectedLoad.value != null) {
        // Default to pickup location if no tracking available
        selectedStatusId.value = selectedLoad.value!.statusId;
      }
      
      // Create markers and polylines
      _createMarkersAndPolylines();
    } finally {
      isLoadingTracking.value = false;
    }
  }

  void _createMarkersAndPolylines() {
    if (trackingHistory.isEmpty) return;
    
    final Set<Marker> newMarkers = {};
    final List<LatLng> points = [];
    
    // Add markers for each tracking point
    for (int i = 0; i < trackingHistory.length; i++) {
      final tracking = trackingHistory[i];
      final latLng = LatLng(tracking.latitude, tracking.longitude);
      
      points.add(latLng);
      
      newMarkers.add(
        Marker(
          markerId: MarkerId('tracking_$i'),
          position: latLng,
          infoWindow: InfoWindow(
            title: tracking.statusName,
            snippet: tracking.location,
          ),
        ),
      );
    }
    
    // Create polyline
    final Set<Polyline> newPolylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: points,
        color: Colors.blue,
        width: 5,
      ),
    };
    
    markers.value = newMarkers;
    polylines.value = newPolylines;
  }

  void updateMapPosition(LatLng position) {
    initialCameraPosition.value = CameraPosition(
      target: position,
      zoom: 15,
    );
    
    mapController.value?.animateCamera(
      CameraUpdate.newCameraPosition(initialCameraPosition.value),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController.value = controller;
  }

  void onMapTap(LatLng position) {
    latitude.value = position.latitude;
    longitude.value = position.longitude;
  }

  Future<bool> addTrackingUpdate() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }
    
    if (latitude.value == 0 && longitude.value == 0) {
      errorMessage.value = 'Please select a location on the map';
      return false;
    }
    
    try {
      final success = await _loadRepository.addTrackingUpdate(
        loadId,
        selectedStatusId.value,
        locationController.text.trim(),
        latitude.value,
        longitude.value,
        notesController.text.trim(),
      );
      
      if (success) {
        // Clear form
        locationController.clear();
        notesController.clear();
        
        // Refresh data
        await fetchTrackingData();
        
        Get.snackbar(
          'Success',
          'Tracking update added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
      
      return success;
    } catch (e) {
      errorMessage.value = 'Failed to add tracking update: ${e.toString()}';
      return false;
    }
  }

  // Validation
  String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Location is required';
    }
    return null;
  }

  String? validateStatus(String? value) {
    if (value == null || value.isEmpty) {
      return 'Status is required';
    }
    return null;
  }
}