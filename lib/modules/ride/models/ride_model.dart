class RideModel {
  final String id;
  final String title;
  final String description;
  final String departureLocation;
  final String destinationLocation;
  final DateTime departureDate;
  final DateTime arrivalDate;
  final int availableSeats;
  final double price;
  final String vehicleId;
  final String vehicleName;
  final String vehicleType;
  final String driverId;
  final String driverName;
  final String statusId;
  final String statusName;
  final DateTime createdAt;
  final DateTime updatedAt;

  RideModel({
    required this.id,
    required this.title,
    required this.description,
    required this.departureLocation,
    required this.destinationLocation,
    required this.departureDate,
    required this.arrivalDate,
    required this.availableSeats,
    required this.price,
    required this.vehicleId,
    required this.vehicleName,
    required this.vehicleType,
    required this.driverId,
    required this.driverName,
    required this.statusId,
    required this.statusName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      departureLocation: json['departure_location'],
      destinationLocation: json['destination_location'],
      departureDate: DateTime.parse(json['departure_date']),
      arrivalDate: DateTime.parse(json['arrival_date']),
      availableSeats: json['available_seats'],
      price: json['price'].toDouble(),
      vehicleId: json['vehicle_id'],
      vehicleName: json['vehicle_name'],
      vehicleType: json['vehicle_type'],
      driverId: json['driver_id'],
      driverName: json['driver_name'],
      statusId: json['status_id'],
      statusName: json['status_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'departure_location': departureLocation,
      'destination_location': destinationLocation,
      'departure_date': departureDate.toIso8601String(),
      'arrival_date': arrivalDate.toIso8601String(),
      'available_seats': availableSeats,
      'price': price,
      'vehicle_id': vehicleId,
      'vehicle_name': vehicleName,
      'vehicle_type': vehicleType,
      'driver_id': driverId,
      'driver_name': driverName,
      'status_id': statusId,
      'status_name': statusName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}