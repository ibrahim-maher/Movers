import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteMap extends StatelessWidget {
  final CameraPosition initialCameraPosition;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final Function(GoogleMapController) onMapCreated;
  final double height;
  final bool showCurrentLocation;
  final LatLng? currentLocation;

  const RouteMap({
    super.key,
    required this.initialCameraPosition,
    required this.markers,
    required this.polylines,
    required this.onMapCreated,
    this.height = 300.0,
    this.showCurrentLocation = false,
    this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: initialCameraPosition,
              markers: markers,
              polylines: polylines,
              onMapCreated: onMapCreated,
              zoomControlsEnabled: false,
              myLocationEnabled: showCurrentLocation,
              myLocationButtonEnabled: showCurrentLocation,
              mapToolbarEnabled: false,
              compassEnabled: true,
            ),
            if (currentLocation != null)
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: FloatingActionButton.small(
                  onPressed: () {
                    // This would be handled by the controller
                  },
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  child: const Icon(Icons.my_location),
                ),
              ),
          ],
        ),
      ),
    );
  }
}