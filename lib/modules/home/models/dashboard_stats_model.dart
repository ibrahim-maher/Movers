// lib/modules/home/models/dashboard_stats_model.dart
class DashboardStatsModel {
  final int totalLoads;
  final int activeRides;
  final int pendingParcels;
  final int completedDeliveries;
  final double totalEarnings;
  final double monthlyEarnings;
  final int totalBids;
  final int acceptedBids;

  DashboardStatsModel({
    required this.totalLoads,
    required this.activeRides,
    required this.pendingParcels,
    required this.completedDeliveries,
    required this.totalEarnings,
    required this.monthlyEarnings,
    required this.totalBids,
    required this.acceptedBids,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalLoads: json['total_loads'] ?? 0,
      activeRides: json['active_rides'] ?? 0,
      pendingParcels: json['pending_parcels'] ?? 0,
      completedDeliveries: json['completed_deliveries'] ?? 0,
      totalEarnings: (json['total_earnings'] ?? 0).toDouble(),
      monthlyEarnings: (json['monthly_earnings'] ?? 0).toDouble(),
      totalBids: json['total_bids'] ?? 0,
      acceptedBids: json['accepted_bids'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_loads': totalLoads,
      'active_rides': activeRides,
      'pending_parcels': pendingParcels,
      'completed_deliveries': completedDeliveries,
      'total_earnings': totalEarnings,
      'monthly_earnings': monthlyEarnings,
      'total_bids': totalBids,
      'accepted_bids': acceptedBids,
    };
  }
}



