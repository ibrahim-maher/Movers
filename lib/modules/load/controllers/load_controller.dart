// lib/modules/load/controllers/load_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/load_model.dart';
import '../services/load_service.dart';
import '../../../shared/services/firebase/firebase_service.dart';

class LoadController extends GetxController with GetTickerProviderStateMixin {
  final LoadService _loadService = Get.find<LoadService>();
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  // Observable properties
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString currentTab = 'MY CURRENT LOADS'.obs;
  final RxList<LoadModel> myCurrentLoads = <LoadModel>[].obs;
  final RxList<LoadModel> completedLoads = <LoadModel>[].obs;
  final RxString selectedFilter = 'all'.obs;

  // Tab controller
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(_handleTabChange);
    loadUserLoads();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void _handleTabChange() {
    if (tabController.index == 0) {
      currentTab.value = 'MY CURRENT LOADS';
    } else {
      currentTab.value = 'COMPLETED';
    }
  }

  // Load user's loads
  Future<void> loadUserLoads() async {
    try {
      isLoading.value = true;
      print('🔄 Loading user loads...');

      final userId = _firebaseService.currentUserId;
      if (userId == null) {
        print('❌ No user ID found');
        return;
      }

      print('👤 User ID: $userId');

      // Load all loads for the user first
      final allLoadsData = await _loadService.getUserLoads(userId);
      print('📦 Total loads found: ${allLoadsData.length}');

      // Filter current loads (pending, confirmed, in_progress)
      final currentLoads = allLoadsData.where((load) =>
      load.status == 'pending' ||
          load.status == 'confirmed' ||
          load.status == 'in_progress'
      ).toList();

      // Filter completed loads
      final completedLoadsData = allLoadsData.where((load) =>
      load.status == 'completed'
      ).toList();

      print('📋 Current loads: ${currentLoads.length}');
      print('✅ Completed loads: ${completedLoadsData.length}');

      // Print details of each load for debugging
      for (int i = 0; i < currentLoads.length; i++) {
        final load = currentLoads[i];
        print('📝 Load ${i + 1}:');
        print('   - ID: ${load.id}');
        print('   - Title: ${load.title}');
        print('   - Status: ${load.status}');
        print('   - Material: ${load.materialName}');
        print('   - Route: ${load.pickupLocation} → ${load.dropLocation}');
        print('   - Price: \${load.expectedPrice}');
      }

      // Update observable lists
      myCurrentLoads.value = currentLoads;
      completedLoads.value = completedLoadsData;

      print('🎯 Successfully updated load lists');
      print('   - myCurrentLoads.length: ${myCurrentLoads.length}');
      print('   - completedLoads.length: ${completedLoads.length}');

    } catch (e, stackTrace) {
      print('❌ Error loading loads: $e');
      print('📍 Stack trace: $stackTrace');

      Get.snackbar(
        'Error',
        'Failed to load loads: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
      print('🏁 Load loading process completed');
    }
  }

  // Refresh loads
  Future<void> refreshLoads() async {
    await loadUserLoads();
  }

  // Delete load
  Future<void> deleteLoad(LoadModel load) async {
    try {
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Delete Load'),
          content: const Text('Are you sure you want to delete this load?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await _loadService.deleteLoad(load.id);
        myCurrentLoads.removeWhere((l) => l.id == load.id);
        completedLoads.removeWhere((l) => l.id == load.id);

        Get.snackbar(
          'Success',
          'Load deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete load: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Navigate to load details
  void navigateToLoadDetails(LoadModel load) {
    Get.toNamed('/load-details', arguments: load);
  }

  // Navigate to create load
  void navigateToCreateLoad() {
    Get.toNamed('/create-load');
  }

  // Navigate to edit load
  void navigateToEditLoad(LoadModel load) {
    Get.toNamed('/edit-load', arguments: load);
  }

  // Update load status
  Future<void> updateLoadStatus(String loadId, String newStatus) async {
    try {
      await _loadService.updateLoad(loadId, {'status': newStatus});
      await loadUserLoads(); // Refresh the list

      Get.snackbar(
        'Success',
        'Load status updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update load status: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Filter loads
  void filterLoads(String filter) {
    selectedFilter.value = filter;
    // Apply filtering logic here if needed
  }

  // Search loads
  void searchLoads(String query) {
    // Implement search functionality
  }

  // Get current loads based on selected tab
  List<LoadModel> get currentLoads {
    if (currentTab.value == 'MY CURRENT LOADS') {
      return myCurrentLoads;
    } else {
      return completedLoads;
    }
  }

  // Get load status display text
  String getLoadStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  // Get load status color
  Color getLoadStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'in_progress':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Format date
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().substring(2)}';
    }
  }

  // Format price
  String formatPrice(double price, {String priceType = 'fixed'}) {
    if (priceType == 'fixed') {
      return '\${price.toInt()} /Fixed';
    } else {
      return '\${price.toInt()} /Tonne';
    }
  }

  // Get vehicle icon
  String getVehicleIcon(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'lcv':
        return '🚚';
      case 'truck':
        return '🚛';
      case 'hyva':
        return '🚛';
      case 'container':
        return '🚛';
      case 'trailer':
        return '🚛';
      default:
        return '🚚';
    }
  }
}