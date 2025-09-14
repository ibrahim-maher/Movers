// ===================================
// modules/auth/controllers/register_controller.dart - FIXED
// ===================================
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../shared/services/firebase/firebase_service.dart';
import '../../../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class RegisterController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  late final AuthService _authService;

  // Form controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;
  final RxBool acceptTerms = false.obs;
  final RxString fullNameError = ''.obs;
  final RxString emailError = ''.obs;
  final RxString phoneError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString confirmPasswordError = ''.obs;

  // NEW: Observable for password strength
  final RxDouble passwordStrength = 0.0.obs;
  final RxString passwordStrengthText = 'very_weak'.obs;
  final Rx<Color> passwordStrengthColor = Colors.grey.obs;

  @override
  void onInit() {
    super.onInit();
    _authService = AuthService();

    // Add listeners for real-time validation and password strength
    passwordController.addListener(_updatePasswordStrength);
  }

  // NEW: Update password strength when password changes
  void _updatePasswordStrength() {
    final password = passwordController.text;

    if (password.isEmpty) {
      passwordStrength.value = 0.0;
      passwordStrengthText.value = 'very_weak';
      passwordStrengthColor.value = Colors.grey;
      return;
    }

    double strength = 0.0;

    // Length check
    if (password.length >= 8) strength += 0.2;
    if (password.length >= 12) strength += 0.1;

    // Character variety checks
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.1;

    passwordStrength.value = strength.clamp(0.0, 1.0);

    // Update text and color based on strength
    if (strength == 0.0) {
      passwordStrengthText.value = 'very_weak';
      passwordStrengthColor.value = Colors.grey;
    } else if (strength < 0.3) {
      passwordStrengthText.value = 'weak';
      passwordStrengthColor.value = Colors.red;
    } else if (strength < 0.7) {
      passwordStrengthText.value = 'fair';
      passwordStrengthColor.value = Colors.orange;
    } else if (strength < 0.9) {
      passwordStrengthText.value = 'good';
      passwordStrengthColor.value = Colors.yellow;
    } else {
      passwordStrengthText.value = 'strong';
      passwordStrengthColor.value = Colors.green;
    }
  }

  @override
  void onClose() {
    passwordController.removeListener(_updatePasswordStrength);
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  // Toggle accept terms
  void toggleAcceptTerms(bool? value) {
    acceptTerms.value = value ?? false;
  }

  // Validate full name
  String? validateFullName(String? value) {
    fullNameError.value = '';

    if (value == null || value.isEmpty) {
      fullNameError.value = 'Full name is required';
      return fullNameError.value;
    }

    if (value.trim().length < 2) {
      fullNameError.value = 'Full name must be at least 2 characters';
      return fullNameError.value;
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      fullNameError.value = 'Full name can only contain letters and spaces';
      return fullNameError.value;
    }

    return null;
  }

  // Validate email
  String? validateEmail(String? value) {
    emailError.value = '';

    if (value == null || value.isEmpty) {
      emailError.value = 'Email is required';
      return emailError.value;
    }

    if (!GetUtils.isEmail(value)) {
      emailError.value = 'Please enter a valid email address';
      return emailError.value;
    }

    return null;
  }

  // Validate phone (optional)
  String? validatePhone(String? value) {
    phoneError.value = '';

    if (value != null && value.isNotEmpty) {
      // Remove all non-digit characters for validation
      String digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

      if (digitsOnly.length < 10) {
        phoneError.value = 'Please enter a valid phone number';
        return phoneError.value;
      }
    }

    return null;
  }

  // Validate password
  String? validatePassword(String? value) {
    passwordError.value = '';

    if (value == null || value.isEmpty) {
      passwordError.value = 'Password is required';
      return passwordError.value;
    }

    if (value.length < 8) {
      passwordError.value = 'Password must be at least 8 characters';
      return passwordError.value;
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      passwordError.value = 'Password must contain at least one uppercase letter';
      return passwordError.value;
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      passwordError.value = 'Password must contain at least one lowercase letter';
      return passwordError.value;
    }

    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      passwordError.value = 'Password must contain at least one number';
      return passwordError.value;
    }

    return null;
  }

  // Validate confirm password
  String? validateConfirmPassword(String? value) {
    confirmPasswordError.value = '';

    if (value == null || value.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      return confirmPasswordError.value;
    }

    if (value != passwordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
      return confirmPasswordError.value;
    }

    return null;
  }

  // Clear all errors
  void clearErrors() {
    fullNameError.value = '';
    emailError.value = '';
    phoneError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
  }

  // UPDATED: These methods now use the reactive variables
  double getPasswordStrength() {
    return passwordStrength.value;
  }

  String getPasswordStrengthText() {
    return passwordStrengthText.value;
  }

  Color getPasswordStrengthColor() {
    return passwordStrengthColor.value;
  }

  // Register with email and password
  Future<void> registerWithEmailAndPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (!acceptTerms.value) {
      Get.snackbar(
        'terms_required'.tr,
        'please_accept_terms'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      clearErrors();

      final fullName = fullNameController.text.trim();
      final email = emailController.text.trim();
      final phone = phoneController.text.trim();
      final password = passwordController.text.trim();

      // Create user with Firebase Auth
      final credential = await _firebaseService.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Update Firebase Auth profile
        await credential.user!.updateDisplayName(fullName);

        // Create user document in Firestore
        final userModel = UserModel(
          id: credential.user!.uid,
          email: email,
          displayName: fullName,
          phoneNumber: phone,
          photoURL: '',
          emailVerified: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _authService.createUserDocument(userModel);

        // Send email verification
        await credential.user!.sendEmailVerification();

        // Log analytics event if available
        try {
          await _firebaseService.logEvent(
            name: 'sign_up_success',
            parameters: {
              'method': 'email_password',
            },
          );
        } catch (e) {
          // Analytics logging failed, but continue
          print('Analytics logging failed: $e');
        }

        // Show success message
        Get.snackbar(
          'registration_successful'.tr,
          'welcome_verify_email'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );

        // Navigate to login or home based on your flow
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'weak-password':
          errorMessage = 'weak_password_error';
          passwordError.value = errorMessage.tr;
          break;
        case 'email-already-in-use':
          errorMessage = 'email_already_exists';
          emailError.value = errorMessage.tr;
          break;
        case 'invalid-email':
          errorMessage = 'invalid_email_error';
          emailError.value = errorMessage.tr;
          break;
        case 'operation-not-allowed':
          errorMessage = 'email_auth_disabled';
          break;
        case 'network-request-failed':
          errorMessage = 'network_error';
          break;
        default:
          errorMessage = 'registration_error';
      }

      Get.snackbar(
        'registration_failed'.tr,
        errorMessage.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // Log error if available
      try {
        await _firebaseService.logError(
          exception: e,
          reason: 'Registration failed',
        );
      } catch (logError) {
        print('Error logging failed: $logError');
      }

    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'unexpected_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      print('Registration error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Register with Google
  Future<void> registerWithGoogle() async {
    if (!acceptTerms.value) {
      Get.snackbar(
        'terms_required'.tr,
        'please_accept_terms'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final result = await _authService.signInWithGoogle();

      if (result != null) {
        // Log analytics event if available
        try {
          await _firebaseService.logEvent(
            name: 'sign_up_success',
            parameters: {
              'method': 'google',
            },
          );
        } catch (e) {
          print('Analytics logging failed: $e');
        }

        Get.snackbar(
          'registration_successful'.tr,
          'welcome'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to home
        Get.offAllNamed(AppRoutes.HOME);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage = 'account_exists_different_method';
          break;
        case 'invalid-credential':
          errorMessage = 'invalid_credential';
          break;
        case 'operation-not-allowed':
          errorMessage = 'google_auth_disabled';
          break;
        case 'user-disabled':
          errorMessage = 'account_disabled';
          break;
        default:
          errorMessage = 'google_registration_failed';
      }

      Get.snackbar(
        'google_registration_failed'.tr,
        errorMessage.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

    } catch (e) {
      if (e.toString().contains('sign_in_canceled')) {
        // User canceled the sign-in
        return;
      }

      Get.snackbar(
        'error'.tr,
        'google_registration_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      print('Google registration error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Navigate to login page
  void goToLogin() {
    Get.offNamed(AppRoutes.LOGIN);
  }

  // Show terms and conditions
  void showTermsAndConditions() {
    Get.defaultDialog(
      title: 'terms_and_conditions'.tr,
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'terms_intro'.tr,
                style: Get.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'terms_point_1'.tr,
                style: Get.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'terms_point_2'.tr,
                style: Get.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'terms_point_3'.tr,
                style: Get.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'terms_point_4'.tr,
                style: Get.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
      textConfirm: 'accept'.tr,
      textCancel: 'cancel'.tr,
      onConfirm: () {
        acceptTerms.value = true;
        Get.back();
      },
      onCancel: () {
        acceptTerms.value = false;
        Get.back();
      },
    );
  }

  // Show privacy policy
  void showPrivacyPolicy() {
    Get.defaultDialog(
      title: 'privacy_policy'.tr,
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'privacy_intro'.tr,
                style: Get.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'information_we_collect'.tr,
                style: Get.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'privacy_point_1'.tr,
                style: Get.textTheme.bodySmall,
              ),
              Text(
                'privacy_point_2'.tr,
                style: Get.textTheme.bodySmall,
              ),
              Text(
                'privacy_point_3'.tr,
                style: Get.textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Text(
                'privacy_conclusion'.tr,
                style: Get.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
      textConfirm: 'ok'.tr,
      onConfirm: () => Get.back(),
    );
  }
}

// ===================================
// Missing Dependencies - Add these files
// ===================================

// modules/auth/services/auth_service.dart
/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current user
  User? get currentUser => _auth.currentUser;

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Create user document if it doesn't exist
      if (userCredential.user != null) {
        await _createOrUpdateUserDocument(userCredential.user!);
      }

      return userCredential;
    } catch (e) {
      throw e;
    }
  }

  // Create user document in Firestore
  Future<void> createUserDocument(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  // Create or update user document
  Future<void> _createOrUpdateUserDocument(User user) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final userModel = UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        phoneNumber: user.phoneNumber ?? '',
        photoURL: user.photoURL ?? '',
        emailVerified: user.emailVerified,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await createUserDocument(userModel);
    } else {
      // Update last login
      await docRef.update({
        'updatedAt': DateTime.now().toIso8601String(),
      });
    }
  }
}
*/

// modules/auth/models/user_model.dart
/*
class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String phoneNumber;
  final String photoURL;
  final bool emailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    required this.phoneNumber,
    required this.photoURL,
    required this.emailVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'emailVerified': emailVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoURL: map['photoURL'] ?? '',
      emailVerified: map['emailVerified'] ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
    );
  }
}
*/