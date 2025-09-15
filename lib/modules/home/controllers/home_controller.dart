// lib/modules/home/controllers/home_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../shared/services/firebase/firebase_service.dart';

// Local model classes to avoid import conflicts
class DashboardStatsModel {
  final int totalLoads;
  final int completedRides;
  final int totalParcels;
  final int activeBids;
  final double totalEarnings;
  final double rating;
  final double completionRate;

  DashboardStatsModel({
    required this.totalLoads,
    required this.completedRides,
    required this.totalParcels,
    required this.activeBids,
    required this.totalEarnings,
    required this.rating,
    required this.completionRate,
  });
}

class QuickActionModel {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final String color;
  final String route;
  final bool isEnabled;

  QuickActionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
    this.isEnabled = true,
  });
}

class SimpleLoadModel {
  final String id;
  final String title;
  final String fromLocation;
  final String toLocation;
  final String status;

  SimpleLoadModel({
    required this.id,
    required this.title,
    required this.fromLocation,
    required this.toLocation,
    required this.status,
  });
}

class SimpleRideModel {
  final String id;
  final String fromLocation;
  final String toLocation;
  final String status;

  SimpleRideModel({
    required this.id,
    required this.fromLocation,
    required this.toLocation,
    required this.status,
  });
}

class SimpleParcelModel {
  final String id;
  final String status;
  final String fromLocation;
  final String toLocation;

  SimpleParcelModel({
    required this.id,
    required this.status,
    required this.fromLocation,
    required this.toLocation,
  });
}

class SimpleNotificationModel {
  final String id;
  final String title;
  final String message;
  final bool isRead;

  SimpleNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
  });
}

class HomeController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final RxInt currentCarouselIndex = 0.obs; // Add this for carousel

  // Observable properties
  final RxBool isLoading = true.obs;
  final RxBool isRefreshing = false.obs;
  final Rx<DashboardStatsModel?> dashboardStats = Rx<DashboardStatsModel?>(null);
  final RxList<QuickActionModel> quickActions = <QuickActionModel>[].obs;
  final RxList<SimpleLoadModel> recentLoads = <SimpleLoadModel>[].obs;
  final RxList<SimpleRideModel> availableRides = <SimpleRideModel>[].obs;
  final RxList<SimpleParcelModel> recentParcels = <SimpleParcelModel>[].obs;
  final RxList<SimpleNotificationModel> recentNotifications = <SimpleNotificationModel>[].obs;
  final RxString selectedTab = 'overview'.obs;
  final RxString greeting = ''.obs;

  // Operating routes data
  final RxList<Map<String, dynamic>> operatingRoutes = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeQuickActions();
    _initializeOperatingRoutes();
    _updateGreeting();
    loadDashboardData();
  }

  // Initialize quick actions
  void _initializeQuickActions() {
    quickActions.value = [
      QuickActionModel(
        id: '1',
        title: 'post_loads'.tr,
        subtitle: 'create_new_load'.tr,
        icon: 'load',
        color: '#FF6B35',
        route: '/create-load',
        isEnabled: true,
      ),
      QuickActionModel(
        id: '2',
        title: 'find_lorry'.tr,
        subtitle: 'search_available_rides'.tr,
        icon: 'ride',
        color: '#4ECDC4',
        route: '/rides',
        isEnabled: true,
      ),
      QuickActionModel(
        id: '3',
        title: 'send_parcel'.tr,
        subtitle: 'quick_parcel_delivery'.tr,
        icon: 'parcel',
        color: '#45B7D1',
        route: '/send-parcel',
        isEnabled: true,
      ),
      QuickActionModel(
        id: '4',
        title: 'place_bid'.tr,
        subtitle: 'bid_on_loads'.tr,
        icon: 'bid',
        color: '#F7B801',
        route: '/bids',
        isEnabled: true,
      ),
    ];
  }
  void setupPageController(PageController pageController) {
    pageController.addListener(() {
      currentCarouselIndex.value = pageController.page?.round() ?? 0;
    });
  }
  // Initialize operating routes data
  void _initializeOperatingRoutes() {
    operatingRoutes.value = [
      {
        'state': 'gujarat'.tr,
        'loads': '1k_load'.tr,
        'lorries': '7_lorry'.tr,
        'color': Colors.blue.shade100,
      },
      {
        'state': 'maharashtra'.tr,
        'loads': '6_load'.tr,
        'lorries': '4_lorry'.tr,
        'color': Colors.blue.shade200,
      },
      {
        'state': 'andhra_pradesh'.tr,
        'loads': '9_load'.tr,
        'lorries': '5_lorry'.tr,
        'color': Colors.blue.shade300,
      },
    ];
  }

  // Update greeting based on time
  void _updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting.value = 'good_morning'.tr;
    } else if (hour < 17) {
      greeting.value = 'good_afternoon'.tr;
    } else {
      greeting.value = 'good_evening'.tr;
    }
  }

  // Load all dashboard data
  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;

      await Future.wait([
        _loadDashboardStats(),
        _loadRecentLoads(),
        _loadAvailableRides(),
        _loadRecentParcels(),
        _loadRecentNotifications(),
      ]);

    } catch (e) {
      print('Error loading dashboard data: $e');
      Get.snackbar(
        'error'.tr,
        'failed_to_load_data'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh all data
  Future<void> refreshData() async {
    try {
      isRefreshing.value = true;
      _updateGreeting();
      await loadDashboardData();
    } finally {
      isRefreshing.value = false;
    }
  }

  // Load dashboard statistics
  Future<void> _loadDashboardStats() async {
    try {
      final userId = _firebaseService.currentUserId;
      if (userId == null) return;

      // Mock data for now - replace with actual Firebase queries
      dashboardStats.value = DashboardStatsModel(
        totalLoads: 25,
        completedRides: 18,
        totalParcels: 12,
        activeBids: 5,
        totalEarnings: 45000.0,
        rating: 4.5,
        completionRate: 95.0,
      );
    } catch (e) {
      print('Error loading dashboard stats: $e');
    }
  }

  // Load recent loads
  Future<void> _loadRecentLoads() async {
    try {
      // Mock data for now - replace with actual Firebase queries
      recentLoads.value = [];
    } catch (e) {
      print('Error loading recent loads: $e');
    }
  }

  // Load available rides
  Future<void> _loadAvailableRides() async {
    try {
      // Mock data for now - replace with actual Firebase queries
      availableRides.value = [];
    } catch (e) {
      print('Error loading available rides: $e');
    }
  }

  // Load recent parcels
  Future<void> _loadRecentParcels() async {
    try {
      // Mock data for now - replace with actual Firebase queries
      recentParcels.value = [];
    } catch (e) {
      print('Error loading recent parcels: $e');
    }
  }

  // Load recent notifications
  Future<void> _loadRecentNotifications() async {
    try {
      // Mock data for now - replace with actual Firebase queries
      recentNotifications.value = [];
    } catch (e) {
      print('Error loading recent notifications: $e');
    }
  }

  // Handle quick action tap
  void onQuickActionTap(QuickActionModel action) {
    if (!action.isEnabled) {
      Get.snackbar(
        'unavailable'.tr,
        'feature_coming_soon'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Track analytics
    _firebaseService.logEvent(
      name: 'quick_action_tapped',
      parameters: {
        'action_id': action.id,
        'action_title': action.title,
        'route': action.route,
      },
    );

    Get.toNamed(action.route);
  }

  // Handle tab change
  void onTabChanged(String tab) {
    selectedTab.value = tab;

    // Track analytics
    _firebaseService.logEvent(
      name: 'home_tab_changed',
      parameters: {
        'tab': tab,
      },
    );
  }

  // Navigation methods
  void navigateToLoads() => Get.toNamed('/loads');
  void navigateToRides() => Get.toNamed('/rides');
  void navigateToParcels() => Get.toNamed('/parcels');
  void navigateToNotifications() => Get.toNamed('/notifications');
  void navigateToProfile() => Get.toNamed('/profile');

  // Getters
  String get userDisplayName {
    final user = _firebaseService.currentUser;
    return user?.displayName ?? 'Ibrahim'; // Using the actual user name from logs
  }

  String get userEmail {
    final user = _firebaseService.currentUser;
    return user?.email ?? '';
  }

  bool get hasUnreadNotifications {
    return recentNotifications.any((notification) => !notification.isRead);
  }

  int get unreadNotificationsCount {
    return recentNotifications.where((notification) => !notification.isRead).length;
  }

  // Get operating routes data
  List<Map<String, dynamic>> getOperatingRoutes() {
    return operatingRoutes.value;
  }
}