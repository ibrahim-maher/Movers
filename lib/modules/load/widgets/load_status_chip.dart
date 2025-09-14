import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/load_controller.dart';
import '../models/load_status_model.dart';

class LoadStatusChip extends StatelessWidget {
  final String statusId;
  final String statusName;
  final bool small;

  const LoadStatusChip({
    super.key,
    required this.statusId,
    required this.statusName,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    // Try to get the status color from the controller if available
    Color statusColor;
    try {
      final LoadController controller = Get.find<LoadController>();
      final LoadStatusModel? status = controller.getStatusById(statusId);
      statusColor = status?.color ?? _getDefaultColor(statusId);
    } catch (_) {
      // If controller not found, use default color
      statusColor = _getDefaultColor(statusId);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8.0 : 12.0,
        vertical: small ? 2.0 : 4.0,
      ),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Text(
        statusName,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
          fontSize: small ? 10.0 : 12.0,
        ),
      ),
    );
  }

  Color _getDefaultColor(String statusId) {
    switch (statusId) {
      case '1': // Pending
        return Colors.orange;
      case '2': // Accepted
        return Colors.blue;
      case '3': // In Transit
        return Colors.purple;
      case '4': // Delivered
        return Colors.green;
      case '5': // Cancelled
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}