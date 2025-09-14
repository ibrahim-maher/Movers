import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/create_load_request_model.dart';
import '../models/load_category_model.dart';
import '../repositories/load_repository.dart';

class CreateLoadController extends GetxController {
  final LoadRepository _loadRepository = Get.find<LoadRepository>();

  // Form controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController pickupLocationController = TextEditingController();
  final TextEditingController deliveryLocationController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController dimensionsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  
  // Date controllers
  final Rx<DateTime> pickupDate = DateTime.now().obs;
  final Rx<DateTime> deliveryDate = DateTime.now().add(const Duration(days: 1)).obs;
  
  // Selected category
  final RxString selectedCategoryId = ''.obs;
  
  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Expose repository properties
  RxList<LoadCategoryModel> get categories => _loadRepository.categories;
  RxBool get isLoadingCategories => _loadRepository.isLoadingCategories;
  RxBool get isSubmitting => _loadRepository.isSubmitting;
  RxString get errorMessage => _loadRepository.errorMessage;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    pickupLocationController.dispose();
    deliveryLocationController.dispose();
    weightController.dispose();
    dimensionsController.dispose();
    priceController.dispose();
    super.onClose();
  }

  Future<void> fetchCategories() async {
    await _loadRepository.fetchCategories();
    if (categories.isNotEmpty && selectedCategoryId.isEmpty) {
      selectedCategoryId.value = categories.first.id;
    }
  }

  Future<void> selectPickupDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: pickupDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      pickupDate.value = picked;
      // If delivery date is before pickup date, update it
      if (deliveryDate.value.isBefore(picked)) {
        deliveryDate.value = picked.add(const Duration(days: 1));
      }
    }
  }

  Future<void> selectDeliveryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: deliveryDate.value,
      firstDate: pickupDate.value,
      lastDate: pickupDate.value.add(const Duration(days: 365)),
    );
    if (picked != null) {
      deliveryDate.value = picked;
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  void selectCategory(String categoryId) {
    selectedCategoryId.value = categoryId;
  }

  Future<bool> createLoad() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }
    
    try {
      final request = CreateLoadRequestModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        pickupLocation: pickupLocationController.text.trim(),
        deliveryLocation: deliveryLocationController.text.trim(),
        pickupDate: pickupDate.value,
        deliveryDate: deliveryDate.value,
        weight: double.parse(weightController.text),
        dimensions: dimensionsController.text.trim(),
        categoryId: selectedCategoryId.value,
        price: double.parse(priceController.text),
      );
      
      final success = await _loadRepository.createLoad(request);
      
      if (success) {
        Get.back(); // Go back to list
        Get.snackbar(
          'Success',
          'Load created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
      
      return success;
    } catch (e) {
      errorMessage.value = 'Failed to create load: ${e.toString()}';
      return false;
    }
  }

  // Validation
  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required';
    }
    return null;
  }

  String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Location is required';
    }
    return null;
  }

  String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Weight is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? validateDimensions(String? value) {
    if (value == null || value.isEmpty) {
      return 'Dimensions are required';
    }
    return null;
  }

  String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }
}