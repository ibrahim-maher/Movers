// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../models/ride_model.dart';
//
// class RideCard extends StatelessWidget {
//   final RideModel ride;
//   final VoidCallback onTap;
//   final bool isBooked;
//
//   const RideCard({
//     super.key,
//     required this.ride,
//     required this.onTap,
//     this.isBooked = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       elevation: 2.0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12.0),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       ride.title,
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const SizedBox(width: 8.0),
//                   _buildStatusChip(context),
//                 ],
//               ),
//               const SizedBox(height: 8.0),
//               Text(
//                 ride.description,
//                 style: Theme.of(context).textTheme.bodyMedium,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 16.0),
//               _buildInfoRow(
//                 context,
//                 Icons.location_on_outlined,
//                 'From: ${ride.departureLocation}',
//               ),
//               const SizedBox(height: 4.0),
//               _buildInfoRow(
//                 context,
//                 Icons.location_on,
//                 'To: ${ride.destinationLocation}',
//               ),
//               const SizedBox(height: 4.0),
//               _buildInfoRow(
//                 context,
//                 Icons.calendar_today,
//                 'Departure: ${_formatDateTime(ride.departureDate)}',
//               ),
//               const SizedBox(height: 4.0),
//               _buildInfoRow(
//                 context,
//                 Icons.calendar_month,
//                 'Arrival: ${_formatDateTime(ride.arrivalDate)}',
//               ),
//               const SizedBox(height: 8.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.directions_car,
//                         size: 16.0,
//                         color: Theme.of(context).colorScheme.secondary,
//                       ),
//                       const SizedBox(width: 4.0),
//                       Text(
//                         '${ride.vehicleName} (${ride.vehicleType})',
//                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                               color: Theme.of(context).colorScheme.secondary,
//                             ),
//                       ),
//                     ],
//                   ),
//                   Text(
//                     '\$${ride.price.toStringAsFixed(2)}',
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: Theme.of(context).colorScheme.primary,
//                         ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.person,
//                         size: 16.0,
//                         color: Theme.of(context).colorScheme.secondary,
//                       ),
//                       const SizedBox(width: 4.0),
//                       Text(
//                         'Driver: ${ride.driverName}',
//                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                               color: Theme.of(context).colorScheme.secondary,
//                             ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.event_seat,
//                         size: 16.0,
//                         color: Theme.of(context).colorScheme.secondary,
//                       ),
//                       const SizedBox(width: 4.0),
//                       Text(
//                         '${ride.availableSeats} seats available',
//                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                               color: Theme.of(context).colorScheme.secondary,
//                             ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               if (isBooked)
//                 Container(
//                   margin: const EdgeInsets.only(top: 12.0),
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.primaryContainer,
//                     borderRadius: BorderRadius.circular(16.0),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.check_circle,
//                         size: 16.0,
//                         color: Theme.of(context).colorScheme.onPrimaryContainer,
//                       ),
//                       const SizedBox(width: 4.0),
//                       Text(
//                         'Booked',
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.onPrimaryContainer,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(icon, size: 16.0, color: Theme.of(context).colorScheme.secondary),
//         const SizedBox(width: 8.0),
//         Expanded(
//           child: Text(
//             text,
//             style: Theme.of(context).textTheme.bodyMedium,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatusChip(BuildContext context) {
//     Color chipColor;
//     switch (ride.statusId) {
//       case '1': // Scheduled
//         chipColor = Colors.blue;
//         break;
//       case '2': // In Progress
//         chipColor = Colors.orange;
//         break;
//       case '3': // Completed
//         chipColor = Colors.green;
//         break;
//       case '4': // Cancelled
//         chipColor = Colors.red;
//         break;
//       default:
//         chipColor = Colors.grey;
//     }
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//       decoration: BoxDecoration(
//         color: chipColor.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(16.0),
//       ),
//       child: Text(
//         ride.statusName,
//         style: TextStyle(
//           color: chipColor,
//           fontWeight: FontWeight.bold,
//           fontSize: 12.0,
//         ),
//       ),
//     );
//   }
//
//   String _formatDateTime(DateTime dateTime) {
//     return DateFormat('MMM dd, yyyy - HH:mm').format(dateTime);
//   }
// }