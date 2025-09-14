import 'package:flutter/material.dart';

class RideProgressTracker extends StatelessWidget {
  final String statusId;
  final String statusName;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final DateTime? currentTime;

  const RideProgressTracker({
    super.key,
    required this.statusId,
    required this.statusName,
    required this.departureTime,
    required this.arrivalTime,
    this.currentTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ride Progress',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16.0),
        _buildProgressIndicator(context),
        const SizedBox(height: 16.0),
        _buildStatusInfo(context),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    // Calculate progress percentage based on status and time
    double progressPercentage = _calculateProgressPercentage();

    return Container(
      height: 8.0,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        children: [
          Flexible(
            flex: (progressPercentage * 100).toInt(),
            child: Container(
              decoration: BoxDecoration(
                color: _getStatusColor(),
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
          Flexible(
            flex: ((1 - progressPercentage) * 100).toInt(),
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
            const SizedBox(height: 4.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.2),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                statusName,
                style: TextStyle(
                  color: _getStatusColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Estimated Arrival',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
            const SizedBox(height: 4.0),
            Text(
              _formatTime(arrivalTime),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  double _calculateProgressPercentage() {
    // If ride is cancelled, return 0
    if (statusId == '4') {
      return 0.0;
    }
    
    // If ride is completed, return 1
    if (statusId == '3') {
      return 1.0;
    }
    
    // If ride is scheduled (not started yet), return 0
    if (statusId == '1') {
      return 0.0;
    }
    
    // If ride is in progress, calculate based on time
    if (statusId == '2' && currentTime != null) {
      final totalDuration = arrivalTime.difference(departureTime).inMinutes;
      final elapsedDuration = currentTime!.difference(departureTime).inMinutes;
      
      if (totalDuration <= 0) return 0.0;
      
      double progress = elapsedDuration / totalDuration;
      return progress.clamp(0.0, 1.0);
    }
    
    // Default fallback
    return 0.0;
  }

  Color _getStatusColor() {
    switch (statusId) {
      case '1': // Scheduled
        return Colors.blue;
      case '2': // In Progress
        return Colors.orange;
      case '3': // Completed
        return Colors.green;
      case '4': // Cancelled
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}