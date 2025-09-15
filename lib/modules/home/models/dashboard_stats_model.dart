// lib/modules/home/models/dashboard_stats_model.dart

class DashboardStatsModel {
  final int totalLoads;
  final int completedRides;
  final int totalParcels;
  final int activeBids;
  final double totalEarnings;
  final double rating;
  final double completionRate;

  DashboardStatsModel({
    required this.totalLoads,
    required this.completedRides,
    required this.totalParcels,
    required this.activeBids,
    required this.totalEarnings,
    required this.rating,
    required this.completionRate,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalLoads: json['totalLoads'] ?? 0,
      completedRides: json['completedRides'] ?? 0,
      totalParcels: json['totalParcels'] ?? 0,
      activeBids: json['activeBids'] ?? 0,
      totalEarnings: (json['totalEarnings'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      completionRate: (json['completionRate'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalLoads': totalLoads,
      'completedRides': completedRides,
      'totalParcels': totalParcels,
      'activeBids': activeBids,
      'totalEarnings': totalEarnings,
      'rating': rating,
      'completionRate': completionRate,
    };
  }
}

// lib/modules/home/models/quick_action_model.dart

class QuickActionModel {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final String color;
  final String route;
  final bool isEnabled;

  QuickActionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
    this.isEnabled = true,
  });

  factory QuickActionModel.fromJson(Map<String, dynamic> json) {
    return QuickActionModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      icon: json['icon'],
      color: json['color'],
      route: json['route'],
      isEnabled: json['isEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'icon': icon,
      'color': color,
      'route': route,
      'isEnabled': isEnabled,
    };
  }
}
