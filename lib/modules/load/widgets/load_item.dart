import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/load_model.dart';
import 'load_status_chip.dart';

class LoadItem extends StatelessWidget {
  final LoadModel load;
  final VoidCallback onTap;

  const LoadItem({
    super.key,
    required this.load,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      onTap: onTap,
      title: Row(
        children: [
          Expanded(
            child: Text(
              load.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8.0),
          Text(
            '\$${load.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4.0),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14.0,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 4.0),
              Expanded(
                child: Text(
                  '${load.pickupLocation} → ${load.deliveryLocation}',
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14.0,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 4.0),
              Text(
                _formatDate(load.pickupDate),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 8.0),
              LoadStatusChip(
                statusId: load.statusId,
                statusName: load.statusName,
                small: true,
              ),
            ],
          ),
        ],
      ),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          load.title.substring(0, 1).toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}