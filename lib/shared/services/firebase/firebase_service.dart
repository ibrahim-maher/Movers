import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import '../../../core/config/firebase_config.dart';

class FirebaseService {
  // Firebase instances
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;
  FirebaseMessaging? _messaging;
  FirebaseAnalytics? _analytics;
  FirebaseCrashlytics? _crashlytics;

  // Getters
  FirebaseAuth get auth => _auth ??= FirebaseAuth.instance;
  FirebaseFirestore get firestore => _firestore ??= FirebaseFirestore.instance;
  FirebaseMessaging get messaging => _messaging ??= FirebaseMessaging.instance;
  FirebaseAnalytics get analytics => _analytics ??= FirebaseAnalytics.instance;
  FirebaseCrashlytics get crashlytics => _crashlytics ??= FirebaseCrashlytics.instance;

  // Initialization status
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Initialize Firebase
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize Firebase Core
      await Firebase.initializeApp(
        options: FirebaseConfig.currentPlatform,
      );

      // Initialize services
      await _initializeAuth();
      await _initializeFirestore();
      await _initializeMessaging();
      await _initializeAnalytics();
      await _initializeCrashlytics();

      _isInitialized = true;

      if (kDebugMode) {
        print('✅ Firebase initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Firebase initialization failed: $e');
      }
      rethrow;
    }
  }

  // Initialize Firebase Auth
  Future<void> _initializeAuth() async {
    try {
      _auth = FirebaseAuth.instance;

      // Configure persistence (web only)
      if (kIsWeb) {
        await _auth!.setPersistence(Persistence.LOCAL);
      }

      if (kDebugMode) {
        print('✅ Firebase Auth initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Firebase Auth initialization failed: $e');
      }
    }
  }

  // Initialize Firestore
  Future<void> _initializeFirestore() async {
    try {
      _firestore = FirebaseFirestore.instance;

      // Configure Firestore settings
      if (!kIsWeb) {
        await _firestore!.enableNetwork();
      }

      if (kDebugMode) {
        print('✅ Firestore initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Firestore initialization failed: $e');
      }
    }
  }

  // Initialize Firebase Messaging
  Future<void> _initializeMessaging() async {
    try {
      _messaging = FirebaseMessaging.instance;

      // Request permission for iOS
      await _messaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (kDebugMode) {
        print('✅ Firebase Messaging initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Firebase Messaging initialization failed: $e');
      }
    }
  }

  // Initialize Firebase Analytics
  Future<void> _initializeAnalytics() async {
    try {
      _analytics = FirebaseAnalytics.instance;

      // Set analytics collection enabled
      await _analytics!.setAnalyticsCollectionEnabled(!kDebugMode);

      if (kDebugMode) {
        print('✅ Firebase Analytics initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Firebase Analytics initialization failed: $e');
      }
    }
  }

  // Initialize Firebase Crashlytics
  Future<void> _initializeCrashlytics() async {
    try {
      _crashlytics = FirebaseCrashlytics.instance;

      // Set crashlytics collection enabled
      await _crashlytics!.setCrashlyticsCollectionEnabled(!kDebugMode);

      // Pass all uncaught errors to Crashlytics
      if (!kDebugMode) {
        FlutterError.onError = _crashlytics!.recordFlutterFatalError;
      }

      if (kDebugMode) {
        print('✅ Firebase Crashlytics initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Firebase Crashlytics initialization failed: $e');
      }
    }
  }

  // Get FCM Token
  Future<String?> getFCMToken() async {
    try {
      final token = await messaging.getToken();
      if (kDebugMode) {
        print('FCM Token: $token');
      }
      return token;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get FCM token: $e');
      }
      return null;
    }
  }

  // Log analytics event
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  }) async {
    try {
      // Filter out null values from parameters to match Map<String, Object> requirement
      final filteredParameters = parameters?.entries
          .where((entry) => entry.value != null)
          .map((entry) => MapEntry(entry.key, entry.value!))
          .toList();
      await analytics.logEvent(
        name: name,
        parameters: filteredParameters != null ? Map<String, Object>.fromEntries(filteredParameters) : null,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log analytics event: $e');
      }
    }
  }

  // Log custom error
  Future<void> logError({
    required dynamic exception,
    StackTrace? stackTrace,
    String? reason,
    bool fatal = false,
  }) async {
    try {
      await crashlytics.recordError(
        exception,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log error: $e');
      }
    }
  }

  // Set user identifier for analytics and crashlytics
  Future<void> setUserId(String userId) async {
    try {
      await analytics.setUserId(id: userId);
      await crashlytics.setUserIdentifier(userId);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to set user ID: $e');
      }
    }
  }

  // Set user properties
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    try {
      await analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to set user property: $e');
      }
    }
  }

  // Clear user data (for logout)
  Future<void> clearUserData() async {
    try {
      await analytics.setUserId(id: null);
      await crashlytics.setUserIdentifier('');
    } catch (e) {
      if (kDebugMode) {
        print('Failed to clear user data: $e');
      }
    }
  }

  // Check if user is authenticated
  bool get isAuthenticated {
    return auth.currentUser != null;
  }

  // Get current user
  User? get currentUser {
    return auth.currentUser;
  }

  // Get current user ID
  String? get currentUserId {
    return auth.currentUser?.uid;
  }

  // Dispose resources
  void dispose() {
    _isInitialized = false;
    // Note: Firebase instances don't need explicit disposal
  }
}