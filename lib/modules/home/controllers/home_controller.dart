import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/services/firebase/firebase_service.dart';
import '../../../shared/services/storage/local_storage_service.dart';
import '../../../routes/app_routes.dart';
import '../models/dashboard_stats_model.dart';
import '../models/quick_action_model.dart';
import '../services/dashboard_service.dart';

class HomeController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final LocalStorageService _storageService = Get.find<LocalStorageService>();
  final DashboardService _dashboardService = Get.find<DashboardService>();

  final RxInt currentIndex = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<DashboardStatsModel?> dashboardStats = Rx<DashboardStatsModel?>(null);
  final RxList<QuickActionModel> quickActions = <QuickActionModel>[].obs;
  final RxList<Map<String, dynamic>> recentActivities = <Map<String, dynamic>>[].obs;

  final List<NavigationItem> navigationItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'home'.tr,
      route: AppRoutes.HOME,
    ),
    NavigationItem(
      icon: Icons.local_shipping_outlined,
      activeIcon: Icons.local_shipping,
      label: 'loads'.tr,
      route: AppRoutes.LOADS_LIST,
    ),
    NavigationItem(
      icon: Icons.directions_car_outlined,
      activeIcon: Icons.directions_car,
      label: 'rides'.tr,
      route: AppRoutes.RIDES_LIST,
    ),
    NavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'profile'.tr,
      route: AppRoutes.PROFILE,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    print('🚀 HomeController initialized');
    _storageService.debugPrint();
    _initializeQuickActions();
    fetchDashboardData();
  }

  void _initializeQuickActions() {
    quickActions.assignAll([
      QuickActionModel(
        id: '1',
        title: 'create_load'.tr,
        subtitle: 'Post a new load for transport'.tr,
        icon: Icons.add_box,
        color: Get.theme.colorScheme.primary,
        route: AppRoutes.CREATE_LOAD,
      ),
      QuickActionModel(
        id: '2',
        title: 'find_rides'.tr,
        subtitle: 'Browse available rides'.tr,
        icon: Icons.search,
        color: Get.theme.colorScheme.secondary,
        route: AppRoutes.RIDES_LIST,
      ),
      QuickActionModel(
        id: '3',
        title: 'send_parcel'.tr,
        subtitle: 'Send a parcel quickly'.tr,
        icon: Icons.local_shipping,
        color: Get.theme.colorScheme.tertiary,
        route: AppRoutes.SEND_PARCEL,
      ),
      QuickActionModel(
        id: '4',
        title: 'track_shipment'.tr,
        subtitle: 'Track your shipments'.tr,
        icon: Icons.track_changes,
        color: Colors.orange,
        route: AppRoutes.LOAD_TRACKING,
      ),
    ]);
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final stats = await _dashboardService.getDashboardStats();
      final activities = await _dashboardService.getRecentActivity();

      dashboardStats.value = stats;
      recentActivities.assignAll(activities);

      await _firebaseService.logEvent(
        name: 'dashboard_viewed',
        parameters: {'user_id': _firebaseService.currentUserId},
      );
    } catch (e) {
      errorMessage.value = 'Failed to load dashboard data: $e'.tr;
      print('❌ Error fetching dashboard data: $e');
      Get.snackbar('Error'.tr, errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      await _firebaseService.logError(
        exception: e,
        reason: 'Failed to fetch dashboard data',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshDashboard() async {
    await fetchDashboardData();
  }

  void onNavigationTap(int index) {
    try {
      if (currentIndex.value != index) {
        currentIndex.value = index;
        final route = navigationItems[index].route;
        print('🧭 Navigating to: $route');
        if (route != AppRoutes.HOME) {
          Get.toNamed(route);
        }
      }
    } catch (e) {
      print('❌ Navigation error: $e');
      Get.snackbar('Error'.tr, 'Failed to navigate: $e'.tr, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void onQuickActionTap(QuickActionModel action) async {
    try {
      print('⚡ Quick action tapped: ${action.title}');
      await _firebaseService.logEvent(
        name: 'quick_action_tapped',
        parameters: {
          'action_id': action.id,
          'action_title': action.title,
        },
      );
      print('🧭 Navigating to: ${action.route}');
      Get.toNamed(action.route);
    } catch (e) {
      print('❌ Quick action navigation error: $e');
      Get.snackbar('Error'.tr, 'Failed to navigate: $e'.tr, snackPosition: SnackPosition.BOTTOM);
    }
  }

  String get userName {
    return _firebaseService.currentUser?.displayName ?? 'User';
  }

  String get userEmail {
    return _firebaseService.currentUser?.email ?? '';
  }

  String get userInitials {
    final name = userName;
    if (name.isEmpty) return 'U';
    final parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  bool get hasStats => dashboardStats.value != null;
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}