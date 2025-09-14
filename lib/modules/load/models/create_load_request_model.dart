class CreateLoadRequestModel {
  final String title;
  final String description;
  final String pickupLocation;
  final String deliveryLocation;
  final DateTime pickupDate;
  final DateTime deliveryDate;
  final double weight;
  final String dimensions;
  final String categoryId;
  final double price;

  CreateLoadRequestModel({
    required this.title,
    required this.description,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.pickupDate,
    required this.deliveryDate,
    required this.weight,
    required this.dimensions,
    required this.categoryId,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'pickup_location': pickupLocation,
      'delivery_location': deliveryLocation,
      'pickup_date': pickupDate.toIso8601String(),
      'delivery_date': deliveryDate.toIso8601String(),
      'weight': weight,
      'dimensions': dimensions,
      'category_id': categoryId,
      'price': price,
    };
  }
}