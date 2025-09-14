class RideBookingModel {
  final String id;
  final String rideId;
  final String userId;
  final String userName;
  final int seats;
  final double totalPrice;
  final String statusId;
  final String statusName;
  final DateTime bookingDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  RideBookingModel({
    required this.id,
    required this.rideId,
    required this.userId,
    required this.userName,
    required this.seats,
    required this.totalPrice,
    required this.statusId,
    required this.statusName,
    required this.bookingDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RideBookingModel.fromJson(Map<String, dynamic> json) {
    return RideBookingModel(
      id: json['id'],
      rideId: json['ride_id'],
      userId: json['user_id'],
      userName: json['user_name'],
      seats: json['seats'],
      totalPrice: json['total_price'].toDouble(),
      statusId: json['status_id'],
      statusName: json['status_name'],
      bookingDate: DateTime.parse(json['booking_date']),
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ride_id': rideId,
      'user_id': userId,
      'user_name': userName,
      'seats': seats,
      'total_price': totalPrice,
      'status_id': statusId,
      'status_name': statusName,
      'booking_date': bookingDate.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}