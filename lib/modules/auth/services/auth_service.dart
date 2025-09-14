import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   scopes: [
  //     'email',
  //     'https://www.googleapis.com/auth/userinfo.profile',
  //   ],
  // );

  // Collections
  static const String usersCollection = 'users';

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } catch (e) {
      rethrow;
    }
  }

  // Create user with email and password
  Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {

  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        // _googleSignIn.signOut(),
      ]);
    } catch (e) {
      rethrow;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      rethrow;
    }
  }

  // Reload current user
  Future<void> reloadCurrentUser() async {
    try {
      await _auth.currentUser?.reload();
    } catch (e) {
      rethrow;
    }
  }

  // Update user password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
    } catch (e) {
      rethrow;
    }
  }

  // Update user email
  Future<void> updateEmail(String newEmail) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.verifyBeforeUpdateEmail(newEmail);
      } else {
        throw Exception('No user is currently signed in');
      }
    } catch (e) {
      rethrow;
    }
  }
  // Delete current user
  Future<void> deleteCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Delete user document from Firestore
        await deleteUserDocument(user.uid);

        // Delete Firebase Auth user
        await user.delete();
      }
    } catch (e) {
      rethrow;
    }
  }

  // Create user document in Firestore
  Future<void> createUserDocument(UserModel userModel) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(userModel.id)
          .set(userModel.toFirestore());
    } catch (e) {
      rethrow;
    }
  }

  // Create or update user document
  Future<void> createOrUpdateUserDocument(UserModel userModel) async {
    try {
      final docRef = _firestore.collection(usersCollection).doc(userModel.id);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Update existing document
        await docRef.update({
          'email': userModel.email,
          'displayName': userModel.displayName,
          'phoneNumber': userModel.phoneNumber,
          'photoURL': userModel.photoURL,
          'emailVerified': userModel.emailVerified,
          'updatedAt': Timestamp.fromDate(userModel.updatedAt),
        });
      } else {
        // Create new document
        await docRef.set(userModel.toFirestore());
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get user document from Firestore
  Future<UserModel?> getUserData(String userId) async {
    try {
      final docSnapshot = await _firestore
          .collection(usersCollection)
          .doc(userId)
          .get();

      if (docSnapshot.exists) {
        return UserModel.fromDocumentSnapshot(docSnapshot);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Update user document in Firestore
  Future<void> updateUserDocument(UserModel userModel) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(userModel.id)
          .update(userModel.toFirestore());
    } catch (e) {
      rethrow;
    }
  }

  // Delete user document from Firestore
  Future<void> deleteUserDocument(String userId) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(userId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  // Check if user document exists
  Future<bool> userDocumentExists(String userId) async {
    try {
      final docSnapshot = await _firestore
          .collection(usersCollection)
          .doc(userId)
          .get();

      return docSnapshot.exists;
    } catch (e) {
      return false;
    }
  }

  // Get user document stream
  Stream<UserModel?> getUserDataStream(String userId) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromDocumentSnapshot(snapshot);
      }
      return null;
    });
  }

  // Re-authenticate user with email and password
  Future<void> reauthenticateWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Re-authenticate user with Google
  Future<void> reauthenticateWithGoogle() async {

  }

  // Link Google account
  Future<UserCredential?> linkWithGoogle() async {

  }

  // Unlink provider
  Future<User?> unlinkProvider(String providerId) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return await user.unlink(providerId);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Get linked providers
  List<String> getLinkedProviders() {
    final user = _auth.currentUser;
    if (user != null) {
      return user.providerData.map((info) => info.providerId).toList();
    }
    return [];
  }
}