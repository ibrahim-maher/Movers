import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/load_list_controller.dart';
import '../widgets/load_card.dart';
import '../widgets/load_item.dart';

class LoadsListPage extends GetView<LoadListController> {
  const LoadsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshLoads,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildLoadsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.navigateToCreateLoad,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller.searchController,
        decoration: InputDecoration(
          hintText: 'Search loads...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Obx(() => controller.searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => controller.searchController.clear(),
                )
              : const SizedBox.shrink()),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
        ),
      ),
    );
  }

  Widget _buildLoadsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: ${controller.errorMessage.value}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: controller.refreshLoads,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.filteredLoads.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inbox, size: 64.0, color: Colors.grey),
              const SizedBox(height: 16.0),
              const Text(
                'No loads found',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 8.0),
              if (controller.searchQuery.isNotEmpty ||
                  controller.selectedCategoryId.isNotEmpty ||
                  controller.selectedStatusId.isNotEmpty)
                TextButton(
                  onPressed: controller.clearFilters,
                  child: const Text('Clear Filters'),
                ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshLoads,
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 80.0), // For FAB
          itemCount: controller.filteredLoads.length,
          itemBuilder: (context, index) {
            final load = controller.filteredLoads[index];
            return LoadItem(
              load: load,
              onTap: () => controller.navigateToLoadDetails(load.id),
            );
          },
        ),
      );
    });
  }

  void _showFilterBottomSheet() {
    Get.bottomSheet(
      Obx(() => Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Loads',
                      style: Get.textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: controller.clearFilters,
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Categories',
                  style: Get.textTheme.titleMedium,
                ),
                const SizedBox(height: 8.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.categories.map((category) {
                      final isSelected =
                          controller.selectedCategoryId.value == category.id;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(category.name),
                          selected: isSelected,
                          onSelected: (_) =>
                              controller.selectCategory(category.id),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Status',
                  style: Get.textTheme.titleMedium,
                ),
                const SizedBox(height: 8.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.statuses.map((status) {
                      final isSelected =
                          controller.selectedStatusId.value == status.id;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(status.name),
                          selected: isSelected,
                          onSelected: (_) =>
                              controller.selectStatus(status.id),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          )),
      isScrollControlled: true,
    );
  }
}