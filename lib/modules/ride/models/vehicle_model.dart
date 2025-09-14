class VehicleModel {
  final String id;
  final String name;
  final String type;
  final String make;
  final String model;
  final String year;
  final String licensePlate;
  final String color;
  final int capacity;
  final String? imageUrl;
  final bool isActive;
  final String ownerId;
  final String ownerName;
  final DateTime createdAt;
  final DateTime updatedAt;

  VehicleModel({
    required this.id,
    required this.name,
    required this.type,
    required this.make,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.color,
    required this.capacity,
    this.imageUrl,
    required this.isActive,
    required this.ownerId,
    required this.ownerName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      licensePlate: json['license_plate'],
      color: json['color'],
      capacity: json['capacity'],
      imageUrl: json['image_url'],
      isActive: json['is_active'],
      ownerId: json['owner_id'],
      ownerName: json['owner_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'make': make,
      'model': model,
      'year': year,
      'license_plate': licensePlate,
      'color': color,
      'capacity': capacity,
      'image_url': imageUrl,
      'is_active': isActive,
      'owner_id': ownerId,
      'owner_name': ownerName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}