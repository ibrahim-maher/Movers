import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/load_tracking_controller.dart';
import '../widgets/load_map_view.dart';
import '../widgets/load_timeline.dart';

class LoadTrackingPage extends GetView<LoadTrackingController> {
  const LoadTrackingPage({super.key});

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Track Load'),
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
                    onPressed: (){},
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

        if (controller.selectedLoad.value == null) {
          return const Center(child: Text('Load not found'));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMapSection(),
              _buildLoadInfoSection(context),
              _buildAddTrackingSection(context),
              _buildTrackingHistorySection(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMapSection() {
    return Obx(() => LoadMapView(
          initialCameraPosition: controller.initialCameraPosition.value,
          markers: controller.markers,
          polylines: controller.polylines,
          onMapCreated: controller.onMapCreated,
          onTap: controller.onMapTap,
          height: 300.0,
        ));
  }

  Widget _buildLoadInfoSection(BuildContext context) {
    final load = controller.selectedLoad.value!;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            load.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16.0,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  'From: ${load.pickupLocation}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16.0,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  'To: ${load.deliveryLocation}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  'Status: ${load.statusName}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddTrackingSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Tracking Update',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16.0),
            if (controller.errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12.0),
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            _buildStatusSelector(context),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: controller.locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                hintText: 'Enter current location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.location_on),
              ),
              validator: controller.validateLocation,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: controller.notesController,
              decoration: InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Enter any additional notes',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.note),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            Obx(() => Row(
                  children: [
                    Icon(
                      Icons.pin_drop,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      controller.latitude.value != 0 && controller.longitude.value != 0
                          ? 'Selected Location: ${controller.latitude.value.toStringAsFixed(6)}, ${controller.longitude.value.toStringAsFixed(6)}'
                          : 'Tap on the map to select a location',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                )),
            const SizedBox(height: 24.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : controller.addTrackingUpdate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: controller.isSubmitting.value
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Add Tracking Update',
                        style: TextStyle(fontSize: 16.0),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8.0),
        Obx(() => Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: controller.statuses.map((status) {
                final isSelected = controller.selectedStatusId.value == status.id;
                return ChoiceChip(
                  label: Text(status.name),
                  selected: isSelected,
                  onSelected: (_) => controller.selectedStatusId.value = status.id,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildTrackingHistorySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
      ),
    );
  }
}