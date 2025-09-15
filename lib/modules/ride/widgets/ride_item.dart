// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../models/ride_model.dart';
//
// class RideItem extends StatelessWidget {
//   final RideModel ride;
//   final VoidCallback onTap;
//   final bool isBooked;
//
//   const RideItem({
//     super.key,
//     required this.ride,
//     required this.onTap,
//     this.isBooked = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       onTap: onTap,
//       title: Row(
//         children: [
//           Expanded(
//             child: Text(
//               '${ride.departureLocation} → ${ride.destinationLocation}',
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           const SizedBox(width: 8.0),
//           Text(
//             '\$${ride.price.toStringAsFixed(2)}',
//             style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//           ),
//         ],
//       ),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 4.0),
//           Row(
//             children: [
//               Icon(
//                 Icons.calendar_today,
//                 size: 14.0,
//                 color: Theme.of(context).colorScheme.secondary,
//               ),
//               const SizedBox(width: 4.0),
//               Text(
//                 _formatDateTime(ride.departureDate),
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//               const SizedBox(width: 16.0),
//               Icon(
//                 Icons.event_seat,
//                 size: 14.0,
//                 color: Theme.of(context).colorScheme.secondary,
//               ),
//               const SizedBox(width: 4.0),
//               Text(
//                 '${ride.availableSeats} seats',
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//             ],
//           ),
//           const SizedBox(height: 4.0),
//           Row(
//             children: [
//               Icon(
//                 Icons.directions_car,
//                 size: 14.0,
//                 color: Theme.of(context).colorScheme.secondary,
//               ),
//               const SizedBox(width: 4.0),
//               Text(
//                 ride.vehicleName,
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//               const SizedBox(width: 16.0),
//               _buildStatusChip(context),
//               if (isBooked)
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.primaryContainer,
//                       borderRadius: BorderRadius.circular(4.0),
//                     ),
//                     child: Text(
//                       'Booked',
//                       style: TextStyle(
//                         fontSize: 10.0,
//                         color: Theme.of(context).colorScheme.onPrimaryContainer,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//       leading: CircleAvatar(
//         backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//         child: Icon(
//           Icons.directions_car,
//           color: Theme.of(context).colorScheme.onPrimaryContainer,
//         ),
//       ),
//       trailing: const Icon(Icons.chevron_right),
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
//       padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
//       decoration: BoxDecoration(
//         color: chipColor.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(4.0),
//       ),
//       child: Text(
//         ride.statusName,
//         style: TextStyle(
//           color: chipColor,
//           fontWeight: FontWeight.bold,
//           fontSize: 10.0,
//         ),
//       ),
//     );
//   }
//
//   String _formatDateTime(DateTime dateTime) {
//     return DateFormat('MMM dd, HH:mm').format(dateTime);
//   }
// }