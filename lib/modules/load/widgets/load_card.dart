import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/load_model.dart';

class LoadCard extends StatelessWidget {
  final LoadModel load;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const LoadCard({
    super.key,
    required this.load,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(theme),
                const SizedBox(height: 16),
                _buildRoute(theme),
                const SizedBox(height: 16),
                _buildFooter(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Hero(
          tag: 'vehicle_${load.id}',
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getVehicleColor(load.vehicleType).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getVehicleColor(load.vehicleType).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              _getVehicleIcon(load.vehicleType),
              color: _getVehicleColor(load.vehicleType),
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      load.vehicleType.toUpperCase(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      load.materialName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatPrice(load.expectedPrice, load.priceType),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
            Text(
              load.priceType == 'fixed' ? 'tr_fixed'.tr : 'tr_per_tonne'.tr,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoute(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: colorScheme.outline.withOpacity(0.3),
            width: 1
        ),
      ),
      child: Row(
        children: [
          _buildLocationPoint(
            load.pickupLocation,
            'tr_pickup'.tr,
            colorScheme.secondary,
            Icons.location_on_rounded,
          ),
          Expanded(
            child: _buildRouteConnector(theme),
          ),
          _buildLocationPoint(
            load.dropLocation,
            'tr_drop'.tr,
            colorScheme.error,
            Icons.location_on_rounded,
            isEnd: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPoint(
      String location,
      String label,
      Color color,
      IconData icon, {
        bool isEnd = false,
      }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            location,
            style: Get.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Get.theme.colorScheme.onSurface,
            ),
            textAlign: isEnd ? TextAlign.end : TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: isEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (isEnd) ...[
                Text(
                  label,
                  style: Get.textTheme.labelMedium?.copyWith(
                    color: color,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              Icon(
                icon,
                color: color,
                size: 18,
              ),
              if (!isEnd) ...[
                const SizedBox(width: 4),
                Text(
                  label,
                  style: Get.textTheme.labelMedium?.copyWith(
                    color: color,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteConnector(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 2,
          height: 24,
          color: colorScheme.primary.withOpacity(0.5),
        ),
        Icon(
          Icons.local_shipping_rounded,
          color: colorScheme.primary,
          size: 20,
        ),
        Container(
          width: 2,
          height: 24,
          color: colorScheme.primary.withOpacity(0.5),
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.schedule_rounded,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              '${'tr_created'.tr} ${_formatDate(load.createdAt)}',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _getStatusColor(load.status),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              _getStatusText(load.status),
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: _getStatusColor(load.status),
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData _getVehicleIcon(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'lcv':
        return Icons.directions_car_rounded;
      case 'truck':
        return Icons.local_shipping_rounded;
      case 'hyva':
        return Icons.construction_rounded;
      case 'container':
        return Icons.view_in_ar_rounded;
      case 'trailer':
        return Icons.taxi_alert_rounded;
      default:
        return Icons.local_shipping_rounded;
    }
  }

  Color _getVehicleColor(String vehicleType) {
    final colorScheme = Get.theme.colorScheme;

    switch (vehicleType.toLowerCase()) {
      case 'lcv':
        return colorScheme.secondary;
      case 'truck':
        return colorScheme.secondary;
      case 'hyva':
        return colorScheme.error;
      case 'container':
        return colorScheme.tertiary;
      case 'trailer':
        return const Color(0xFF7B1FA2); // Purple
      default:
        return colorScheme.secondary;
    }
  }

  String _formatPrice(double price, String priceType) {
    return '\$${price.toInt()}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'tr_today'.tr;
    } else if (difference.inDays == 1) {
      return 'tr_yesterday'.tr;
    } else if (difference.inDays < 7) {
      return 'tr_days_ago'.trParams({'days': difference.inDays.toString()});
    } else {
      return '${date.day}/${date.month}/${date.year.toString().substring(2)}';
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'status_pending'.tr;
      case 'confirmed':
        return 'tr_confirmed'.tr;
      case 'in_progress':
        return 'status_in_progress'.tr;
      case 'completed':
        return 'status_completed'.tr;
      case 'cancelled':
        return 'tr_cancelled'.tr;
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    final colorScheme = Get.theme.colorScheme;

    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade600;
      case 'confirmed':
        return colorScheme.secondary;
      case 'in_progress':
        return colorScheme.tertiary;
      case 'completed':
        return colorScheme.secondary;
      case 'cancelled':
        return colorScheme.error;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }
}