import 'package:get/get.dart';

import '../models/create_load_request_model.dart';
import '../models/load_category_model.dart';
import '../models/load_model.dart';
import '../models/load_status_model.dart';
import '../models/load_tracking_model.dart';
import '../services/load_service.dart';
import '../services/load_tracking_service.dart';

class LoadRepository extends GetxService {
  final LoadService _loadService = Get.find<LoadService>();
  final LoadTrackingService _trackingService = Get.find<LoadTrackingService>();

  // Observable lists
  final RxList<LoadModel> loads = <LoadModel>[].obs;
  final RxList<LoadCategoryModel> categories = <LoadCategoryModel>[].obs;
  final RxList<LoadStatusModel> statuses = <LoadStatusModel>[].obs;
  
  // Selected load
  final Rx<LoadModel?> selectedLoad = Rx<LoadModel?>(null);
  
  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isLoadingCategories = false.obs;
  final RxBool isLoadingStatuses = false.obs;
  final RxBool isSubmitting = false.obs;

  // Error message
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchStatuses();
  }

  Future<void> fetchLoads() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final loadsList = await _loadService.getLoads();
      loads.assignAll(loadsList);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLoadById(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final load = await _loadService.getLoadById(id);
      selectedLoad.value = load;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createLoad(CreateLoadRequestModel request) async {
    try {
      isSubmitting.value = true;
      errorMessage.value = '';
      
      final newLoad = await _loadService.createLoad(request);
      loads.add(newLoad);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> updateLoad(String id, CreateLoadRequestModel request) async {
    try {
      isSubmitting.value = true;
      errorMessage.value = '';
      
      final updatedLoad = await _loadService.updateLoad(id, request);
      
      // Update in the list
      final index = loads.indexWhere((load) => load.id == id);
      if (index != -1) {
        loads[index] = updatedLoad;
      }
      
      // Update selected load if it's the same
      if (selectedLoad.value?.id == id) {
        selectedLoad.value = updatedLoad;
      }
      
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteLoad(String id) async {
    try {
      isSubmitting.value = true;
      errorMessage.value = '';
      
      await _loadService.deleteLoad(id);
      
      // Remove from the list
      loads.removeWhere((load) => load.id == id);
      
      // Clear selected load if it's the same
      if (selectedLoad.value?.id == id) {
        selectedLoad.value = null;
      }
      
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      isLoadingCategories.value = true;
      
      final categoriesList = await _loadService.getCategories();
      categories.assignAll(categoriesList);
    } catch (e) {
      // Silent fail for categories
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> fetchStatuses() async {
    try {
      isLoadingStatuses.value = true;
      
      final statusesList = await _loadService.getStatuses();
      statuses.assignAll(statusesList);
    } catch (e) {
      // Silent fail for statuses
    } finally {
      isLoadingStatuses.value = false;
    }
  }

  Future<bool> updateLoadStatus(String id, String statusId) async {
    try {
      isSubmitting.value = true;
      errorMessage.value = '';
      
      await _loadService.updateLoadStatus(id, statusId);
      
      // Refresh the load details
      await fetchLoadById(id);
      
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<List<LoadTrackingModel>> getTrackingHistory(String loadId) async {
    try {
      return await _trackingService.getTrackingHistory(loadId);
    } catch (e) {
      errorMessage.value = e.toString();
      return [];
    }
  }

  Future<LoadTrackingModel?> getLatestTracking(String loadId) async {
    try {
      return await _trackingService.getLatestTracking(loadId);
    } catch (e) {
      return null;
    }
  }

  Future<bool> addTrackingUpdate(
    String loadId,
    String statusId,
    String location,
    double latitude,
    double longitude,
    String? notes,
  ) async {
    try {
      isSubmitting.value = true;
      errorMessage.value = '';
      
      await _trackingService.addTrackingUpdate(
        loadId,
        statusId,
        location,
        latitude,
        longitude,
        notes,
      );
      
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}