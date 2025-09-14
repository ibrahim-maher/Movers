class LoadModel {
  final String id;
  final String title;
  final String description;
  final String pickupLocation;
  final String deliveryLocation;
  final DateTime pickupDate;
  final DateTime deliveryDate;
  final double weight;
  final String dimensions;
  final String categoryId;
  final String categoryName;
  final String statusId;
  final String statusName;
  final double price;
  final String userId;
  final String userName;
  final DateTime createdAt;
  final DateTime updatedAt;

  LoadModel({
    required this.id,
    required this.title,
    required this.description,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.pickupDate,
    required this.deliveryDate,
    required this.weight,
    required this.dimensions,
    required this.categoryId,
    required this.categoryName,
    required this.statusId,
    required this.statusName,
    required this.price,
    required this.userId,
    required this.userName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LoadModel.fromJson(Map<String, dynamic> json) {
    return LoadModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      pickupLocation: json['pickup_location'],
      deliveryLocation: json['delivery_location'],
      pickupDate: DateTime.parse(json['pickup_date']),
      deliveryDate: DateTime.parse(json['delivery_date']),
      weight: json['weight'].toDouble(),
      dimensions: json['dimensions'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      statusId: json['status_id'],
      statusName: json['status_name'],
      price: json['price'].toDouble(),
      userId: json['user_id'],
      userName: json['user_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'pickup_location': pickupLocation,
      'delivery_location': deliveryLocation,
      'pickup_date': pickupDate.toIso8601String(),
      'delivery_date': deliveryDate.toIso8601String(),
      'weight': weight,
      'dimensions': dimensions,
      'category_id': categoryId,
      'category_name': categoryName,
      'status_id': statusId,
      'status_name': statusName,
      'price': price,
      'user_id': userId,
      'user_name': userName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}