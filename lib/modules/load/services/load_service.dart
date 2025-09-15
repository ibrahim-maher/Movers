// lib/modules/load/services/load_service.dart

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/load_model.dart';
import '../../../shared/services/firebase/firebase_service.dart';

class LoadService extends GetxService {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final CollectionReference _loadsCollection = FirebaseFirestore.instance.collection('loads');
  final CollectionReference _bidsCollection = FirebaseFirestore.instance.collection('bids');

  // Create a new load
  Future<String> createLoad(LoadModel load) async {
    try {
      final docRef = await _loadsCollection.add(load.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create load: $e');
    }
  }

  // Get all loads
  Future<List<LoadModel>> getLoads({
    int limit = 20,
    DocumentSnapshot? lastDocument,
    String? status,
    String? vehicleType,
  }) async {
    try {
      Query query = _loadsCollection.orderBy('createdAt', descending: true);

      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }

      if (vehicleType != null) {
        query = query.where('vehicleType', isEqualTo: vehicleType);
      }

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      query = query.limit(limit);

      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) => LoadModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get loads: $e');
    }
  }

  // Get user's loads
  Future<List<LoadModel>> getUserLoads(String userId, {String? status}) async {
    try {
      print('🔍 Fetching loads for user: $userId');
      if (status != null) {
        print('📋 Filtering by status: $status');
      }

      // Use a simpler query to avoid index requirements
      Query query = _loadsCollection.where('userId', isEqualTo: userId);

      // Don't use orderBy with where clause to avoid composite index requirement
      // We'll sort in memory instead
      final querySnapshot = await query.get();
      print('📊 Found ${querySnapshot.docs.length} documents');

      final loads = querySnapshot.docs.map((doc) {
        print('📝 Processing document ID: ${doc.id}');
        final data = doc.data() as Map<String, dynamic>;
        print('📋 Document data keys: ${data.keys.toList()}');

        // Create LoadModel with proper ID
        final load = LoadModel.fromJson({
          ...data,
          'id': doc.id, // Ensure the Firestore document ID is set
        });

        print('✅ Created LoadModel with ID: ${load.id}');
        return load;
      }).toList();

      // Sort by createdAt in memory (newest first)
      loads.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Filter by status if provided
      final filteredLoads = status != null
          ? loads.where((load) => load.status == status).toList()
          : loads;

      print('🎯 Successfully processed ${filteredLoads.length} loads after filtering');
      return filteredLoads;
    } catch (e, stackTrace) {
      print('❌ Error getting user loads: $e');
      print('📍 Stack trace: $stackTrace');
      throw Exception('Failed to get user loads: $e');
    }
  }

  // Get load by ID
  Future<LoadModel?> getLoadById(String loadId) async {
    try {
      final doc = await _loadsCollection.doc(loadId).get();
      if (doc.exists) {
        return LoadModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get load: $e');
    }
  }

  // Update load
  Future<void> updateLoad(String loadId, Map<String, dynamic> updates) async {
    try {
      await _loadsCollection.doc(loadId).update({
        ...updates,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update load: $e');
    }
  }

  // Delete load
  Future<void> deleteLoad(String loadId) async {
    try {
      await _loadsCollection.doc(loadId).delete();
    } catch (e) {
      throw Exception('Failed to delete load: $e');
    }
  }

  // Place bid on load
  Future<String> placeBid(LoadBid bid) async {
    try {
      final docRef = await _bidsCollection.add(bid.toJson());

      // Update load with new bid
      await _loadsCollection.doc(bid.loadId).update({
        'bids': FieldValue.arrayUnion([bid.toJson()]),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to place bid: $e');
    }
  }

  // Accept bid
  Future<void> acceptBid(String loadId, String bidId) async {
    try {
      final batch = FirebaseFirestore.instance.batch();

      // Update bid status
      batch.update(_bidsCollection.doc(bidId), {
        'status': 'accepted',
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // Update load status and assigned driver
      final bid = await _bidsCollection.doc(bidId).get();
      if (bid.exists) {
        final bidData = bid.data() as Map<String, dynamic>;
        batch.update(_loadsCollection.doc(loadId), {
          'status': 'confirmed',
          'assignedDriverId': bidData['bidderId'],
          'assignedDriverName': bidData['bidderName'],
          'finalPrice': bidData['bidAmount'],
          'updatedAt': DateTime.now().toIso8601String(),
        });
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to accept bid: $e');
    }
  }

  // Reject bid
  Future<void> rejectBid(String bidId) async {
    try {
      await _bidsCollection.doc(bidId).update({
        'status': 'rejected',
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to reject bid: $e');
    }
  }

  // Get bids for a load
  Future<List<LoadBid>> getLoadBids(String loadId) async {
    try {
      final querySnapshot = await _bidsCollection
          .where('loadId', isEqualTo: loadId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return LoadBid.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      throw Exception('Failed to get load bids: $e');
    }
  }

  // Search loads
  Future<List<LoadModel>> searchLoads({
    String? searchQuery,
    String? pickupLocation,
    String? dropLocation,
    String? vehicleType,
    double? minPrice,
    double? maxPrice,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = _loadsCollection.where('status', isEqualTo: 'pending');

      if (pickupLocation != null && pickupLocation.isNotEmpty) {
        query = query.where('pickupLocation', isGreaterThanOrEqualTo: pickupLocation)
            .where('pickupLocation', isLessThan: pickupLocation + '\uf8ff');
      }

      if (vehicleType != null) {
        query = query.where('vehicleType', isEqualTo: vehicleType);
      }

      if (minPrice != null) {
        query = query.where('expectedPrice', isGreaterThanOrEqualTo: minPrice);
      }

      if (maxPrice != null) {
        query = query.where('expectedPrice', isLessThanOrEqualTo: maxPrice);
      }

      final querySnapshot = await query.get();
      List<LoadModel> loads = querySnapshot.docs.map((doc) => LoadModel.fromFirestore(doc)).toList();

      // Additional filtering on the client side
      if (searchQuery != null && searchQuery.isNotEmpty) {
        loads = loads.where((load) =>
        load.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            load.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
            load.materialName.toLowerCase().contains(searchQuery.toLowerCase())
        ).toList();
      }

      if (dropLocation != null && dropLocation.isNotEmpty) {
        loads = loads.where((load) =>
            load.dropLocation.toLowerCase().contains(dropLocation.toLowerCase())
        ).toList();
      }

      return loads;
    } catch (e) {
      throw Exception('Failed to search loads: $e');
    }
  }

  // Get nearby loads
  Future<List<LoadModel>> getNearbyLoads({
    required double latitude,
    required double longitude,
    double radiusInKm = 50.0,
  }) async {
    try {
      // This is a simplified approach. For production, use GeoFirestore for proper geolocation queries
      final loads = await getLoads();

      return loads.where((load) {
        final distance = calculateDistance(
          latitude, longitude,
          load.pickupLatitude, load.pickupLongitude,
        );
        return distance <= radiusInKm;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get nearby loads: $e');
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // in km

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double radLat1 = _degreesToRadians(lat1);
    final double radLat2 = _degreesToRadians(lat2);

    final double a = pow(sin(dLat / 2), 2) +
        cos(radLat1) * cos(radLat2) * pow(sin(dLon / 2), 2);

    final double c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (3.14159265 / 180);
  }

  // Listen to load updates
  Stream<LoadModel> watchLoad(String loadId) {
    return _loadsCollection.doc(loadId).snapshots().map((doc) {
      if (doc.exists) {
        return LoadModel.fromFirestore(doc);
      }
      throw Exception('Load not found');
    });
  }

  // Listen to user loads
  Stream<List<LoadModel>> watchUserLoads(String userId) {
    return _loadsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => LoadModel.fromFirestore(doc)).toList());
  }

  // Get load statistics
  Future<Map<String, dynamic>> getLoadStatistics(String userId) async {
    try {
      final loads = await getUserLoads(userId);

      final totalLoads = loads.length;
      final pendingLoads = loads.where((load) => load.status == 'pending').length;
      final confirmedLoads = loads.where((load) => load.status == 'confirmed').length;
      final completedLoads = loads.where((load) => load.status == 'completed').length;
      final totalEarnings = loads
          .where((load) => load.status == 'completed' && load.finalPrice != null)
          .fold(0.0, (sum, load) => sum + load.finalPrice!);

      return {
        'totalLoads': totalLoads,
        'pendingLoads': pendingLoads,
        'confirmedLoads': confirmedLoads,
        'completedLoads': completedLoads,
        'totalEarnings': totalEarnings,
      };
    } catch (e) {
      throw Exception('Failed to get load statistics: $e');
    }
  }
}