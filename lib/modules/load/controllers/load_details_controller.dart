import 'package:get/get.dart';

import '../models/load_model.dart';
import '../models/load_status_model.dart';
import '../models/load_tracking_model.dart';
import '../repositories/load_repository.dart';

class LoadDetailsController extends GetxController {
  final LoadRepository _loadRepository = Get.find<LoadRepository>();

  // Expose repository properties
  Rx<LoadModel?> get selectedLoad => _loadRepository.selectedLoad;
  RxBool get isLoading => _loadRepository.isLoading;
  RxBool get isSubmitting => _loadRepository.isSubmitting;
  RxString get errorMessage => _loadRepository.errorMessage;
  RxList<LoadStatusModel> get statuses => _loadRepository.statuses;

  // Tracking history
  final RxList<LoadTrackingModel> trackingHistory = <LoadTrackingModel>[].obs;
  final RxBool isLoadingTracking = false.obs;

  // Selected status for update
  final RxString selectedStatusId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get load ID from route parameters
    final String? loadId = Get.parameters['id'];
    if (loadId != null) {
      fetchLoadDetails(loadId);
    } else {
      Get.back(); // Go back if no ID provided
    }
  }

  Future<void> fetchLoadDetails(String loadId) async {
    await _loadRepository.fetchLoadById(loadId);
    if (selectedLoad.value != null) {
      selectedStatusId.value = selectedLoad.value!.statusId;
      fetchTrackingHistory(loadId);
    }
  }

  Future<void> fetchTrackingHistory(String loadId) async {
    try {
      isLoadingTracking.value = true;
      final history = await _loadRepository.getTrackingHistory(loadId);
      trackingHistory.assignAll(history);
    } finally {
      isLoadingTracking.value = false;
    }
  }

  Future<void> refreshData() async {
    if (selectedLoad.value != null) {
      await fetchLoadDetails(selectedLoad.value!.id);
    }
  }

  Future<bool> updateLoadStatus(String statusId) async {
    if (selectedLoad.value == null) return false;
    
    final success = await _loadRepository.updateLoadStatus(
      selectedLoad.value!.id,
      statusId,
    );
    
    if (success) {
      await refreshData();
    }
    
    return success;
  }

  Future<bool> deleteLoad() async {
    if (selectedLoad.value == null) return false;
    
    final success = await _loadRepository.deleteLoad(selectedLoad.value!.id);
    
    if (success) {
      Get.back(); // Go back to list
    }
    
    return success;
  }

  void navigateToEditLoad() {
    if (selectedLoad.value != null) {
      Get.toNamed('/load/edit/${selectedLoad.value!.id}');
    }
  }

  void navigateToTrackingPage() {
    if (selectedLoad.value != null) {
      Get.toNamed('/load/tracking/${selectedLoad.value!.id}');
    }
  }
}