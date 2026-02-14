import 'dart:developer' as dev;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../auth/data/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/error/exceptions.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> updateProfilePicture(String filePath);
  Future<UserModel> updateProfileName(String newName);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ProfileRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.storage,
  });

  @override
  Future<UserModel> updateProfilePicture(String filePath) async {
    dev.log(
      'Starting profile picture update (Local Fallback). File: $filePath',
      name: 'ProfileRemoteDataSource',
    );
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        dev.log('Error - No user logged in', name: 'ProfileRemoteDataSource');
        throw Exception('No user logged in');
      }

      // LOCAL FALLBACK: Instead of Storage, we save it in App Documents
      final appDocDir = await getApplicationDocumentsDirectory();
      final profilePicsDir = Directory(p.join(appDocDir.path, 'profile_pics'));

      if (!await profilePicsDir.exists()) {
        await profilePicsDir.create(recursive: true);
        dev.log(
          'Created profile_pics directory',
          name: 'ProfileRemoteDataSource',
        );
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
                name: 'ProfileRemoteDataSource',
              );
            } catch (e) {
              dev.log(
                'Failed to delete old profile pic: $e',
                name: 'ProfileRemoteDataSource',
              );
            }
          }
        }
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'profile_${user.uid}_$timestamp${p.extension(filePath)}';
      final localPath = p.join(profilePicsDir.path, fileName);

      dev.log('Copying file to: $localPath', name: 'ProfileRemoteDataSource');
      // Copy the picked file to our permanent local storage
      final savedFile = await File(filePath).copy(localPath);
      final photoUrl = savedFile.path; // Use the local absolute path

      dev.log('Saved locally at: $photoUrl', name: 'ProfileRemoteDataSource');

      dev.log(
        'Updating user photoURL in FirebaseAuth',
        name: 'ProfileRemoteDataSource',
      );
      await user.updatePhotoURL(photoUrl);

      dev.log('Reloading user', name: 'ProfileRemoteDataSource');
      await user.reload();

      final updatedUser = firebaseAuth.currentUser;
      dev.log(
        'Updated photoURL in Auth: ${updatedUser?.photoURL}',
        name: 'ProfileRemoteDataSource',
      );

      dev.log('Updating Firestore record', name: 'ProfileRemoteDataSource');
      await _updateUserInFirestore(uid: user.uid, photoUrl: photoUrl);
      dev.log(
        'Firestore updated successfully',
        name: 'ProfileRemoteDataSource',
      );

      if (updatedUser == null) throw Exception('User is null after reload');
      return UserModel.fromFirebaseUser(updatedUser);
    } catch (e, stack) {
      dev.log(
        'Error updating profile picture (Local Fallback)',
        name: 'ProfileRemoteDataSource',
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
      name: 'ProfileRemoteDataSource',
    );
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        dev.log('Error - No user logged in', name: 'ProfileRemoteDataSource');
        throw Exception('No user logged in');
      }

      dev.log(
        'Updating display name in FirebaseAuth',
        name: 'ProfileRemoteDataSource',
      );
      await user.updateDisplayName(newName);

      dev.log('Reloading user', name: 'ProfileRemoteDataSource');
      await user.reload();

      final updatedUser = firebaseAuth.currentUser;
      dev.log(
        'Updated name in Auth: ${updatedUser?.displayName}',
        name: 'ProfileRemoteDataSource',
      );

      dev.log('Updating Firestore record', name: 'ProfileRemoteDataSource');
      await _updateUserInFirestore(uid: user.uid, name: newName);
      dev.log(
        'Firestore updated successfully',
        name: 'ProfileRemoteDataSource',
      );

      if (updatedUser == null)
        throw ServerException(message: 'User is null after reload');
      return UserModel.fromFirebaseUser(updatedUser);
    } catch (e, stack) {
      dev.log(
        'Error updating profile name',
        name: 'ProfileRemoteDataSource',
        error: e,
        stackTrace: stack,
      );
      throw ServerException(
        message: 'Failed to update profile name',
        code: e.toString(),
      );
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
}
