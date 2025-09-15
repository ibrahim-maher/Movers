// lib/modules/home/widgets/quick_action_button.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/quick_action_model.dart';

class QuickActionButton extends StatelessWidget {
  final QuickActionModel action;
  final VoidCallback onTap;

  const QuickActionButton({
    super.key,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = action.isEnabled;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isEnabled
              ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              action.colorValue,
              action.colorValue.withOpacity(0.8),
            ],
          )
              : LinearGradient(
            colors: [
              Colors.grey.withOpacity(0.3),
              Colors.grey.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isEnabled ? [
            BoxShadow(
              color: action.colorValue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _buildIcon(),
                ),
                if (action.badge != null && action.badge! > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      action.badge!.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    action.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isEnabled ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    action.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isEnabled
                          ? Colors.white.withOpacity(0.9)
                          : Colors.grey.withOpacity(0.7),
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (action.icon.startsWith('assets/')) {
      // Asset image
      return Image.asset(
        action.icon,
        width: 24,
        height: 24,
        color: Colors.white,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.widgets,
          color: Colors.white,
          size: 24,
        ),
      );
    } else {
      // Try to parse as IconData or fallback to default icon
      IconData iconData;
      switch (action.icon.toLowerCase()) {
        case 'load':
        case 'package':
          iconData = Icons.inventory_2_outlined;
          break;
        case 'ride':
        case 'car':
          iconData = Icons.directions_car_outlined;
          break;
        case 'parcel':
        case 'box':
          iconData = Icons.local_shipping_outlined;
          break;
        case 'bid':
        case 'auction':
          iconData = Icons.gavel_outlined;
          break;
        case 'payment':
          iconData = Icons.payment_outlined;
          break;
        case 'profile':
          iconData = Icons.person_outline;
          break;
        case 'settings':
          iconData = Icons.settings_outlined;
          break;
        default:
          iconData = Icons.widgets_outlined;
      }

      return Icon(
        iconData,
        color: Colors.white,
        size: 24,
      );
    }
  }
}