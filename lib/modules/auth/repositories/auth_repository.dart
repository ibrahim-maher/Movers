import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../../../shared/services/storage/local_storage_service.dart';
import '../../../shared/services/firebase/firebase_service.dart';
import '../../../core/constants/storage_keys.dart';

class AuthRepository {
  final AuthService _authService;
  final LocalStorageService _storageService;
  final FirebaseService _firebaseService;

  AuthRepository({
    required AuthService authService,
    required LocalStorageService storageService,
    required FirebaseService firebaseService,
  }) : _authService = authService,
        _storageService = storageService,
        _firebaseService = firebaseService;

  // Auth State Stream
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  // Current User
  User? get currentUser => _authService.currentUser;

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential?.user != null) {
        await _cacheAuthData(credential!.user!);
        await _firebaseService.logEvent(
          name: 'login_success',
          parameters: {'method': 'email_password'},
        );
      }

      return credential;
    } catch (e) {
      await _firebaseService.logError(
        exception: e,
        reason: 'Login failed in repository',
      );
      rethrow;
    }
  }

  // Create user with email and password
  Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    String? phoneNumber,
  }) async {
    try {
      final credential = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential?.user != null) {
        // Update Firebase Auth profile
        await credential!.user!.updateDisplayName(displayName);

        // Create user document in Firestore
        final userModel = UserModel(
          id: credential.user!.uid,
          email: email,
          displayName: displayName,
          phoneNumber: phoneNumber ?? '',
          photoURL: '',
          emailVerified: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _authService.createUserDocument(userModel);
        await _cacheUserData(userModel);
        await _cacheAuthData(credential.user!);

        // Send email verification
        await credential.user!.sendEmailVerification();

        await _firebaseService.logEvent(
          name: 'sign_up_success',
          parameters: {'method': 'email_password'},
        );
      }

      return credential;
    } catch (e) {
      await _firebaseService.logError(
        exception: e,
        reason: 'Registration failed in repository',
      );
      rethrow;
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final credential = await _authService.signInWithGoogle();

      if (credential?.user != null) {
        await _cacheAuthData(credential!.user!);
        await _firebaseService.logEvent(
          name: 'login_success',
          parameters: {'method': 'google'},
        );
      }

      return credential;
    } catch (e) {
      await _firebaseService.logError(
        exception: e,
        reason: 'Google sign-in failed in repository',
      );
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      await _clearLocalAuthData();
      await _firebaseService.logEvent(name: 'user_logout');
    } catch (e) {
      await _firebaseService.logError(
        exception: e,
        reason: 'Sign out failed in repository',
      );
      rethrow;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
      await _firebaseService.logEvent(
        name: 'password_reset_requested',
        parameters: {'method': 'email'},
      );
    } catch (e) {
      await _firebaseService.logError(
        exception: e,
        reason: 'Password reset failed in repository',
      );
      rethrow;
    }
  }

  // Get user data
  Future<UserModel?> getUserData(String userId) async {
    try {
      // Try to get from cache first
      final cachedUser = await _getCachedUserData();
      if (cachedUser != null && cachedUser.id == userId) {
        return cachedUser;
      }

      // Get from Firestore
      final userData = await _authService.getUserData(userId);
      if (userData != null) {
        await _cacheUserData(userData);
      }

      return userData;
    } catch (e) {
      await _firebaseService.logError(
        exception: e,
        reason: 'Failed to get user data in repository',
      );
      rethrow;
    }
  }

  // Get user data stream
  Stream<UserModel?> getUserDataStream(String userId) {
    return _authService.getUserDataStream(userId);
  }

  // Update user profile
  Future<void> updateUserProfile(UserModel userModel) async {
    try {
      await _authService.updateUserDocument(userModel);
      await _cacheUserData(userModel);

      // Update Firebase Auth profile if needed
      final user = _authService.currentUser;
      if (user != null) {
        await user.updateDisplayName(userModel.displayName);
        await user.updatePhotoURL(userModel.photoURL);
      }

      await _firebaseService.logEvent(name: 'profile_updated');
    } catch (e) {
      await _firebaseService.logError(
        exception: e,
        reason: 'Profile update failed in repository',
      );
      rethrow;
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        await _authService.deleteUserDocument(user.uid);
        await user.delete();
        await _clearLocalAuthData();
        await _firebaseService.logEvent(name: 'account_deleted');
      }
    } catch (e) {
      await _firebaseService.logError(
        exception: e,
        reason: 'Account deletion failed in repository',
      );
      rethrow;
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await _authService.sendEmailVerification();
      await _firebaseService.logEvent(name: 'verification_email_sent');
    } catch (e) {
      await _firebaseService.logError(
        exception: e,
        reason: 'Email verification failed in repository',
      );
      rethrow;
    }
  }

  // Reload current user
  Future<void> reloadCurrentUser() async {
    try {
      await _authService.reloadCurrentUser();
      final user = _authService.currentUser;
      if (user != null) {
        await _cacheAuthData(user);
      }
    } catch (e) {
      await _firebaseService.logError(
        exception: e,
        reason: 'User reload failed in repository',
      );
      rethrow;
    }
  }

  // Re-authenticate with email and password
  Future<void> reauthenticateWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _authService.reauthenticateWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      await _firebaseService.logError(
        exception: e,
        reason: 'Re-authentication failed in repository',
      );
      rethrow;
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _authService.updatePassword(newPassword);
      await _firebaseService.logEvent(name: 'password_updated');
    } catch (e) {
      await _firebaseService.logError(
        exception: e,
        reason: 'Password update failed in repository',
      );
      rethrow;
    }
  }

  // Update email
  Future<void> updateEmail(String newEmail) async {
    try {
      await _authService.updateEmail(newEmail);

      // Update cached data
      final user = _authService.currentUser;
      if (user != null) {
        await _cacheAuthData(user);
        await _storageService.setString(StorageKeys.userEmail, newEmail);
      }

      await _firebaseService.logEvent(name: 'email_updated');
    } catch (e) {
      await _firebaseService.logError(
        exception: e,
        reason: 'Email update failed in repository',
      );
      rethrow;
    }
  }

  // Check if user is authenticated
  bool get isAuthenticated => _authService.currentUser != null;

  // Check if email is verified
  bool get isEmailVerified => _authService.currentUser?.emailVerified ?? false;

  // Get current user ID
  String? get currentUserId => _authService.currentUser?.uid;

  // Get current user email
  String? get currentUserEmail => _authService.currentUser?.email;

  // Check auth state from cache
  Future<bool> isLoggedInFromCache() async {
    return await _storageService.getBool(StorageKeys.isLoggedIn) ?? false;
  }

  // Get cached user data
  Future<UserModel?> _getCachedUserData() async {
    try {
      final userData = _storageService.getMap(StorageKeys.cachedUserData);
      if (userData != null) {
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Cache user data locally
  Future<void> _cacheUserData(UserModel user) async {
    try {
      await _storageService.setMap(StorageKeys.cachedUserData, user.toJson());
      await _storageService.setString(StorageKeys.userId, user.id);
      await _storageService.setString(StorageKeys.userEmail, user.email);
      await _storageService.setString(StorageKeys.userName, user.displayName);
    } catch (e) {
      print('Error caching user data: $e');
    }
  }

  // Cache auth data
  Future<void> _cacheAuthData(User user) async {
    try {
      await _storageService.setBool(StorageKeys.isLoggedIn, true);
      await _storageService.setString(StorageKeys.userId, user.uid);
      await _storageService.setString(StorageKeys.userEmail, user.email ?? '');

      // Get user token for API calls
      final token = await user.getIdToken();
      await _storageService.setString(StorageKeys.userToken, token!);
    } catch (e) {
      print('Error caching auth data: $e');
    }
  }

  // Clear local auth data
  Future<void> _clearLocalAuthData() async {
    try {
      await _storageService.remove(StorageKeys.isLoggedIn);
      await _storageService.remove(StorageKeys.userToken);
      await _storageService.remove(StorageKeys.refreshToken);
      await _storageService.remove(StorageKeys.userId);
      await _storageService.remove(StorageKeys.userEmail);
      await _storageService.remove(StorageKeys.userName);
      await _storageService.remove(StorageKeys.cachedUserData);
    } catch (e) {
      print('Error clearing local auth data: $e');
    }
  }
}