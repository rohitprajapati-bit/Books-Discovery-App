import 'dart:developer' as dev;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  });
  Future<UserModel> signInWithGoogle();
  Future<void> logout();
  Future<UserModel> updateProfilePicture(String filePath);
  Future<UserModel> updateProfileName(String newName);
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.firestore,
    required this.storage,
  });

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Login failed: No user returned');
      }

      return UserModel.fromFirebaseUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e.code));
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Registration failed: No user returned');
      }

      // Update display name in Firebase Auth
      await credential.user!.updateDisplayName(name);
      await credential.user!.reload();
      final updatedUser = firebaseAuth.currentUser;

      if (updatedUser == null) {
        throw Exception('Failed to get updated user');
      }

      // Save user data to Firestore
      await _saveUserToFirestore(
        uid: updatedUser.uid,
        email: email,
        name: name,
      );

      return UserModel.fromFirebaseUser(updatedUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e.code));
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google Sign-In was cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );

      if (userCredential.user == null) {
        throw Exception('Google Sign-In failed: No user returned');
      }

      // Save/update user data to Firestore
      await _saveUserToFirestore(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email ?? '',
        name: userCredential.user!.displayName ?? 'User',
      );

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e.code));
    } catch (e) {
      throw Exception('Google Sign-In failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await Future.wait([firebaseAuth.signOut(), googleSignIn.signOut()]);
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> updateProfilePicture(String filePath) async {
    dev.log(
      'Starting profile picture update (Local Fallback). File: $filePath',
      name: 'AuthRemoteDataSource',
    );
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        dev.log('Error - No user logged in', name: 'AuthRemoteDataSource');
        throw Exception('No user logged in');
      }

      // LOCAL FALLBACK: Instead of Storage, we save it in App Documents
      final appDocDir = await getApplicationDocumentsDirectory();
      final profilePicsDir = Directory(p.join(appDocDir.path, 'profile_pics'));

      if (!await profilePicsDir.exists()) {
        await profilePicsDir.create(recursive: true);
        dev.log('Created profile_pics directory', name: 'AuthRemoteDataSource');
      }

      // Delete previous local profile pictures to avoid space build-up and force refresh
      if (await profilePicsDir.exists()) {
        final files = profilePicsDir.listSync();
        for (var file in files) {
          if (file is File &&
              p.basename(file.path).startsWith('profile_${user.uid}')) {
            try {
              await file.delete();
              dev.log(
                'Deleted old profile pic: ${file.path}',
                name: 'AuthRemoteDataSource',
              );
            } catch (e) {
              dev.log(
                'Failed to delete old profile pic: $e',
                name: 'AuthRemoteDataSource',
              );
            }
          }
        }
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'profile_${user.uid}_$timestamp${p.extension(filePath)}';
      final localPath = p.join(profilePicsDir.path, fileName);

      dev.log('Copying file to: $localPath', name: 'AuthRemoteDataSource');
      // Copy the picked file to our permanent local storage
      final savedFile = await File(filePath).copy(localPath);
      final photoUrl = savedFile.path; // Use the local absolute path

      dev.log('Saved locally at: $photoUrl', name: 'AuthRemoteDataSource');

      dev.log(
        'Updating user photoURL in FirebaseAuth',
        name: 'AuthRemoteDataSource',
      );
      await user.updatePhotoURL(photoUrl);

      dev.log('Reloading user', name: 'AuthRemoteDataSource');
      await user.reload();

      final updatedUser = firebaseAuth.currentUser;
      dev.log(
        'Updated photoURL in Auth: ${updatedUser?.photoURL}',
        name: 'AuthRemoteDataSource',
      );

      dev.log('Updating Firestore record', name: 'AuthRemoteDataSource');
      await _updateUserInFirestore(uid: user.uid, photoUrl: photoUrl);
      dev.log('Firestore updated successfully', name: 'AuthRemoteDataSource');

      if (updatedUser == null) throw Exception('User is null after reload');
      return UserModel.fromFirebaseUser(updatedUser);
    } catch (e, stack) {
      dev.log(
        'Error updating profile picture (Local Fallback)',
        name: 'AuthRemoteDataSource',
        error: e,
        stackTrace: stack,
      );
      throw Exception(
        'Failed to update profile picture locally: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserModel> updateProfileName(String newName) async {
    dev.log(
      'Starting profile name update to: $newName',
      name: 'AuthRemoteDataSource',
    );
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        dev.log('Error - No user logged in', name: 'AuthRemoteDataSource');
        throw Exception('No user logged in');
      }

      dev.log(
        'Updating display name in FirebaseAuth',
        name: 'AuthRemoteDataSource',
      );
      await user.updateDisplayName(newName);

      dev.log('Reloading user', name: 'AuthRemoteDataSource');
      await user.reload();

      final updatedUser = firebaseAuth.currentUser;
      dev.log(
        'Updated name in Auth: ${updatedUser?.displayName}',
        name: 'AuthRemoteDataSource',
      );

      dev.log('Updating Firestore record', name: 'AuthRemoteDataSource');
      await _updateUserInFirestore(uid: user.uid, name: newName);
      dev.log('Firestore updated successfully', name: 'AuthRemoteDataSource');

      if (updatedUser == null) throw Exception('User is null after reload');
      return UserModel.fromFirebaseUser(updatedUser);
    } catch (e, stack) {
      dev.log(
        'Error updating profile name',
        name: 'AuthRemoteDataSource',
        error: e,
        stackTrace: stack,
      );
      throw Exception('Failed to update profile name: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().map((user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }

  /// Save user data to Firestore
  Future<void> _saveUserToFirestore({
    required String uid,
    required String email,
    required String name,
  }) async {
    try {
      await firestore.collection('users').doc(uid).set({
        'id': uid,
        'email': email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save user data: ${e.toString()}');
    }
  }

  /// Update user data in Firestore
  Future<void> _updateUserInFirestore({
    required String uid,
    String? name,
    String? photoUrl,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (name != null) data['name'] = name;
      if (photoUrl != null) data['photoUrl'] = photoUrl;

      await firestore
          .collection('users')
          .doc(uid)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to update user data: ${e.toString()}');
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'Email is already registered';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      default:
        return 'Authentication error occurred';
    }
  }
}
