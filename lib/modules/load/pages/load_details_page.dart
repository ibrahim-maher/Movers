// lib/modules/load/pages/load_details_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/load_model.dart';
import '../controllers/load_details_controller.dart';

/// A professional load details page that displays comprehensive information
/// about a specific load including route, pricing, and bidder information.
class LoadDetailsPage extends GetView<LoadDetailsController> {
  const LoadDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoadModel load = Get.arguments as LoadModel;

    if (load.id.isEmpty) {
      return _buildErrorScaffold('Invalid load data');
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(load),
      body: _buildBody(load),
    );
  }

  /// Builds the app bar with load ID and navigation
  PreferredSizeWidget _buildAppBar(LoadModel load) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF1A1A1A),
      title: Text(
        'Load #${_formatLoadId(load.id)}',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          letterSpacing: -0.5,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 20),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, size: 20),
          onPressed: () => controller.shareLoad(load),
        ),
      ],
    );
  }

  /// Builds the main body content
  Widget _buildBody(LoadModel load) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildHeaderCard(load),
          const SizedBox(height: 16),
          _buildRouteCard(load),
          const SizedBox(height: 16),
          _buildLoadDetailsCard(load),
          const SizedBox(height: 16),
          _buildStatusCard(load),
          if (load.assignedDriverId != null) ...[
            const SizedBox(height: 16),
            _buildBidderInformationCard(load),
          ],
          if (_shouldShowPaymentInfo(load)) ...[
            const SizedBox(height: 16),
            _buildPaymentInformationCard(load),
          ],
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  /// Builds the main header card with vehicle and pricing information
  Widget _buildHeaderCard(LoadModel load) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: _getCardDecoration(),
      child: Row(
        children: [
          _buildVehicleIcon(load.vehicleType),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatVehicleType(load.vehicleType),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatMaterialName(load.materialName),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          _buildPriceInfo(load),
        ],
      ),
    );
  }

  /// Builds the vehicle icon container
  Widget _buildVehicleIcon(String vehicleType) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          _getVehicleIcon(vehicleType),
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }

  /// Builds the price information section
  Widget _buildPriceInfo(LoadModel load) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _formatCurrency(load.expectedPrice),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: load.priceType == 'fixed'
                ? const Color(0xFFDCFCE7)
                : const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            load.priceType == 'fixed' ? 'Fixed Price' : 'Per Tonne',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: load.priceType == 'fixed'
                  ? const Color(0xFF166534)
                  : const Color(0xFF92400E),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the route information card
  Widget _buildRouteCard(LoadModel load) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: _getCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Route Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          _buildRoutePoint(
            isPickup: true,
            location: load.pickupLocation,
            address: load.pickupAddress,
            contactName: load.pickupContactName,
            contactPhone: load.pickupContactPhone,
          ),
          const SizedBox(height: 16),
          _buildRouteDivider(),
          const SizedBox(height: 16),
          _buildRoutePoint(
            isPickup: false,
            location: load.dropLocation,
            address: load.dropAddress,
            contactName: load.dropContactName,
            contactPhone: load.dropContactPhone,
          ),
        ],
      ),
    );
  }

  /// Builds individual route point (pickup or drop)
  Widget _buildRoutePoint({
    required bool isPickup,
    required String location,
    required String address,
    required String contactName,
    required String contactPhone,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: isPickup ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isPickup ? Icons.upload_outlined : Icons.download_outlined,
                    size: 16,
                    color: const Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isPickup ? 'Pickup' : 'Drop',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              if (address.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  address,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
              if (contactName.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 14,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      contactName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    if (contactPhone.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.phone_outlined,
                        size: 14,
                        color: Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        contactPhone,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the route divider with distance information
  Widget _buildRouteDivider() {
    return Row(
      children: [
        const SizedBox(width: 6),
        Container(
          width: 1,
          height: 24,
          color: const Color(0xFFE5E7EB),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFFE5E7EB),
          ),
        ),
      ],
    );
  }

  /// Builds the load details card with weight, material, and date information
  Widget _buildLoadDetailsCard(LoadModel load) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: _getCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Load Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Date Created',
                  value: _formatDate(load.createdAt),
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  icon: Icons.scale_outlined,
                  label: 'Weight',
                  value: '${load.weight.toStringAsFixed(1)} T',
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  icon: Icons.route_outlined,
                  label: 'Distance',
                  value: '${load.distance.toStringAsFixed(0)} km',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds individual detail item
  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF6B7280),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Builds the status card showing current load process
  Widget _buildStatusCard(LoadModel load) {
    final statusInfo = _getStatusInfo(load.status);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: _getCardDecoration(),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusInfo['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              statusInfo['icon'],
              color: statusInfo['color'],
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Load Status',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusInfo['message'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusInfo['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _formatStatus(load.status),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: statusInfo['color'],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the bidder information card when a driver is assigned
  Widget _buildBidderInformationCard(LoadModel load) {
    if (load.assignedDriverId == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Assigned Driver',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _getCardDecoration(),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFF3B82F6).withOpacity(0.1),
                  child: Text(
                    _getDriverInitials(load.assignedDriverName),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        load.assignedDriverName ?? 'Driver',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Final Price: ${_formatCurrency(load.finalPrice ?? load.expectedPrice)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber.shade400,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '4.8',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Verified',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the payment information card for completed loads
  Widget _buildPaymentInformationCard(LoadModel load) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Payment Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _getCardDecoration(),
            child: Column(
              children: [
                _buildPaymentRow(
                  'Payment Gateway',
                  'Razorpay',
                  isTitle: true,
                ),
                const SizedBox(height: 12),
                _buildPaymentRow(
                  'Transaction ID',
                  load.trackingId ?? 'N/A',
                ),
                const SizedBox(height: 12),
                _buildPaymentRow(
                  'Payment Status',
                  _formatPaymentStatus(load.paymentStatus ?? 'pending'),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 1,
                  color: const Color(0xFFE5E7EB),
                ),
                const SizedBox(height: 16),
                _buildPaymentRow(
                  'Total Amount',
                  _formatCurrency(load.finalPrice ?? load.expectedPrice),
                  isTotal: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds individual payment information row
  Widget _buildPaymentRow(String label, String value, {bool isTitle = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: const Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? const Color(0xFF1A1A1A) : const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  /// Builds error scaffold for invalid data
  Widget _buildErrorScaffold(String message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Color(0xFFEF4444),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods

  /// Gets the standard card decoration
  BoxDecoration _getCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Formats load ID for display
  String _formatLoadId(String id) {
    return id.length > 8 ? id.substring(0, 8).toUpperCase() : id.toUpperCase();
  }

  /// Gets vehicle icon emoji based on type
  String _getVehicleIcon(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'lcv':
        return '🚚';
      case 'truck':
      case 'hyva':
      case 'container':
      case 'trailer':
        return '🚛';
      default:
        return '🚚';
    }
  }

  /// Formats vehicle type for display
  String _formatVehicleType(String vehicleType) {
    return vehicleType.toUpperCase();
  }

  /// Formats material name for display
  String _formatMaterialName(String materialName) {
    if (materialName.isEmpty) return 'Material not specified';
    return materialName.split(' ').map((word) =>
    word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)).join(' ');
  }

  /// Formats currency amount
  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    return formatter.format(amount);
  }

  /// Formats date for display
  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Gets status information including color and message
  Map<String, dynamic> _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return {
          'color': const Color(0xFFF59E0B),
          'icon': Icons.hourglass_empty,
          'message': 'Waiting for bids from transporters',
        };
      case 'confirmed':
        return {
          'color': const Color(0xFF3B82F6),
          'icon': Icons.local_shipping,
          'message': 'Driver is on the way to pickup location',
        };
      case 'in_progress':
        return {
          'color': const Color(0xFF8B5CF6),
          'icon': Icons.route,
          'message': 'Load is being transported',
        };
      case 'completed':
        return {
          'color': const Color(0xFF10B981),
          'icon': Icons.check_circle,
          'message': 'Load delivered successfully',
        };
      case 'cancelled':
        return {
          'color': const Color(0xFFEF4444),
          'icon': Icons.cancel,
          'message': 'Load has been cancelled',
        };
      default:
        return {
          'color': const Color(0xFF6B7280),
          'icon': Icons.help,
          'message': 'Status unknown',
        };
    }
  }

  /// Formats status for display
  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'in_progress':
        return 'In Progress';
      default:
        return status.split('_').map((word) =>
        word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)).join(' ');
    }
  }

  /// Gets driver initials from name
  String _getDriverInitials(String? name) {
    if (name == null || name.isEmpty) return 'D';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  /// Formats payment status for display
  String _formatPaymentStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Paid';
      case 'pending':
        return 'Pending';
      case 'failed':
        return 'Failed';
      default:
        return 'Unknown';
    }
  }

  /// Determines if payment information should be shown
  bool _shouldShowPaymentInfo(LoadModel load) {
    return load.status == 'completed' ||
        load.status == 'confirmed' ||
        (load.paymentStatus != null && load.paymentStatus!.isNotEmpty);
  }
}