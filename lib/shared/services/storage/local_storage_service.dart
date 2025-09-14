import 'package:get_storage/get_storage.dart';

class LocalStorageService {
  static const String _containerName = 'MoversApp';
  late final GetStorage _storage;

  // Initialize storage
  Future<void> init() async {
    await GetStorage.init(_containerName);
    _storage = GetStorage(_containerName);
  }

  // Constructor
  LocalStorageService() {
    _storage = GetStorage(_containerName);
  }

  // String operations
  Future<void> setString(String key, String value) async {
    await _storage.write(key, value);
  }

  String? getString(String key) {
    return _storage.read<String>(key);
  }

  // Integer operations
  Future<void> setInt(String key, int value) async {
    await _storage.write(key, value);
  }

  int? getInt(String key) {
    return _storage.read<int>(key);
  }

  // Boolean operations
  Future<void> setBool(String key, bool value) async {
    await _storage.write(key, value);
  }

  bool? getBool(String key) {
    return _storage.read<bool>(key);
  }

  // Double operations
  Future<void> setDouble(String key, double value) async {
    await _storage.write(key, value);
  }

  double? getDouble(String key) {
    return _storage.read<double>(key);
  }

  // List operations
  Future<void> setStringList(String key, List<String> value) async {
    await _storage.write(key, value);
  }

  List<String>? getStringList(String key) {
    final data = _storage.read<List>(key);
    return data?.cast<String>();
  }

  // Map operations
  Future<void> setMap(String key, Map<String, dynamic> value) async {
    await _storage.write(key, value);
  }

  Map<String, dynamic>? getMap(String key) {
    final data = _storage.read<Map>(key);
    return data?.cast<String, dynamic>();
  }

  // Generic operations
  Future<void> setValue<T>(String key, T value) async {
    await _storage.write(key, value);
  }

  T? getValue<T>(String key) {
    return _storage.read<T>(key);
  }

  // Check if key exists
  bool hasData(String key) {
    return _storage.hasData(key);
  }

  // Remove specific key
  Future<void> remove(String key) async {
    await _storage.remove(key);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _storage.erase();
  }

  // Get all keys
  Iterable<String> getKeys() {
    return _storage.getKeys();
  }

  // Listen to changes
  void listen<T>(String key, Function(T) callback) {
    _storage.listen(() {
      final value = _storage.read<T>(key);
      if (value != null) {
        callback(value);
      }
    });
  }

  // Remove listener
  void removeListener() {
    _storage.removeListen();
  }
}

extension on GetStorage {
  void removeListen() {}
}