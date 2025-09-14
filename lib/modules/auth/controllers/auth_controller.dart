// auth_controller.dart
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../shared/services/firebase/firebase_service.dart';
import '../../../shared/services/storage/local_storage_service.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../routes/app_routes.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final LocalStorageService _storageService = Get.find<LocalStorageService>();
  late final AuthRepository _authRepository;

  // Observable variables
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initRepository();
    _initAuthListener();
  }

  // Initialize repository
  void _initRepository() {
    _authRepository = Get.find<AuthRepository>();
  }

  // Initialize auth state listener
  void _initAuthListener() {
    firebaseUser.bindStream(_authRepository.authStateChanges);
    ever(firebaseUser, _handleAuthChanged);
  }

  // Handle authentication state changes
  void _handleAuthChanged(User? user) async {
    if (user != null) {
      // User is signed in
      isAuthenticated.value = true;
      await _loadUserData(user);

      // Set user for Firebase services
      await _firebaseService.setUserId(user.uid);

      // Navigate to home if not already there
      if (Get.currentRoute != AppRoutes.HOME) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed(AppRoutes.HOME);
        });
      }
    } else {
      // User is signed out
      isAuthenticated.value = false;
      currentUser.value = null;
      await _firebaseService.clearUserData();

      // Navigate to login if not already there
      if (Get.currentRoute != AppRoutes.LOGIN) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed(AppRoutes.LOGIN);
        });
      }
    }
  }

  // Load user data
  Future<void> _loadUserData(User user) async {
    try {
      final userData = await _authRepository.getUserData(user.uid);
      if (userData != null) {
        currentUser.value = userData;
      }
    } catch (e) {
      print('Error loading user data: $e');
      await _firebaseService.logError(
        exception: e,
        reason: 'Failed to load user data',
      );
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _authRepository.signOut();

      Get.snackbar(
        'Success'.tr,
        'Signed out successfully'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to sign out: ${e.toString()}'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      await _authRepository.deleteAccount();

      Get.snackbar(
        'Success'.tr,
        'Account deleted successfully'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to delete account: ${e.toString()}'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? photoURL,
  }) async {
    try {
      isLoading.value = true;

      if (currentUser.value != null) {
        final updatedUser = currentUser.value!.copyWith(
          displayName: displayName ?? currentUser.value!.displayName,
          phoneNumber: phoneNumber ?? currentUser.value!.phoneNumber,
          photoURL: photoURL ?? currentUser.value!.photoURL,
          updatedAt: DateTime.now(),
        );

        await _authRepository.updateUserProfile(updatedUser);
        currentUser.value = updatedUser;

        Get.snackbar(
          'Success'.tr,
          'Profile updated successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to update profile: ${e.toString()}'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await _authRepository.sendEmailVerification();

      Get.snackbar(
        'Success'.tr,
        'Verification email sent'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to send verification email: ${e.toString()}'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Reload user
  Future<void> reloadUser() async {
    try {
      await _authRepository.reloadCurrentUser();
      if (firebaseUser.value != null) {
        await _loadUserData(firebaseUser.value!);
      }
    } catch (e) {
      print('Error reloading user: $e');
    }
  }

  // Getters
  bool get userExists => currentUser.value != null;
  bool get isEmailVerified => _authRepository.isEmailVerified;
  String? get userId => _authRepository.currentUserId;
  String? get userEmail => _authRepository.currentUserEmail;
  String? get userDisplayName => currentUser.value?.displayName;
}