import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = false.obs;
  final RxString connectionType = 'none'.obs;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  // Initialize connectivity status
  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      print('Failed to get connectivity: $e');
      isConnected.value = false;
      connectionType.value = 'none';
    }
  }

  // Update connection status
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // Prioritize connection types: ethernet > wifi > mobile > none
    if (results.contains(ConnectivityResult.ethernet)) {
      isConnected.value = true;
      connectionType.value = 'ethernet';
    } else if (results.contains(ConnectivityResult.wifi)) {
      isConnected.value = true;
      connectionType.value = 'wifi';
    } else if (results.contains(ConnectivityResult.mobile)) {
      isConnected.value = true;
      connectionType.value = 'mobile';
    } else {
      isConnected.value = false;
      connectionType.value = 'none';
    }

    // Show snackbar for connection changes
    if (isConnected.value && connectionType.value != 'none') {
      Get.snackbar(
        'Connected',
        'Internet connection restored via ${connectionType.value}',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'No Internet',
        'Please check your internet connection',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Check if connected to WiFi
  bool get isWiFi => connectionType.value == 'wifi';

  // Check if connected to mobile data
  bool get isMobile => connectionType.value == 'mobile';

  // Check if connected to ethernet
  bool get isEthernet => connectionType.value == 'ethernet';

  // Get connection type
  String get currentConnectionType => connectionType.value;

  // Manual connectivity check
  Future<bool> checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
      return isConnected.value;
    } catch (e) {
      print('Failed to check connectivity: $e');
      isConnected.value = false;
      connectionType.value = 'none';
      return false;
    }
  }
}