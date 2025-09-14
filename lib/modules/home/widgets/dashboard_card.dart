import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/dashboard_stats_model.dart';

class DashboardCard extends StatelessWidget {
  final DashboardStatsModel stats;

  const DashboardCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard Stats'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(context, 'Total Loads', stats.totalLoads.toString(), Icons.local_shipping),
                _buildStatItem(context, 'Active Rides', stats.activeRides.toString(), Icons.directions_car),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(context, 'Pending Parcels', stats.pendingParcels.toString(), Icons.add_box),
                _buildStatItem(context, 'Completed Deliveries', stats.completedDeliveries.toString(), Icons.check_circle),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(context, 'Total Earnings', '\$${stats.totalEarnings.toStringAsFixed(2)}', Icons.attach_money),
                _buildStatItem(context, 'Monthly Earnings', '\$${stats.monthlyEarnings.toStringAsFixed(2)}', Icons.account_balance_wallet),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String title, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            title.tr,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}