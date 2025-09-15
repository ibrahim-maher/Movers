// lib/modules/load/pages/loads_list_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/load_controller.dart';
import '../widgets/load_card.dart';

class LoadsListPage extends GetView<LoadController> {
  const LoadsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          'My Loads',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          _buildTabBar(theme),
          Expanded(
            child: Obx(() => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : _buildLoadsList(theme)),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      color: theme.primaryColor,
      child: TabBar(
        controller: controller.tabController,
        tabs: const [
          Tab(text: 'MY CURRENT LOADS'),
          Tab(text: 'COMPLETED'),
        ],
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildLoadsList(ThemeData theme) {
    return RefreshIndicator(
      onRefresh: controller.refreshLoads,
      color: theme.primaryColor,
      child: TabBarView(
        controller: controller.tabController,
        children: [
          _buildCurrentLoadsTab(theme),
          _buildCompletedLoadsTab(theme),
        ],
      ),
    );
  }

  Widget _buildCurrentLoadsTab(ThemeData theme) {
    return Obx(() {
      final loads = controller.myCurrentLoads;

      if (loads.isEmpty) {
        return _buildEmptyState(
          icon: Icons.inventory_2_outlined,
          title: 'No Current Loads',
          subtitle: 'Create your first load to get started',
          actionText: 'Create Load',
          onAction: controller.navigateToCreateLoad,
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: loads.length,
        itemBuilder: (context, index) {
          final load = loads[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: LoadCard(
              load: load,
              onTap: () => controller.navigateToLoadDetails(load),
              onEdit: () => controller.navigateToEditLoad(load),
              onDelete: () => controller.deleteLoad(load),
              showActions: true,
            ),
          );
        },
      );
    });
  }

  Widget _buildCompletedLoadsTab(ThemeData theme) {
    return Obx(() {
      final loads = controller.completedLoads;

      if (loads.isEmpty) {
        return _buildEmptyState(
          icon: Icons.check_circle_outline,
          title: 'No Completed Loads',
          subtitle: 'Your completed loads will appear here',
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: loads.length,
        itemBuilder: (context, index) {
          final load = loads[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: LoadCard(
              load: load,
              onTap: () => controller.navigateToLoadDetails(load),
              showActions: false,
            ),
          );
        },
      );
    });
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 60,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  actionText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}