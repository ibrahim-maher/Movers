// lib/modules/parcel/models/parcel_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ParcelModel {
  final String id;
  final String senderId;
  final String? receiverId;
  final String description;
  final String fromAddress;
  final String toAddress;
  final double fromLat;
  final double fromLng;
  final double toLat;
  final double toLng;
  final String size;
  final double weight;
  final String status;
  final double price;
  final DateTime pickupTime;
  final DateTime? deliveryTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? trackingNumber;
  final String? receiverName;
  final String? receiverPhone;
  final List<String>? images;
  final Map<String, dynamic>? additionalInfo;

  const ParcelModel({
    required this.id,
    required this.senderId,
    this.receiverId,
    required this.description,
    required this.fromAddress,
    required this.toAddress,
    required this.fromLat,
    required this.fromLng,
    required this.toLat,
    required this.toLng,
    required this.size,
    required this.weight,
    required this.status,
    required this.price,
    required this.pickupTime,
    this.deliveryTime,
    required this.createdAt,
    required this.updatedAt,
    this.trackingNumber,
    this.receiverName,
    this.receiverPhone,
    this.images,
    this.additionalInfo,
  });

  factory ParcelModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ParcelModel(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'],
      description: data['description'] ?? '',
      fromAddress: data['fromAddress'] ?? '',
      toAddress: data['toAddress'] ?? '',
      fromLat: (data['fromLat'] as num?)?.toDouble() ?? 0.0,
      fromLng: (data['fromLng'] as num?)?.toDouble() ?? 0.0,
      toLat: (data['toLat'] as num?)?.toDouble() ?? 0.0,
      toLng: (data['toLng'] as num?)?.toDouble() ?? 0.0,
      size: data['size'] ?? 'medium',
      weight: (data['weight'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] ?? 'pending',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      pickupTime: (data['pickupTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      deliveryTime: (data['deliveryTime'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      trackingNumber: data['trackingNumber'],
      receiverName: data['receiverName'],
      receiverPhone: data['receiverPhone'],
      images: data['images'] != null ? List<String>.from(data['images']) : null,
      additionalInfo: data['additionalInfo'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'description': description,
      'fromAddress': fromAddress,
      'toAddress': toAddress,
      'fromLat': fromLat,
      'fromLng': fromLng,
      'toLat': toLat,
      'toLng': toLng,
      'size': size,
      'weight': weight,
      'status': status,
      'price': price,
      'pickupTime': Timestamp.fromDate(pickupTime),
      'deliveryTime': deliveryTime != null ? Timestamp.fromDate(deliveryTime!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'trackingNumber': trackingNumber,
      'receiverName': receiverName,
      'receiverPhone': receiverPhone,
      'images': images,
      'additionalInfo': additionalInfo,
    };
  }
}