import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../controllers/load_details_controller.dart';
import '../widgets/load_map_view.dart';
import '../widgets/load_status_chip.dart';
import '../widgets/load_timeline.dart';

class LoadDetailsPage extends GetView<LoadDetailsController> {
  const LoadDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: controller.navigateToEditLoad,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteConfirmation(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8.0),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
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
                  onPressed: controller.refreshData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.selectedLoad.value == null) {
          return const Center(child: Text('Load not found'));
        }

        final load = controller.selectedLoad.value!;

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, load),
                const SizedBox(height: 24.0),
                _buildLocationSection(context, load),
                const SizedBox(height: 24.0),
                _buildDetailsSection(context, load),
                const SizedBox(height: 24.0),
                _buildStatusUpdateSection(context),
                const SizedBox(height: 24.0),
                _buildTrackingSection(context),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: Obx(() {
        if (controller.selectedLoad.value == null) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton.extended(
          onPressed: controller.navigateToTrackingPage,
          icon: const Icon(Icons.location_on),
          label: const Text('Track Load'),
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic load) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                load.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            LoadStatusChip(
              statusId: load.statusId,
              statusName: load.statusName,
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Text(
          load.description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Icon(
              Icons.category_outlined,
              size: 16.0,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 8.0),
            Text(
              load.categoryName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
            const SizedBox(width: 16.0),
            Icon(
              Icons.person_outline,
              size: 16.0,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 8.0),
            Text(
              'Posted by ${load.userName}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16.0,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 8.0),
            Text(
              'Posted on ${DateFormat('MMM dd, yyyy').format(load.createdAt)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationSection(BuildContext context, dynamic load) {
    // Default map position (center of US)
    final initialPosition = const CameraPosition(
      target: LatLng(37.0902, -95.7129),
      zoom: 3.0,
    );

    // Create markers for pickup and delivery locations
    // In a real app, these would be geocoded from the addresses
    final markers = <Marker>{
      const Marker(
        markerId: MarkerId('pickup'),
        position: LatLng(40.7128, -74.0060), // New York (placeholder)
        infoWindow: InfoWindow(title: 'Pickup Location'),
      ),
      const Marker(
        markerId: MarkerId('delivery'),
        position: LatLng(34.0522, -118.2437), // Los Angeles (placeholder)
        infoWindow: InfoWindow(title: 'Delivery Location'),
      ),
    };

    // Create a polyline between pickup and delivery
    final polylines = <Polyline>{
      const Polyline(
        polylineId: PolylineId('route'),
        points: [
          LatLng(40.7128, -74.0060), // New York (placeholder)
          LatLng(34.0522, -118.2437), // Los Angeles (placeholder)
        ],
        color: Colors.blue,
        width: 5,
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Route',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16.0),
        LoadMapView(
          initialCameraPosition: initialPosition,
          markers: markers,
          polylines: polylines,
          onMapCreated: (controller) {},
          isInteractive: false,
          height: 200.0,
        ),
        const SizedBox(height: 16.0),
        _buildLocationCard(
          context,
          'Pickup Location',
          load.pickupLocation,
          Icons.location_on_outlined,
          DateFormat('MMM dd, yyyy').format(load.pickupDate),
        ),
        const SizedBox(height: 16.0),
        _buildLocationCard(
          context,
          'Delivery Location',
          load.deliveryLocation,
          Icons.location_on,
          DateFormat('MMM dd, yyyy').format(load.deliveryDate),
        ),
      ],
    );
  }

  Widget _buildLocationCard(
    BuildContext context,
    String title,
    String location,
    IconData icon,
    String date,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  location,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4.0),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context, dynamic load) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Load Details',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16.0),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            children: [
              _buildDetailRow(context, 'Weight', '${load.weight} kg'),
              const Divider(),
              _buildDetailRow(context, 'Dimensions', load.dimensions),
              const Divider(),
              _buildDetailRow(
                context,
                'Price',
                '\$${load.price.toStringAsFixed(2)}',
                isHighlighted: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: isHighlighted
                ? Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    )
                : Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusUpdateSection(BuildContext context) {
    return Obx(() {
      if (controller.statuses.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update Status',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Status: ${controller.selectedLoad.value?.statusName ?? ''}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Select New Status:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: controller.statuses.map((status) {
                    final isSelected = controller.selectedStatusId.value == status.id;
                    final isCurrentStatus =
                        controller.selectedLoad.value?.statusId == status.id;
                    
                    return ChoiceChip(
                      label: Text(status.name),
                      selected: isSelected,
                      onSelected: isCurrentStatus
                          ? null
                          : (_) => controller.selectedStatusId.value = status.id,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      selectedColor: Theme.of(context).colorScheme.primaryContainer,
                      disabledColor: isCurrentStatus
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : null,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.selectedStatusId.value !=
                                controller.selectedLoad.value?.statusId &&
                            !controller.isSubmitting.value
                        ? () => _updateStatus(controller.selectedStatusId.value)
                        : null,
                    child: controller.isSubmitting.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2.0),
                          )
                        : const Text('Update Status'),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTrackingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tracking History',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16.0),
        Obx(() => LoadTimeline(
              trackingHistory: controller.trackingHistory,
              isLoading: controller.isLoadingTracking.value,
            )),
      ],
    );
  }

  void _updateStatus(String statusId) async {
    final success = await controller.updateLoadStatus(statusId);
    if (success) {
      Get.snackbar(
        'Success',
        'Load status updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        controller.errorMessage.value.isNotEmpty
            ? controller.errorMessage.value
            : 'Failed to update load status',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Load'),
        content: const Text(
          'Are you sure you want to delete this load? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              final success = await controller.deleteLoad();
              if (!success) {
                Get.snackbar(
                  'Error',
                  controller.errorMessage.value.isNotEmpty
                      ? controller.errorMessage.value
                      : 'Failed to delete load',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}