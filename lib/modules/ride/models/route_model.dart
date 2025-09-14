import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteModel {
  final String id;
  final String name;
  final String departureLocation;
  final String destinationLocation;
  final double departureLatitude;
  final double departureLongitude;
  final double destinationLatitude;
  final double destinationLongitude;
  final double distance; // in kilometers
  final int estimatedDuration; // in minutes
  final List<LatLng> waypoints;

  RouteModel({
    required this.id,
    required this.name,
    required this.departureLocation,
    required this.destinationLocation,
    required this.departureLatitude,
    required this.departureLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.distance,
    required this.estimatedDuration,
    required this.waypoints,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> waypointsJson = json['waypoints'] ?? [];
    final List<LatLng> waypoints = waypointsJson
        .map((wp) => LatLng(wp['latitude'], wp['longitude']))
        .toList();

    return RouteModel(
      id: json['id'],
      name: json['name'],
      departureLocation: json['departure_location'],
      destinationLocation: json['destination_location'],
      departureLatitude: json['departure_latitude'].toDouble(),
      departureLongitude: json['departure_longitude'].toDouble(),
      destinationLatitude: json['destination_latitude'].toDouble(),
      destinationLongitude: json['destination_longitude'].toDouble(),
      distance: json['distance'].toDouble(),
      estimatedDuration: json['estimated_duration'],
      waypoints: waypoints,
    );
  }

  Map<String, dynamic> toJson() {
    final List<Map<String, double>> waypointsJson = waypoints
        .map((wp) => {'latitude': wp.latitude, 'longitude': wp.longitude})
        .toList();

    return {
      'id': id,
      'name': name,
      'departure_location': departureLocation,
      'destination_location': destinationLocation,
      'departure_latitude': departureLatitude,
      'departure_longitude': departureLongitude,
      'destination_latitude': destinationLatitude,
      'destination_longitude': destinationLongitude,
      'distance': distance,
      'estimated_duration': estimatedDuration,
      'waypoints': waypointsJson,
    };
  }
}