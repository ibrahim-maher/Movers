// lib/modules/home/widgets/stats_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/dashboard_stats_model.dart';
import '../../../shared/widgets/common/cards/stats_card.dart';

class StatsWidget extends StatelessWidget {
  final DashboardStatsModel? stats;

  const StatsWidget({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    if (stats == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatsCard(
                title: 'total_loads'.tr,
                value: stats!.totalLoads.toString(),
                icon: const Icon(Icons.local_shipping_outlined),
                iconColor: Colors.blue,
                iconBackgroundColor: Colors.blue.withOpacity(0.1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                title: 'completed_rides'.tr,
                value: stats!.completedRides.toString(),
                icon: const Icon(Icons.directions_car_outlined),
                iconColor: Colors.green,
                iconBackgroundColor: Colors.green.withOpacity(0.1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                title: 'total_parcels'.tr,
                value: stats!.totalParcels.toString(),
                icon: const Icon(Icons.inventory_2_outlined),
                iconColor: Colors.orange,
                iconBackgroundColor: Colors.orange.withOpacity(0.1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                title: 'active_bids'.tr,
                value: stats!.activeBids.toString(),
                icon: const Icon(Icons.gavel_outlined),
                iconColor: Colors.purple,
                iconBackgroundColor: Colors.purple.withOpacity(0.1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                title: 'total_earnings'.tr,
                value: '${stats!.totalEarnings.toStringAsFixed(0)} ${'sar'.tr}',
                subtitle: 'this_month'.tr,
                icon: const Icon(Icons.account_balance_wallet_outlined),
                iconColor: Colors.teal,
                iconBackgroundColor: Colors.teal.withOpacity(0.1),
                showTrend: true,
                trendValue: 12.5,
                trendUp: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                title: 'rating'.tr,
                value: stats!.rating.toStringAsFixed(1),
                subtitle: '${stats!.completionRate.toStringAsFixed(0)}% ${'completion_rate'.tr}',
                icon: const Icon(Icons.star_outline),
                iconColor: Colors.amber,
                iconBackgroundColor: Colors.amber.withOpacity(0.1),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < stats!.rating.floor()
                          ? Icons.star
                          : (index < stats!.rating
                          ? Icons.star_half
                          : Icons.star_border),
                      size: 12,
                      color: Colors.amber,
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}