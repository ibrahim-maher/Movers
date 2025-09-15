// lib/modules/load/controllers/load_details_controller.dart

import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import '../models/load_model.dart';
import '../services/load_service.dart';

class LoadDetailsController extends GetxController {
  final LoadService _loadService = Get.find<LoadService>();

  final Rx<LoadModel?> load = Rx<LoadModel?>(null);
  final RxBool isLoading = false.obs;
  final RxList<LoadBid> bids = <LoadBid>[].obs;

  @override
  void onInit() {
    super.onInit();
    final LoadModel? initialLoad = Get.arguments as LoadModel?;
    if (initialLoad != null) {
      load.value = initialLoad;
      loadBids();
    }
  }

  Future<void> loadBids() async {
    if (load.value == null) return;

    try {
      isLoading.value = true;
      final loadBids = await _loadService.getLoadBids(load.value!.id);
      bids.value = loadBids;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load bids: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptBid(LoadBid bid) async {
    try {
      await _loadService.acceptBid(load.value!.id, bid.id);

      // Update local load status
      load.value = load.value?.copyWith(
        status: 'confirmed',
        assignedDriverId: bid.bidderId,
        assignedDriverName: bid.bidderName,
        finalPrice: bid.bidAmount,
      );

      Get.snackbar(
        'Success',
        'Bid accepted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      await loadBids(); // Refresh bids
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to accept bid: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> rejectBid(LoadBid bid) async {
    try {
      await _loadService.rejectBid(bid.id);

      Get.snackbar(
        'Success',
        'Bid rejected',
        snackPosition: SnackPosition.BOTTOM,
      );

      await loadBids(); // Refresh bids
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reject bid: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Shares load details via the device's share functionality
  Future<void> shareLoad(LoadModel load) async {
    try {
      final String shareText = _buildShareText(load);

      await Share.share(
        shareText,
        subject: 'Load Details - ${_formatLoadId(load.id)}',
      );
    } catch (e) {
      // Fallback to clipboard if share fails
      await _copyToClipboard(load);
    }
  }

  /// Copies load details to clipboard as fallback
  Future<void> _copyToClipboard(LoadModel load) async {
    try {
      final String shareText = _buildShareText(load);

      await Clipboard.setData(ClipboardData(text: shareText));

      Get.snackbar(
        'Copied',
        'Load details copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to share load details',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Builds the formatted text for sharing
  String _buildShareText(LoadModel load) {
    final StringBuffer buffer = StringBuffer();

    buffer.writeln('🚛 Load Details - #${_formatLoadId(load.id)}');
    buffer.writeln('');
    buffer.writeln('📋 ${_formatVehicleType(load.vehicleType)} - ${_formatMaterialName(load.materialName)}');
    buffer.writeln('💰 ${_formatCurrency(load.expectedPrice)}');
    buffer.writeln('');
    buffer.writeln('📍 Route:');
    buffer.writeln('🟢 Pickup: ${load.pickupLocation}');
    if (load.pickupAddress.isNotEmpty) {
      buffer.writeln('   ${load.pickupAddress}');
    }
    buffer.writeln('🔴 Drop: ${load.dropLocation}');
    if (load.dropAddress.isNotEmpty) {
      buffer.writeln('   ${load.dropAddress}');
    }
    buffer.writeln('');
    buffer.writeln('📊 Details:');
    buffer.writeln('⚖️ Weight: ${load.weight.toStringAsFixed(1)} T');
    buffer.writeln('📏 Distance: ${load.distance.toStringAsFixed(0)} km');
    buffer.writeln('📅 Created: ${_formatDate(load.createdAt)}');
    buffer.writeln('🎯 Status: ${_formatStatus(load.status)}');

    if (load.assignedDriverName != null) {
      buffer.writeln('');
      buffer.writeln('👤 Driver: ${load.assignedDriverName}');
      if (load.finalPrice != null) {
        buffer.writeln('💵 Final Price: ${_formatCurrency(load.finalPrice!)}');
      }
    }

    return buffer.toString();
  }

  // Helper methods for formatting (moved from page to controller for reuse)

  /// Formats load ID for display
  String _formatLoadId(String id) {
    return id.length > 8 ? id.substring(0, 8).toUpperCase() : id.toUpperCase();
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
    return '₹${amount.toStringAsFixed(0)}';
  }

  /// Formats date for display
  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
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
}