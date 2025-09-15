// lib/modules/load/controllers/create_load_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/load_model.dart';
import '../services/load_service.dart';
import '../../../shared/services/firebase/firebase_service.dart';

class CreateLoadController extends GetxController {
  final LoadService _loadService = Get.find<LoadService>();
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  // Form controllers
  final pickupLocationController = TextEditingController();
  final dropLocationController = TextEditingController();
  final materialNameController = TextEditingController();
  final numberOfTonnesController = TextEditingController();
  final descriptionController = TextEditingController();
  final expectedPriceController = TextEditingController();
  final visibilityHoursController = TextEditingController();
  final pickupContactController = TextEditingController();
  final dropContactController = TextEditingController();

  // Observable properties
  final RxInt currentStep = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString selectedVehicleType = ''.obs;
  final RxBool isFixedPrice = true.obs;
  final RxBool useSelfForPickup = false.obs;
  final RxBool useSelfForDrop = false.obs;

  // Vehicle types
  final List<VehicleType> vehicleTypes = VehicleType.getDefaultVehicles();

  // Form validation
  final GlobalKey<FormState> loadDetailsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> contactDetailsFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _initializeDefaults();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  void _initializeDefaults() {
    visibilityHoursController.text = '24';
    expectedPriceController.text = '250';
    numberOfTonnesController.text = '10';
  }

  void _disposeControllers() {
    pickupLocationController.dispose();
    dropLocationController.dispose();
    materialNameController.dispose();
    numberOfTonnesController.dispose();
    descriptionController.dispose();
    expectedPriceController.dispose();
    visibilityHoursController.dispose();
    pickupContactController.dispose();
    dropContactController.dispose();
  }

  // Navigation methods
  void nextStep() {
    if (currentStep.value == 0) {
      if (loadDetailsFormKey.currentState?.validate() ?? false) {
        currentStep.value = 1;
      }
    } else if (currentStep.value == 1) {
      if (selectedVehicleType.value.isNotEmpty) {
        currentStep.value = 2;
      } else {
        Get.snackbar(
          'Error',
          'Please select a vehicle type',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else if (currentStep.value == 2) {
      if (contactDetailsFormKey.currentState?.validate() ?? false) {
        _createLoad();
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value = currentStep.value - 1;
    }
  }

  // Vehicle selection
  void selectVehicleType(VehicleType vehicleType) {
    selectedVehicleType.value = vehicleType.id;
  }

  // Price type toggle
  void togglePriceType(bool isFixed) {
    isFixedPrice.value = isFixed;
  }

  // Contact toggles
  void toggleSelfPickup(bool value) {
    useSelfForPickup.value = value;
    if (value) {
      final user = _firebaseService.currentUser;
      pickupContactController.text = user?.displayName ?? '';
    } else {
      pickupContactController.clear();
    }
  }

  void toggleSelfDrop(bool value) {
    useSelfForDrop.value = value;
    if (value) {
      final user = _firebaseService.currentUser;
      dropContactController.text = user?.displayName ?? '';
    } else {
      dropContactController.clear();
    }
  }

  // Create load
  Future<void> _createLoad() async {
    try {
      isLoading.value = true;
      print('🚀 Starting load creation process...');

      final userId = _firebaseService.currentUserId;
      if (userId == null) {
        print('❌ Error: User not authenticated');
        Get.snackbar(
          'Error',
          'User not authenticated',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      print('✅ User authenticated: $userId');

      // Get selected vehicle type details
      final selectedVehicle = vehicleTypes.firstWhere(
            (v) => v.id == selectedVehicleType.value,
      );

      print('🚛 Selected vehicle: ${selectedVehicle.name}');

      // Calculate distance (you should implement proper geocoding)
      final distance = await _calculateDistance();
      print('📍 Calculated distance: ${distance}km');

      // Create load model
      final load = LoadModel(
        id: '', // Will be set by Firestore
        userId: userId,
        title: '${materialNameController.text} - ${selectedVehicle.name}',
        description: descriptionController.text.isEmpty ? 'No description provided' : descriptionController.text,
        materialName: materialNameController.text,
        weight: double.tryParse(numberOfTonnesController.text) ?? 0,
        pickupLocation: pickupLocationController.text,
        dropLocation: dropLocationController.text,
        pickupAddress: pickupLocationController.text, // You might want to separate this
        dropAddress: dropLocationController.text, // You might want to separate this
        pickupLatitude: 23.0225, // Placeholder - implement geocoding
        pickupLongitude: 72.5714, // Placeholder - implement geocoding
        dropLatitude: 19.0760, // Placeholder - implement geocoding
        dropLongitude: 72.8777, // Placeholder - implement geocoding
        vehicleType: selectedVehicle.name,
        vehicleIcon: selectedVehicle.icon,
        expectedPrice: double.tryParse(expectedPriceController.text) ?? 0,
        isFixedPrice: isFixedPrice.value,
        priceType: isFixedPrice.value ? 'fixed' : 'negotiable',
        visibilityHours: int.tryParse(visibilityHoursController.text) ?? 24,
        status: 'pending',
        pickupContactName: pickupContactController.text,
        pickupContactPhone: '', // You might want to add phone fields
        dropContactName: dropContactController.text,
        dropContactPhone: '', // You might want to add phone fields
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        distance: distance,
      );

      print('📦 Load model created:');
      print('   - Title: ${load.title}');
      print('   - Material: ${load.materialName}');
      print('   - Weight: ${load.weight} tonnes');
      print('   - Price: \${load.expectedPrice} (${load.priceType})');
      print('   - Route: ${load.pickupLocation} → ${load.dropLocation}');

      // Create load in database
      print('💾 Saving to Firestore...');
      final loadId = await _loadService.createLoad(load);
      print('✅ Load created successfully with ID: $loadId');

      // Log the event
      await _firebaseService.logEvent(
        name: 'load_created',
        parameters: {
          'load_id': loadId,
          'vehicle_type': selectedVehicle.name,
          'material': load.materialName,
          'weight': load.weight,
          'price': load.expectedPrice,
          'price_type': load.priceType,
          'pickup_location': load.pickupLocation,
          'drop_location': load.dropLocation,
        },
      );

      print('📊 Analytics event logged');

      Get.snackbar(
        'Success',
        'Load created successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Navigate back to loads list
      print('🔄 Navigating back to loads list...');
      Get.back(); // Go back to previous screen
      Get.toNamed('/loads'); // Navigate to loads list

    } catch (e, stackTrace) {
      print('❌ Error creating load: $e');
      print('📍 Stack trace: $stackTrace');

      Get.snackbar(
        'Error',
        'Failed to create load: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
      print('🏁 Load creation process completed');
    }
  }

  // Calculate distance (placeholder implementation)
  Future<double> _calculateDistance() async {
    // In a real app, you'd use geocoding and distance calculation
    // For now, return a realistic placeholder value based on the locations

    print('🔍 Calculating distance between pickup and drop locations...');

    final pickup = pickupLocationController.text.toLowerCase();
    final drop = dropLocationController.text.toLowerCase();

    // Simple distance estimation based on common routes
    if (pickup.contains('gujarat') && drop.contains('gujarat')) {
      return 150.0 + (DateTime.now().millisecondsSinceEpoch % 100).toDouble();
    } else if (pickup.contains('maharashtra') && drop.contains('maharashtra')) {
      return 200.0 + (DateTime.now().millisecondsSinceEpoch % 150).toDouble();
    } else if ((pickup.contains('gujarat') && drop.contains('maharashtra')) ||
        (pickup.contains('maharashtra') && drop.contains('gujarat'))) {
      return 450.0 + (DateTime.now().millisecondsSinceEpoch % 100).toDouble();
    } else {
      // Default distance for any other combination
      return 244.54 + (DateTime.now().millisecondsSinceEpoch % 200).toDouble();
    }
  }

  // Validation methods
  String? validatePickupLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter pickup location';
    }
    return null;
  }

  String? validateDropLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter drop location';
    }
    return null;
  }

  String? validateMaterialName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter material name';
    }
    return null;
  }

  String? validateNumberOfTonnes(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter number of tonnes';
    }
    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? validateExpectedPrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter expected price';
    }
    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return 'Please enter a valid price';
    }
    return null;
  }

  String? validateContactName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter contact name';
    }
    return null;
  }

  String? validateVisibilityHours(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter visibility hours';
    }
    final number = int.tryParse(value);
    if (number == null || number <= 0) {
      return 'Please enter valid hours';
    }
    return null;
  }

  // Get step title
  String getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Load Details';
      case 1:
        return 'Vehicle Type';
      case 2:
        return 'Post';
      default:
        return 'Post Load';
    }
  }

  // Check if step is completed
  bool isStepCompleted(int step) {
    switch (step) {
      case 0:
        return pickupLocationController.text.isNotEmpty &&
            dropLocationController.text.isNotEmpty &&
            materialNameController.text.isNotEmpty &&
            numberOfTonnesController.text.isNotEmpty;
      case 1:
        return selectedVehicleType.value.isNotEmpty;
      case 2:
        return expectedPriceController.text.isNotEmpty &&
            pickupContactController.text.isNotEmpty &&
            dropContactController.text.isNotEmpty;
      default:
        return false;
    }
  }
}