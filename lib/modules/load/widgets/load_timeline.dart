import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/load_tracking_model.dart';

class LoadTimeline extends StatelessWidget {
  final List<LoadTrackingModel> trackingHistory;
  final bool isLoading;

  const LoadTimeline({
    super.key,
    required this.trackingHistory,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (trackingHistory.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No tracking history available',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    // Sort tracking history by timestamp (newest first)
    final sortedHistory = List<LoadTrackingModel>.from(trackingHistory)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedHistory.length,
      itemBuilder: (context, index) {
        final tracking = sortedHistory[index];
        final isFirst = index == 0;
        final isLast = index == sortedHistory.length - 1;

        return TimelineItem(
          tracking: tracking,
          isFirst: isFirst,
          isLast: isLast,
        );
      },
    );
  }
}

class TimelineItem extends StatelessWidget {
  final LoadTrackingModel tracking;
  final bool isFirst;
  final bool isLast;

  const TimelineItem({
    super.key,
    required this.tracking,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTimelineColumn(context),
          Expanded(
            child: _buildContentColumn(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineColumn(BuildContext context) {
    return SizedBox(
      width: 60.0,
      child: Column(
        children: [
          Text(
            DateFormat('hh:mm a').format(tracking.timestamp),
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.0),
          Text(
            DateFormat('MMM dd').format(tracking.timestamp),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }

  Widget _buildContentColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildTimelineDot(context),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tracking.statusName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(tracking.statusId),
                        ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    tracking.location,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (tracking.notes != null && tracking.notes!.isNotEmpty) ...[  
                    const SizedBox(height: 8.0),
                    Text(
                      tracking.notes!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                  const SizedBox(height: 4.0),
                  Text(
                    'Updated by ${tracking.updatedBy}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Container(
              width: 2.0,
              height: 40.0,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
      ],
    );
  }

  Widget _buildTimelineDot(BuildContext context) {
    return Container(
      width: 24.0,
      height: 24.0,
      decoration: BoxDecoration(
        color: _getStatusColor(tracking.statusId),
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: 3.0,
        ),
      ),
    );
  }

  Color _getStatusColor(String statusId) {
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