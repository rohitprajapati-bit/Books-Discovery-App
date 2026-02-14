import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login({required String email, required String password});

  Future<User> register({
    required String email,
    required String password,
    required String name,
  });

  Future<User> signInWithGoogle();

  Future<void> logout();

  Future<User> updateProfilePicture(String filePath);

  Future<User> updateProfileName(String newName);

  Future<User?> getCurrentUser();

  Stream<User?> get authStateChanges;
}
