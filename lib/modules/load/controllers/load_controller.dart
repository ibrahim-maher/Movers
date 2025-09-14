import 'package:get/get.dart';

import '../models/load_category_model.dart';
import '../models/load_model.dart';
import '../models/load_status_model.dart';
import '../repositories/load_repository.dart';

class LoadController extends GetxController {
  final LoadRepository _loadRepository = Get.find<LoadRepository>();

  // Expose repository properties
  RxList<LoadModel> get loads => _loadRepository.loads;
  RxList<LoadCategoryModel> get categories => _loadRepository.categories;
  RxList<LoadStatusModel> get statuses => _loadRepository.statuses;
  Rx<LoadModel?> get selectedLoad => _loadRepository.selectedLoad;
  RxBool get isLoading => _loadRepository.isLoading;
  RxBool get isLoadingCategories => _loadRepository.isLoadingCategories;
  RxBool get isLoadingStatuses => _loadRepository.isLoadingStatuses;
  RxBool get isSubmitting => _loadRepository.isSubmitting;
  RxString get errorMessage => _loadRepository.errorMessage;

  @override
  void onInit() {
    super.onInit();
    fetchLoads();
  }

  Future<void> fetchLoads() async {
    await _loadRepository.fetchLoads();
  }

  Future<void> fetchLoadById(String id) async {
    await _loadRepository.fetchLoadById(id);
  }

  Future<void> refreshData() async {
    await fetchLoads();
  }

  Future<void> refreshCategories() async {
    await _loadRepository.fetchCategories();
  }

  Future<void> refreshStatuses() async {
    await _loadRepository.fetchStatuses();
  }

  String getCategoryName(String categoryId) {
    final category = categories.firstWhereOrNull((c) => c.id == categoryId);
    return category?.name ?? 'Unknown';
  }

  LoadStatusModel? getStatusById(String statusId) {
    return statuses.firstWhereOrNull((s) => s.id == statusId);
  }

  String getStatusName(String statusId) {
    final status = getStatusById(statusId);
    return status?.name ?? 'Unknown';
  }
}