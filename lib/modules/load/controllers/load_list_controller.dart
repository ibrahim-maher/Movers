import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/load_category_model.dart';
import '../models/load_model.dart';
import '../models/load_status_model.dart';
import '../repositories/load_repository.dart';

class LoadListController extends GetxController {
  final LoadRepository _loadRepository = Get.find<LoadRepository>();

  // Expose repository properties
  RxList<LoadModel> get loads => _loadRepository.loads;
  RxBool get isLoading => _loadRepository.isLoading;
  RxString get errorMessage => _loadRepository.errorMessage;

  // Search and filter
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString selectedCategoryId = ''.obs;
  final RxString selectedStatusId = ''.obs;
  final RxList<LoadModel> filteredLoads = <LoadModel>[].obs;

  RxList<LoadCategoryModel> categories = <LoadCategoryModel>[].obs;
  RxList<LoadStatusModel> statuses = <LoadStatusModel>[].obs;


  @override
  void onInit() {
    super.onInit();
    fetchLoads();
    _setupListeners();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _setupListeners() {
    // Listen to search query changes
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      _applyFilters();
    });

    // Listen to loads changes
    ever(loads, (_) => _applyFilters());

    // Listen to filter changes
    ever(selectedCategoryId, (_) => _applyFilters());
    ever(selectedStatusId, (_) => _applyFilters());
  }

  void _applyFilters() {
    List<LoadModel> result = List.from(loads);

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((load) {
        return load.title.toLowerCase().contains(query) ||
               load.description.toLowerCase().contains(query) ||
               load.pickupLocation.toLowerCase().contains(query) ||
               load.deliveryLocation.toLowerCase().contains(query);
      }).toList();
    }

    // Apply category filter
    if (selectedCategoryId.isNotEmpty) {
      result = result.where((load) => load.categoryId == selectedCategoryId.value).toList();
    }

    // Apply status filter
    if (selectedStatusId.isNotEmpty) {
      result = result.where((load) => load.statusId == selectedStatusId.value).toList();
    }

    // Sort by creation date (newest first)
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    filteredLoads.assignAll(result);
  }

  Future<void> fetchLoads() async {
    await _loadRepository.fetchLoads();
  }

  Future<void> refreshLoads() async {
    await fetchLoads();
  }

  void clearFilters() {
    searchController.clear();
    selectedCategoryId.value = '';
    selectedStatusId.value = '';
  }

  void selectCategory(String categoryId) {
    if (selectedCategoryId.value == categoryId) {
      selectedCategoryId.value = ''; // Toggle off if already selected
    } else {
      selectedCategoryId.value = categoryId;
    }
  }

  void selectStatus(String statusId) {
    if (selectedStatusId.value == statusId) {
      selectedStatusId.value = ''; // Toggle off if already selected
    } else {
      selectedStatusId.value = statusId;
    }
  }

  void navigateToLoadDetails(String loadId) {
    Get.toNamed('/load/details/$loadId');
  }

  void navigateToCreateLoad() {
    Get.toNamed('/load/create');
  }
}