// lib/modules/home/widgets/dashboard_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Widget? icon;
  final Color? statusColor;
  final String? timestamp;

  const DashboardCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    this.trailing,
    this.onTap,
    this.icon,
    this.statusColor,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: icon,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (timestamp != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          timestamp!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(theme).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getStatusText(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _getStatusColor(theme),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(height: 8),
                      trailing!,
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(ThemeData theme) {
    if (statusColor != null) return statusColor!;

    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
      case 'active':
      case 'available':
        return Colors.blue;
      case 'in_progress':
      case 'in_transit':
        return Colors.purple;
      case 'completed':
      case 'delivered':
        return Colors.green;
      case 'cancelled':
      case 'failed':
        return Colors.red;
      default:
        return theme.colorScheme.primary;
    }
  }

  String _getStatusText() {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'pending'.tr;
      case 'confirmed':
        return 'confirmed'.tr;
      case 'active':
        return 'active'.tr;
      case 'available':
        return 'available'.tr;
      case 'in_progress':
        return 'in_progress'.tr;
      case 'in_transit':
        return 'in_transit'.tr;
      case 'completed':
        return 'completed'.tr;
      case 'delivered':
        return 'delivered'.tr;
      case 'cancelled':
        return 'cancelled'.tr;
      case 'failed':
        return 'failed'.tr;
      default:
        return status.tr;
    }
  }
}