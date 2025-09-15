// lib/modules/home/widgets/operating_routes_section.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class OperatingRoutesSection extends StatelessWidget {
  final HomeController controller;

  const OperatingRoutesSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'operating_routes'.tr,
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildRouteCard('Gujarat', '1k Load', '7 Lorry', Colors.blue.shade100, Icons.location_on)),
              const SizedBox(width: 12),
              Expanded(child: _buildRouteCard('Maharashtra', '6 Load', '4 Lorry', Colors.blue.shade200, Icons.location_on)),
              const SizedBox(width: 12),
              Expanded(child: _buildRouteCard('Andhra Pradesh', '9 Load', '5 Lorry', Colors.blue.shade300, Icons.location_on)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard(String state, String loads, String lorries, Color color, IconData icon) {
    return GestureDetector(
      onTap: () {
        // Navigate to route details
        Get.toNamed('/route-details', arguments: {'state': state});
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: color.withOpacity(0.8),
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              state,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              loads,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            Text(
              lorries,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}