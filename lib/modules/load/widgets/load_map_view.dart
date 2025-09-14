import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LoadMapView extends StatelessWidget {
  final CameraPosition initialCameraPosition;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final Function(GoogleMapController) onMapCreated;
  final Function(LatLng)? onTap;
  final bool isInteractive;
  final double height;

  const LoadMapView({
    super.key,
    required this.initialCameraPosition,
    required this.markers,
    required this.polylines,
    required this.onMapCreated,
    this.onTap,
    this.isInteractive = true,
    this.height = 300.0,
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
              onTap: onTap,
              zoomControlsEnabled: isInteractive,
              zoomGesturesEnabled: isInteractive,
              scrollGesturesEnabled: isInteractive,
              rotateGesturesEnabled: isInteractive,
              tiltGesturesEnabled: isInteractive,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: isInteractive,
            ),
            if (onTap != null)
              Positioned(
                bottom: 16.0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      'Tap on the map to select location',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}