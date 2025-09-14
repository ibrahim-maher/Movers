import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/load_model.dart';
import 'load_status_chip.dart';

class LoadCard extends StatelessWidget {
  final LoadModel load;
  final VoidCallback onTap;

  const LoadCard({
    super.key,
    required this.load,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  LoadStatusChip(statusId: load.statusId, statusName: load.statusName),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                load.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16.0),
              _buildInfoRow(
                context,
                Icons.location_on_outlined,
                'From: ${load.pickupLocation}',
              ),
              const SizedBox(height: 4.0),
              _buildInfoRow(
                context,
                Icons.location_on,
                'To: ${load.deliveryLocation}',
              ),
              const SizedBox(height: 4.0),
              _buildInfoRow(
                context,
                Icons.calendar_today,
                'Pickup: ${_formatDate(load.pickupDate)}',
              ),
              const SizedBox(height: 4.0),
              _buildInfoRow(
                context,
                Icons.calendar_month,
                'Delivery: ${_formatDate(load.deliveryDate)}',
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    load.categoryName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Text(
                    '\$${load.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.0, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}