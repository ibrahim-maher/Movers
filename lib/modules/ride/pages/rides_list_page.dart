// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// import '../../../shared/widgets/common/app_bar/custom_app_bar.dart';
// import '../../../shared/widgets/common/buttons/primary_button.dart';
// import '../../../shared/widgets/common/buttons/text_button.dart';
// import '../../../shared/widgets/common/form_fields/text_input_field.dart';
// import '../../../shared/widgets/common/loading/loading_indicator.dart';
// import '../../../shared/widgets/common/loading/refresh_indicator.dart';
// import '../../../shared/widgets/layouts/main_layout.dart';
// import '../controllers/ride_list_controller.dart';
// import '../widgets/ride_item.dart';
//
// class RidesListPage extends GetView<RideListController> {
//   const RidesListPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MainLayout(
//       title: 'Available Rides',
//       showAppBar: true,
//       padding: EdgeInsets.zero,
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.filter_list),
//           onPressed: _showFilterBottomSheet,
//         ),
//         IconButton(
//           icon: const Icon(Icons.refresh),
//           onPressed: controller.refreshRides,
//         ),
//       ],
//       body: Column(
//         children: [
//           _buildSearchBar(),
//           _buildActiveFilters(),
//           Expanded(
//             child: _buildRidesList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: TextInputField(
//         controller: controller.searchController,
//         hintText: 'Search rides...',
//         prefixIcon: const Icon(Icons.search),
//         suffixIcon: Obx(() {
//           if (controller.searchQuery.isNotEmpty) {
//             return IconButton(
//               icon: const Icon(Icons.clear),
//               onPressed: () => controller.searchController.clear(),
//             );
//           }
//           return const SizedBox.shrink(); // Empty widget instead of null
//         }),
//
//       ),
//     );
//   }
//
//   Widget _buildActiveFilters() {
//     return Obx(() {
//       final hasFilters = controller.selectedDepartureLocation.isNotEmpty ||
//           controller.selectedDestinationLocation.isNotEmpty ||
//           controller.selectedDate.value != null;
//
//       if (!hasFilters) {
//         return const SizedBox.shrink();
//       }
//
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Active Filters:',
//                   style: Get.textTheme.bodyMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 AppTextButton(
//                   text: 'Clear All',
//                   onPressed: controller.clearFilters,
//                 ),
//               ],
//             ),
//             Wrap(
//               spacing: 8.0,
//               runSpacing: 8.0,
//               children: [
//                 if (controller.selectedDepartureLocation.isNotEmpty)
//                   _buildFilterChip(
//                     'From: ${controller.selectedDepartureLocation.value}',
//                     () => controller.selectedDepartureLocation.value = '',
//                   ),
//                 if (controller.selectedDestinationLocation.isNotEmpty)
//                   _buildFilterChip(
//                     'To: ${controller.selectedDestinationLocation.value}',
//                     () => controller.selectedDestinationLocation.value = '',
//                   ),
//                 if (controller.selectedDate.value != null)
//                   _buildFilterChip(
//                     'Date: ${DateFormat('MMM dd, yyyy').format(controller.selectedDate.value!)}',
//                     () => controller.selectedDate.value = null,
//                   ),
//               ],
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget _buildFilterChip(String label, VoidCallback onDelete) {
//     return Chip(
//       label: Text(label),
//       deleteIcon: const Icon(Icons.close, size: 16.0),
//       onDeleted: onDelete,
//     );
//   }
//
//   Widget _buildRidesList() {
//     return Obx(() {
//       if (controller.isLoading.value) {
//         return const Center(child: LoadingIndicator());
//       }
//
//       if (controller.errorMessage.isNotEmpty) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Error: ${controller.errorMessage.value}',
//                 style: const TextStyle(color: Colors.red),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 16.0),
//               PrimaryButton(
//                 text: 'Retry',
//                 onPressed: controller.refreshRides,
//               ),
//             ],
//           ),
//         );
//       }
//
//       if (controller.filteredRides.isEmpty) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.directions_car_outlined, size: 64.0, color: Colors.grey),
//               const SizedBox(height: 16.0),
//               const Text(
//                 'No rides found',
//                 style: TextStyle(fontSize: 18.0),
//               ),
//               const SizedBox(height: 8.0),
//               if (controller.searchQuery.isNotEmpty ||
//                   controller.selectedDepartureLocation.isNotEmpty ||
//                   controller.selectedDestinationLocation.isNotEmpty ||
//                   controller.selectedDate.value != null)
//                 AppTextButton(
//                   text: 'Clear Filters',
//                   onPressed: controller.clearFilters,
//                 ),
//             ],
//           ),
//         );
//       }
//
//       return CustomRefreshIndicator(
//         onRefresh: controller.refreshRides,
//         child: ListView.separated(
//           padding: const EdgeInsets.only(bottom: 16.0),
//           itemCount: controller.filteredRides.length,
//           separatorBuilder: (context, index) => const Divider(height: 1),
//           itemBuilder: (context, index) {
//             final ride = controller.filteredRides[index];
//             return RideItem(
//               ride: ride,
//               onTap: () => controller.navigateToRideDetails(ride.id),
//             );
//           },
//         ),
//       );
//     });
//   }
//
//   void _showFilterBottomSheet() {
//     Get.bottomSheet(
//       Obx(() => Container(
//             padding: const EdgeInsets.all(16.0),
//             decoration: BoxDecoration(
//               color: Get.theme.colorScheme.surface,
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(16.0),
//               ),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Filter Rides',
//                       style: Get.textTheme.titleLarge,
//                     ),
//                     AppTextButton(
//                       text: 'Clear All',
//                       onPressed: controller.clearFilters,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16.0),
//                 Text(
//                   'Departure Location',
//                   style: Get.textTheme.titleMedium,
//                 ),
//                 const SizedBox(height: 8.0),
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: controller.departureLocations.map((location) {
//                       final isSelected =
//                           controller.selectedDepartureLocation.value == location;
//                       return Padding(
//                         padding: const EdgeInsets.only(right: 8.0),
//                         child: FilterChip(
//                           label: Text(location),
//                           selected: isSelected,
//                           onSelected: (_) =>
//                               controller.selectDepartureLocation(location),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 Text(
//                   'Destination Location',
//                   style: Get.textTheme.titleMedium,
//                 ),
//                 const SizedBox(height: 8.0),
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: controller.destinationLocations.map((location) {
//                       final isSelected =
//                           controller.selectedDestinationLocation.value == location;
//                       return Padding(
//                         padding: const EdgeInsets.only(right: 8.0),
//                         child: FilterChip(
//                           label: Text(location),
//                           selected: isSelected,
//                           onSelected: (_) =>
//                               controller.selectDestinationLocation(location),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 Text(
//                   'Date',
//                   style: Get.textTheme.titleMedium,
//                 ),
//                 const SizedBox(height: 8.0),
//                 PrimaryButton(
//                   text: controller.selectedDate.value != null
//                       ? DateFormat('MMM dd, yyyy').format(controller.selectedDate.value!)
//                       : 'Select Date',
//                   icon: Icons.calendar_today,
//                   onPressed: () async {
//                     final DateTime? picked = await showDatePicker(
//                       context: Get.context!,
//                       initialDate: controller.selectedDate.value ?? DateTime.now(),
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime.now().add(const Duration(days: 90)),
//                     );
//                     if (picked != null) {
//                       controller.selectDate(picked);
//                     }
//                   },
//                 ),
//                 const SizedBox(height: 16.0),
//                 SizedBox(
//                   width: double.infinity,
//                   child: PrimaryButton(
//                     text: 'Apply Filters',
//                     onPressed: () => Get.back(),
//                   ),
//                 ),
//               ],
//             ),
//           )),
//       isScrollControlled: true,
//     );
//   }
// }