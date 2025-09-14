import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RecentActivityWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activities;

  const RecentActivityWidget({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Get.theme.colorScheme.onSurface.withOpacity(0.1),
        ),
        itemBuilder: (context, index) {
          final activity = activities[index];
          final title = activity['title']?.toString() ?? 'Unknown';
          final description = activity['description']?.toString() ?? '';
          final timestamp = activity['timestamp'] != null
              ? DateTime.parse(activity['timestamp'])
              : DateTime.now();
          final icon = _getIcon(activity['icon']?.toString() ?? 'default');
          final color = Color(activity['color'] ?? 0xFF000000);

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            leading: Icon(icon, color: color),
            title: Text(
              title.tr,
              style: Get.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Get.theme.colorScheme.onSurface,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  DateFormat('MMM dd, yyyy').format(timestamp),
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: _getStatusColor(activity['type']?.toString() ?? ''),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                activity['type']?.toString().tr ?? 'Unknown'.tr,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'local_shipping':
        return Icons.local_shipping;
      case 'handshake':
        return Icons.handshake;
      case 'check_circle':
        return Icons.check_circle;
      case 'directions_car':
        return Icons.directions_car;
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor(String type) {
    switch (type) {
      case 'load_created':
      case 'ride_booked':
        return Colors.blue;
      case 'bid_accepted':
      case 'parcel_delivered':
        return Colors.green;
      default:
        return Get.theme.colorScheme.onSurface.withOpacity(0.5);
    }
  }
}