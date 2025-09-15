// lib/modules/load/models/load_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class LoadModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String materialName;
  final double weight; // in tonnes
  final String pickupLocation;
  final String dropLocation;
  final String pickupAddress;
  final String dropAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final double dropLatitude;
  final double dropLongitude;
  final String vehicleType;
  final String vehicleIcon;
  final double expectedPrice;
  final bool isFixedPrice;
  final String priceType; // 'fixed' or 'negotiable'
  final int visibilityHours;
  final String status;
  final String pickupContactName;
  final String pickupContactPhone;
  final String dropContactName;
  final String dropContactPhone;
  final DateTime? pickupDate;
  final DateTime? deliveryDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> images;
  final Map<String, dynamic>? metadata;
  final double distance; // in KM
  final String? assignedDriverId;
  final String? assignedDriverName;
  final double? finalPrice;
  final String? paymentStatus;
  final String? trackingId;
  final List<LoadBid> bids;

  LoadModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.materialName,
    required this.weight,
    required this.pickupLocation,
    required this.dropLocation,
    required this.pickupAddress,
    required this.dropAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropLatitude,
    required this.dropLongitude,
    required this.vehicleType,
    required this.vehicleIcon,
    required this.expectedPrice,
    required this.isFixedPrice,
    required this.priceType,
    required this.visibilityHours,
    required this.status,
    required this.pickupContactName,
    required this.pickupContactPhone,
    required this.dropContactName,
    required this.dropContactPhone,
    this.pickupDate,
    this.deliveryDate,
    required this.createdAt,
    required this.updatedAt,
    this.images = const [],
    this.metadata,
    required this.distance,
    this.assignedDriverId,
    this.assignedDriverName,
    this.finalPrice,
    this.paymentStatus,
    this.trackingId,
    this.bids = const [],
  });

  factory LoadModel.fromJson(Map<String, dynamic> json) {
    return LoadModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      materialName: json['materialName'] ?? '',
      weight: (json['weight'] ?? 0).toDouble(),
      pickupLocation: json['pickupLocation'] ?? '',
      dropLocation: json['dropLocation'] ?? '',
      pickupAddress: json['pickupAddress'] ?? '',
      dropAddress: json['dropAddress'] ?? '',
      pickupLatitude: (json['pickupLatitude'] ?? 0).toDouble(),
      pickupLongitude: (json['pickupLongitude'] ?? 0).toDouble(),
      dropLatitude: (json['dropLatitude'] ?? 0).toDouble(),
      dropLongitude: (json['dropLongitude'] ?? 0).toDouble(),
      vehicleType: json['vehicleType'] ?? '',
      vehicleIcon: json['vehicleIcon'] ?? '',
      expectedPrice: (json['expectedPrice'] ?? 0).toDouble(),
      isFixedPrice: json['isFixedPrice'] ?? false,
      priceType: json['priceType'] ?? 'negotiable',
      visibilityHours: json['visibilityHours'] ?? 24,
      status: json['status'] ?? 'pending',
      pickupContactName: json['pickupContactName'] ?? '',
      pickupContactPhone: json['pickupContactPhone'] ?? '',
      dropContactName: json['dropContactName'] ?? '',
      dropContactPhone: json['dropContactPhone'] ?? '',
      pickupDate: json['pickupDate'] != null ? DateTime.parse(json['pickupDate']) : null,
      deliveryDate: json['deliveryDate'] != null ? DateTime.parse(json['deliveryDate']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      images: List<String>.from(json['images'] ?? []),
      metadata: json['metadata'],
      distance: (json['distance'] ?? 0).toDouble(),
      assignedDriverId: json['assignedDriverId'],
      assignedDriverName: json['assignedDriverName'],
      finalPrice: json['finalPrice']?.toDouble(),
      paymentStatus: json['paymentStatus'],
      trackingId: json['trackingId'],
      bids: (json['bids'] as List?)?.map((e) => LoadBid.fromJson(e)).toList() ?? [],
    );
  }

  factory LoadModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LoadModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'materialName': materialName,
      'weight': weight,
      'pickupLocation': pickupLocation,
      'dropLocation': dropLocation,
      'pickupAddress': pickupAddress,
      'dropAddress': dropAddress,
      'pickupLatitude': pickupLatitude,
      'pickupLongitude': pickupLongitude,
      'dropLatitude': dropLatitude,
      'dropLongitude': dropLongitude,
      'vehicleType': vehicleType,
      'vehicleIcon': vehicleIcon,
      'expectedPrice': expectedPrice,
      'isFixedPrice': isFixedPrice,
      'priceType': priceType,
      'visibilityHours': visibilityHours,
      'status': status,
      'pickupContactName': pickupContactName,
      'pickupContactPhone': pickupContactPhone,
      'dropContactName': dropContactName,
      'dropContactPhone': dropContactPhone,
      'pickupDate': pickupDate?.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'images': images,
      'metadata': metadata,
      'distance': distance,
      'assignedDriverId': assignedDriverId,
      'assignedDriverName': assignedDriverName,
      'finalPrice': finalPrice,
      'paymentStatus': paymentStatus,
      'trackingId': trackingId,
      'bids': bids.map((e) => e.toJson()).toList(),
    };
  }

  LoadModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? materialName,
    double? weight,
    String? pickupLocation,
    String? dropLocation,
    String? pickupAddress,
    String? dropAddress,
    double? pickupLatitude,
    double? pickupLongitude,
    double? dropLatitude,
    double? dropLongitude,
    String? vehicleType,
    String? vehicleIcon,
    double? expectedPrice,
    bool? isFixedPrice,
    String? priceType,
    int? visibilityHours,
    String? status,
    String? pickupContactName,
    String? pickupContactPhone,
    String? dropContactName,
    String? dropContactPhone,
    DateTime? pickupDate,
    DateTime? deliveryDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? images,
    Map<String, dynamic>? metadata,
    double? distance,
    String? assignedDriverId,
    String? assignedDriverName,
    double? finalPrice,
    String? paymentStatus,
    String? trackingId,
    List<LoadBid>? bids,
  }) {
    return LoadModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      materialName: materialName ?? this.materialName,
      weight: weight ?? this.weight,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropLocation: dropLocation ?? this.dropLocation,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      dropAddress: dropAddress ?? this.dropAddress,
      pickupLatitude: pickupLatitude ?? this.pickupLatitude,
      pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      dropLatitude: dropLatitude ?? this.dropLatitude,
      dropLongitude: dropLongitude ?? this.dropLongitude,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleIcon: vehicleIcon ?? this.vehicleIcon,
      expectedPrice: expectedPrice ?? this.expectedPrice,
      isFixedPrice: isFixedPrice ?? this.isFixedPrice,
      priceType: priceType ?? this.priceType,
      visibilityHours: visibilityHours ?? this.visibilityHours,
      status: status ?? this.status,
      pickupContactName: pickupContactName ?? this.pickupContactName,
      pickupContactPhone: pickupContactPhone ?? this.pickupContactPhone,
      dropContactName: dropContactName ?? this.dropContactName,
      dropContactPhone: dropContactPhone ?? this.dropContactPhone,
      pickupDate: pickupDate ?? this.pickupDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      images: images ?? this.images,
      metadata: metadata ?? this.metadata,
      distance: distance ?? this.distance,
      assignedDriverId: assignedDriverId ?? this.assignedDriverId,
      assignedDriverName: assignedDriverName ?? this.assignedDriverName,
      finalPrice: finalPrice ?? this.finalPrice,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      trackingId: trackingId ?? this.trackingId,
      bids: bids ?? this.bids,
    );
  }
}

class LoadBid {
  final String id;
  final String loadId;
  final String bidderId;
  final String bidderName;
  final String? bidderAvatar;
  final double bidAmount;
  final String message;
  final double rating;
  final String status; // 'pending', 'accepted', 'rejected'
  final DateTime createdAt;

  LoadBid({
    required this.id,
    required this.loadId,
    required this.bidderId,
    required this.bidderName,
    this.bidderAvatar,
    required this.bidAmount,
    required this.message,
    required this.rating,
    required this.status,
    required this.createdAt,
  });

  factory LoadBid.fromJson(Map<String, dynamic> json) {
    return LoadBid(
      id: json['id'] ?? '',
      loadId: json['loadId'] ?? '',
      bidderId: json['bidderId'] ?? '',
      bidderName: json['bidderName'] ?? '',
      bidderAvatar: json['bidderAvatar'],
      bidAmount: (json['bidAmount'] ?? 0).toDouble(),
      message: json['message'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loadId': loadId,
      'bidderId': bidderId,
      'bidderName': bidderName,
      'bidderAvatar': bidderAvatar,
      'bidAmount': bidAmount,
      'message': message,
      'rating': rating,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class VehicleType {
  final String id;
  final String name;
  final String icon;
  final String capacityRange;
  final double minCapacity;
  final double maxCapacity;

  VehicleType({
    required this.id,
    required this.name,
    required this.icon,
    required this.capacityRange,
    required this.minCapacity,
    required this.maxCapacity,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) {
    return VehicleType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      capacityRange: json['capacityRange'] ?? '',
      minCapacity: (json['minCapacity'] ?? 0).toDouble(),
      maxCapacity: (json['maxCapacity'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'capacityRange': capacityRange,
      'minCapacity': minCapacity,
      'maxCapacity': maxCapacity,
    };
  }

  static List<VehicleType> getDefaultVehicles() {
    return [
      VehicleType(
        id: 'lcv',
        name: 'LCV',
        icon: '🚚',
        capacityRange: '1 - 8 Tonnes',
        minCapacity: 1,
        maxCapacity: 8,
      ),
      VehicleType(
        id: 'truck',
        name: 'Truck',
        icon: '🚛',
        capacityRange: '1 - 42 Tonnes',
        minCapacity: 1,
        maxCapacity: 42,
      ),
      VehicleType(
        id: 'hyva',
        name: 'Hyva',
        icon: '🚛',
        capacityRange: '1 - 35 Tonnes',
        minCapacity: 1,
        maxCapacity: 35,
      ),
      VehicleType(
        id: 'container',
        name: 'Container',
        icon: '🚛',
        capacityRange: '1 - 18 Tonnes',
        minCapacity: 1,
        maxCapacity: 18,
      ),
      VehicleType(
        id: 'trailer',
        name: 'Trailer',
        icon: '🚛',
        capacityRange: '1 - 100 Tonnes',
        minCapacity: 1,
        maxCapacity: 100,
      ),
    ];
  }
}