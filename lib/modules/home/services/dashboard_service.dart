// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import '../../auth/services/token_service.dart';
// import '../models/dashboard_stats_model.dart';
//
// class DashboardService extends GetxService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final TokenService _tokenService = Get.find<TokenService>();
//
//   DashboardService() {
//     print('🚀 DashboardService initialized');
//   }
//
//   Future<DashboardStatsModel> getDashboardStats() async {
//     try {
//       print('📊 Fetching dashboard stats from Firestore...');
//       final userId = _tokenService.getToken();
//       if (userId == null) {
//         print('⚠️ No user ID available, returning mock stats');
//         return _getMockStats();
//       }
//
//       final snapshot = await _firestore
//           .collection('users')
//           .doc(userId)
//           .get();
//
//       if (!snapshot.exists || !snapshot.data()!.containsKey('stats')) {
//         print('⚠️ No dashboard stats found, returning mock stats');
//         return _getMockStats();
//       }
//
//       return DashboardStatsModel.fromJson(snapshot.data()!['stats']);
//     } catch (e) {
//       print('⚠️ Error fetching dashboard stats: $e');
//       print('📴 Returning mock stats due to error');
//       return _getMockStats();
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> getRecentActivity() async {
//     try {
//       print('🔔 Fetching recent activity from Firestore...');
//       final userId = _tokenService.getToken();
//       if (userId == null) {
//         print('⚠️ No user ID available, returning mock recent activity');
//         return _getMockRecentActivity();
//       }
//
//       final snapshot = await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('recentActivity')
//           .orderBy('timestamp', descending: true)
//           .limit(10)
//           .get();
//
//       if (snapshot.docs.isEmpty) {
//         print('⚠️ No recent activity found, returning mock data');
//         return _getMockRecentActivity();
//       }
//
//       return snapshot.docs.map((doc) => doc.data()).toList();
//     } catch (e) {
//       print('⚠️ Error fetching recent activity: $e');
//       print('📴 Returning mock recent activity due to error');
//       return _getMockRecentActivity();
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> getQuickActions() async {
//     try {
//       print('⚡ Fetching quick actions from Firestore...');
//       final userId = _tokenService.getToken();
//       if (userId == null) {
//         print('⚠️ No user ID available, returning empty quick actions');
//         return [];
//       }
//
//       final snapshot = await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('quickActions')
//           .get();
//
//       if (snapshot.docs.isEmpty) {
//         print('⚠️ No quick actions found, returning empty list');
//         return [];
//       }
//
//       return snapshot.docs.map((doc) => doc.data()).toList();
//     } catch (e) {
//       print('⚠️ Error fetching quick actions: $e');
//       return [];
//     }
//   }
//
//   DashboardStatsModel _getMockStats() {
//     print('📊 Generating mock dashboard stats');
//     return DashboardStatsModel(
//       totalLoads: 24,
//       activeRides: 3,
//       pendingParcels: 7,
//       completedDeliveries: 156,
//       totalEarnings: 12450.75,
//       monthlyEarnings: 3200.00,
//       totalBids: 18,
//       acceptedBids: 12,
//     );
//   }
//
//   List<Map<String, dynamic>> _getMockRecentActivity() {
//     print('🔔 Generating mock recent activity');
//     return [
//       {
//         'id': '1',
//         'type': 'load_created',
//         'title': 'New load posted',
//         'description': 'Electronics shipment from Cairo to Alexandria',
//         'timestamp': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
//         'icon': 'local_shipping',
//         'color': 0xFF2196F3,
//       },
//       {
//         'id': '2',
//         'type': 'bid_accepted',
//         'title': 'Bid accepted',
//         'description': 'Your bid for furniture transport was accepted',
//         'timestamp': DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
//         'icon': 'handshake',
//         'color': 0xFF4CAF50,
//       },
//       {
//         'id': '3',
//         'type': 'parcel_delivered',
//         'title': 'Parcel delivered',
//         'description': 'Package delivered to customer in Giza',
//         'timestamp': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
//         'icon': 'check_circle',
//         'color': 0xFF4CAF50,
//       },
//       {
//         'id': '4',
//         'type': 'ride_booked',
//         'title': 'Ride booked',
//         'description': 'Journey from Cairo to Hurghada',
//         'timestamp': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
//         'icon': 'directions_car',
//         'color': 0xFF9C27B0,
//       },
//     ];
//   }
// }