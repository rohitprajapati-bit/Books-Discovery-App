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
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // LOCAL FALLBACK: Instead of Storage, we save it in App Documents
      final appDocDir = await getApplicationDocumentsDirectory();
      final profilePicsDir = Directory(p.join(appDocDir.path, 'profile_pics'));

      if (!await profilePicsDir.exists()) {
        await profilePicsDir.create(recursive: true);
      }

      // Delete previous local profile pictures to avoid space build-up and force refresh
      if (await profilePicsDir.exists()) {
        final files = profilePicsDir.listSync();
        for (var file in files) {
          if (file is File &&
              p.basename(file.path).startsWith('profile_${user.uid}')) {
            try {
              await file.delete();
            } catch (e) {
              // Ignore deletion errors for old profile pics
            }
          }
        }
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'profile_${user.uid}_$timestamp${p.extension(filePath)}';
      final localPath = p.join(profilePicsDir.path, fileName);

      // Copy the picked file to our permanent local storage
      final savedFile = await File(filePath).copy(localPath);
      final photoUrl = savedFile.path; // Use the local absolute path

      await user.updatePhotoURL(photoUrl);

      await user.reload();

      final updatedUser = firebaseAuth.currentUser;

      await _updateUserInFirestore(uid: user.uid, photoUrl: photoUrl);

      if (updatedUser == null) throw Exception('User is null after reload');
      return UserModel.fromFirebaseUser(updatedUser);
    } catch (e, stack) {
      throw Exception(
        'Failed to update profile picture locally: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserModel> updateProfileName(String newName) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      await user.updateDisplayName(newName);

      await user.reload();

      final updatedUser = firebaseAuth.currentUser;

      await _updateUserInFirestore(uid: user.uid, name: newName);

      if (updatedUser == null) {
        throw ServerException(message: 'User is null after reload');
      }
      return UserModel.fromFirebaseUser(updatedUser);
    } catch (e) {
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
