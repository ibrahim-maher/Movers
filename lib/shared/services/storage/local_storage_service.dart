import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class LocalStorageService extends GetxService {
  GetStorage? _storage;
  bool _isInitialized = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    await init();
  }

  Future<LocalStorageService> init() async {
    try {
      _storage = GetStorage('MoversApp');
      await _storage!.writeIfNull('app_initialized', true);
      _isInitialized = true;
      print('✅ LocalStorageService initialized successfully');
      return this;
    } catch (e) {
      print('❌ LocalStorageService initialization failed: $e');
      try {
        _storage = GetStorage();
        _isInitialized = true;
        print('✅ LocalStorageService initialized with fallback');
      } catch (fallbackError) {
        print('❌ LocalStorageService fallback failed: $fallbackError');
        _isInitialized = false;
      }
      return this;
    }
  }

  // ASYNC WRITE METHODS
  Future<void> setBool(String key, bool value) async {
    if (!_isInitialized || _storage == null) {
      print('⚠️ Storage not ready, cannot set $key = $value');
      return;
    }
    try {
      await _storage!.write(key, value);
      print('✅ Saved bool $key = $value');
    } catch (e) {
      print('❌ Error writing bool $key: $e');
    }
  }

  Future<void> setString(String key, String value) async {
    if (!_isInitialized || _storage == null) {
      print('⚠️ Storage not ready, cannot set $key = $value');
      return;
    }
    try {
      await _storage!.write(key, value);
      print('✅ Saved string $key = $value');
    } catch (e) {
      print('❌ Error writing string $key: $e');
    }
  }

  Future<void> setInt(String key, int value) async {
    if (!_isInitialized || _storage == null) return;
    try {
      await _storage!.write(key, value);
      print('✅ Saved int $key = $value');
    } catch (e) {
      print('❌ Error writing int $key: $e');
    }
  }

  Future<void> setDouble(String key, double value) async {
    if (!_isInitialized || _storage == null) return;
    try {
      await _storage!.write(key, value);
      print('✅ Saved double $key = $value');
    } catch (e) {
      print('❌ Error writing double $key: $e');
    }
  }

  Future<void> setMap(String key, Map<String, dynamic> value) async {
    if (!_isInitialized || _storage == null) {
      print('⚠️ Storage not ready, cannot set map $key');
      return;
    }
    try {
      final jsonString = json.encode(value);
      await _storage!.write(key, jsonString);
      print('✅ Saved map $key');
    } catch (e) {
      print('❌ Error writing map $key: $e');
    }
  }

  Future<void> setList(String key, List<dynamic> value) async {
    if (!_isInitialized || _storage == null) return;
    try {
      final jsonString = json.encode(value);
      await _storage!.write(key, jsonString);
      print('✅ Saved list $key');
    } catch (e) {
      print('❌ Error writing list $key: $e');
    }
  }

  Future<void> remove(String key) async {
    if (!_isInitialized || _storage == null) return;
    try {
      await _storage!.remove(key);
      print('✅ Removed $key');
    } catch (e) {
      print('❌ Error removing $key: $e');
    }
  }

  Future<void> clearAll() async {
    if (!_isInitialized || _storage == null) return;
    try {
      await _storage!.erase();
      print('✅ Storage cleared');
    } catch (e) {
      print('❌ Error clearing storage: $e');
    }
  }

  // SYNC READ METHODS
  bool getBool(String key, {bool defaultValue = false}) {
    if (!_isInitialized || _storage == null) {
      print('⚠️ Storage not ready, returning default for $key: $defaultValue');
      return defaultValue;
    }
    try {
      return _storage!.read<bool>(key) ?? defaultValue;
    } catch (e) {
      print('❌ Error reading bool $key: $e');
      return defaultValue;
    }
  }

  String? getString(String key) {
    if (!_isInitialized || _storage == null) {
      print('⚠️ Storage not ready, returning null for $key');
      return null;
    }
    try {
      return _storage!.read<String>(key);
    } catch (e) {
      print('❌ Error reading string $key: $e');
      return null;
    }
  }

  int getInt(String key, {int defaultValue = 0}) {
    if (!_isInitialized || _storage == null) return defaultValue;
    try {
      return _storage!.read<int>(key) ?? defaultValue;
    } catch (e) {
      print('❌ Error reading int $key: $e');
      return defaultValue;
    }
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    if (!_isInitialized || _storage == null) return defaultValue;
    try {
      return _storage!.read<double>(key) ?? defaultValue;
    } catch (e) {
      print('❌ Error reading double $key: $e');
      return defaultValue;
    }
  }

  Map<String, dynamic>? getMap(String key) {
    if (!_isInitialized || _storage == null) {
      print('⚠️ Storage not ready, returning null for map $key');
      return null;
    }
    try {
      final jsonString = _storage!.read<String>(key);
      if (jsonString != null) {
        return Map<String, dynamic>.from(json.decode(jsonString));
      }
      return null;
    } catch (e) {
      print('❌ Error reading map $key: $e');
      return null;
    }
  }

  List<dynamic>? getList(String key) {
    if (!_isInitialized || _storage == null) return null;
    try {
      final jsonString = _storage!.read<String>(key);
      if (jsonString != null) {
        return List<dynamic>.from(json.decode(jsonString));
      }
      return null;
    } catch (e) {
      print('❌ Error reading list $key: $e');
      return null;
    }
  }

  bool hasKey(String key) {
    if (!_isInitialized || _storage == null) return false;
    try {
      return _storage!.hasData(key);
    } catch (e) {
      print('❌ Error checking key $key: $e');
      return false;
    }
  }

  Map<String, dynamic> getAll() {
    if (!_isInitialized || _storage == null) return {};
    try {
      final keys = _storage!.getKeys();
      final Map<String, dynamic> result = {};
      for (var key in keys) {
        result[key] = _storage!.read(key);
      }
      return result;
    } catch (e) {
      print('❌ Error getting all values: $e');
      return {};
    }
  }

  // Updated debugPrint method
  void debugPrint() {
    if (!_isInitialized || _storage == null) {
      print('⚠️ Storage not initialized');
      return;
    }

    try {
      print('=== STORAGE DEBUG ===');
      final keys = _storage!.getKeys();
      if (keys.isEmpty) {
        print('No data in storage');
      } else {
        for (var key in keys) {
          final value = _storage!.read(key);
          print('$key: $value (${value.runtimeType})');
        }
      }
      print('=====================');
    } catch (e) {
      print('❌ Error debugging storage: $e');
    }
  }

  int get length {
    if (!_isInitialized || _storage == null) return 0;
    try {
      return _storage!.getKeys().length;
    } catch (e) {
      return 0;
    }
  }

  List<String> get keys {
    if (!_isInitialized || _storage == null) return [];
    try {
      return _storage!.getKeys().toList();
    } catch (e) {
      return [];
    }
  }

  bool get isReady => _isInitialized && _storage != null;
}