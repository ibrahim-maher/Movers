class LoadCategoryModel {
  final String id;
  final String name;
  final String description;
  final String? icon;
  final bool isActive;

  LoadCategoryModel({
    required this.id,
    required this.name,
    required this.description,
    this.icon,
    required this.isActive,
  });

  factory LoadCategoryModel.fromJson(Map<String, dynamic> json) {
    return LoadCategoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'is_active': isActive,
    };
  }
}