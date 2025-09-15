// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../models/ride_model.dart';
// import '../models/route_model.dart';
// import '../repositories/ride_repository.dart';
//
// class RideTrackingController extends GetxController {
//   final RideRepository _rideRepository = Get.find<RideRepository>();
//
//   // Ride ID
//   late final String rideId;
//
//   // Expose repository properties
//   Rx<RideModel?> get selectedRide => _rideRepository.selectedRide;
//   Rx<RouteModel?> get selectedRoute => _rideRepository.selectedRoute;
//   RxBool get isLoading => _rideRepository.isLoading;
//   RxBool get isLoadingRoute => _rideRepository.isLoadingRoute;
//   RxString get errorMessage => _rideRepository.errorMessage;
//
//   // Map controller
//   Rx<GoogleMapController?> mapController = Rx<GoogleMapController?>(null);
//   final RxSet<Marker> markers = <Marker>{}.obs;
//   final RxSet<Polyline> polylines = <Polyline>{}.obs;
//   final Rx<CameraPosition> initialCameraPosition = CameraPosition(
//     target: const LatLng(0, 0),
//     zoom: 2,
//   ).obs;
//
//   // Current location
//   final Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
//
//   // Tracking history
//   final RxList<Map<String, dynamic>> trackingHistory = <Map<String, dynamic>>[].obs;
//   final RxBool isLoadingTracking = false.obs;
//
//   // Auto refresh timer
//   Timer? _refreshTimer;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Get ride ID from route parameters
//     rideId = Get.parameters['id'] ?? '';
//     if (rideId.isEmpty) {
//       Get.back(); // Go back if no ID provided
//       return;
//     }
//
//     fetchRideDetails();
//     _startRefreshTimer();
//   }
//
//   @override
//   void onClose() {
//     _refreshTimer?.cancel();
//     mapController.value?.dispose();
//     super.onClose();
//   }
//
//   void _startRefreshTimer() {
//     _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
//       fetchCurrentLocation();
//     });
//   }
//
//   Future<void> fetchRideDetails() async {
//     await _rideRepository.fetchRideById(rideId);
//     if (selectedRide.value != null) {
//       fetchTrackingData();
//     }
//   }
//
//   Future<void> fetchTrackingData() async {
//     await fetchCurrentLocation();
//     await fetchTrackingHistory();
//     _updateMapData();
//   }
//
//   Future<void> fetchCurrentLocation() async {
//     try {
//       final locationData = await _rideRepository.getRideLocation(rideId);
//       if (locationData != null &&
//           locationData['latitude'] != null &&
//           locationData['longitude'] != null) {
//         currentLocation.value = LatLng(
//           locationData['latitude'],
//           locationData['longitude'],
//         );
//         _updateCurrentLocationMarker();
//       }
//     } catch (e) {
//       // Silent fail for location updates
//     }
//   }
//
//   Future<void> fetchTrackingHistory() async {
//     try {
//       isLoadingTracking.value = true;
//       final history = await _rideRepository.getRideTrackingHistory(rideId);
//       trackingHistory.assignAll(history);
//     } finally {
//       isLoadingTracking.value = false;
//     }
//   }
//
//   void _updateMapData() {
//     if (selectedRoute.value != null) {
//       // Create polyline from route waypoints
//       final Set<Polyline> newPolylines = {
//         Polyline(
//           polylineId: const PolylineId('route'),
//           points: selectedRoute.value!.waypoints,
//           color: Colors.blue,
//           width: 5,
//         ),
//       };
//
//       // Create markers for departure and destination
//       final Set<Marker> newMarkers = {
//         Marker(
//           markerId: const MarkerId('departure'),
//           position: LatLng(
//             selectedRoute.value!.departureLatitude,
//             selectedRoute.value!.departureLongitude,
//           ),
//           infoWindow: InfoWindow(title: selectedRoute.value!.departureLocation),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//         ),
//         Marker(
//           markerId: const MarkerId('destination'),
//           position: LatLng(
//             selectedRoute.value!.destinationLatitude,
//             selectedRoute.value!.destinationLongitude,
//           ),
//           infoWindow: InfoWindow(title: selectedRoute.value!.destinationLocation),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         ),
//       };
//
//       polylines.value = newPolylines;
//       markers.value = newMarkers;
//
//       // Set initial camera position to show the route
//       if (selectedRoute.value!.waypoints.isNotEmpty) {
//         initialCameraPosition.value = CameraPosition(
//           target: selectedRoute.value!.waypoints[0],
//           zoom: 12,
//         );
//       }
//     } else if (currentLocation.value != null) {
//       // If no route available, center on current location
//       initialCameraPosition.value = CameraPosition(
//         target: currentLocation.value!,
//         zoom: 15,
//       );
//     }
//
//     // Add current location marker if available
//     _updateCurrentLocationMarker();
//   }
//
//   void _updateCurrentLocationMarker() {
//     if (currentLocation.value != null) {
//       final Set<Marker> updatedMarkers = Set.from(markers);
//
//       // Remove old current location marker if exists
//       updatedMarkers.removeWhere((marker) => marker.markerId.value == 'current_location');
//
//       // Add new current location marker
//       updatedMarkers.add(
//         Marker(
//           markerId: const MarkerId('current_location'),
//           position: currentLocation.value!,
//           infoWindow: const InfoWindow(title: 'Current Location'),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         ),
//       );
//
//       markers.value = updatedMarkers;
//
//       // Update camera position to follow current location
//       mapController.value?.animateCamera(
//         CameraUpdate.newLatLng(currentLocation.value!),
//       );
//     }
//   }
//
//   void onMapCreated(GoogleMapController controller) {
//     mapController.value = controller;
//   }
//
//   Future<void> refreshData() async {
//     await fetchRideDetails();
//   }
//
//   String getFormattedTimestamp(String timestamp) {
//     final dateTime = DateTime.parse(timestamp);
//     return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} - ${dateTime.day}/${dateTime.month}/${dateTime.year}';
//   }
// }