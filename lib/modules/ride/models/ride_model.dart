// lib/modules/ride/models/ride_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class RideModel {
  final String id;
  final String userId;
  final String fromLocation;
  final String toLocation;
  final double fromLat;
  final double fromLng;
  final double toLat;
  final double toLng;
  final DateTime departureTime;
  final DateTime? arrivalTime;
  final int availableSeats;
  final double price;
  final String status;
  final String vehicleType;
  final String? vehicleModel;
  final String? vehiclePlate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String>? passengers;
  final Map<String, dynamic>? additionalInfo;

  const RideModel({
    required this.id,
    required this.userId,
    required this.fromLocation,
    required this.toLocation,
    required this.fromLat,
    required this.fromLng,
    required this.toLat,
    required this.toLng,
    required this.departureTime,
    this.arrivalTime,
    required this.availableSeats,
    required this.price,
    required this.status,
    required this.vehicleType,
    this.vehicleModel,
    this.vehiclePlate,
    required this.createdAt,
    required this.updatedAt,
    this.passengers,
    this.additionalInfo,
  });

  factory RideModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return RideModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      fromLocation: data['fromLocation'] ?? '',
      toLocation: data['toLocation'] ?? '',
      fromLat: (data['fromLat'] as num?)?.toDouble() ?? 0.0,
      fromLng: (data['fromLng'] as num?)?.toDouble() ?? 0.0,
      toLat: (data['toLat'] as num?)?.toDouble() ?? 0.0,
      toLng: (data['toLng'] as num?)?.toDouble() ?? 0.0,
      departureTime: (data['departureTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      arrivalTime: (data['arrivalTime'] as Timestamp?)?.toDate(),
      availableSeats: data['availableSeats']?.toInt() ?? 1,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] ?? 'available',
      vehicleType: data['vehicleType'] ?? '',
      vehicleModel: data['vehicleModel'],
      vehiclePlate: data['vehiclePlate'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      passengers: data['passengers'] != null ? List<String>.from(data['passengers']) : null,
      additionalInfo: data['additionalInfo'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'fromLocation': fromLocation,
      'toLocation': toLocation,
      'fromLat': fromLat,
      'fromLng': fromLng,
      'toLat': toLat,
      'toLng': toLng,
      'departureTime': Timestamp.fromDate(departureTime),
      'arrivalTime': arrivalTime != null ? Timestamp.fromDate(arrivalTime!) : null,
      'availableSeats': availableSeats,
      'price': price,
      'status': status,
      'vehicleType': vehicleType,
      'vehicleModel': vehicleModel,
      'vehiclePlate': vehiclePlate,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'passengers': passengers,
      'additionalInfo': additionalInfo,
    };
  }
}