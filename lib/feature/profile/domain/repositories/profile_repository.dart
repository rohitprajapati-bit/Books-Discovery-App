import '../../../auth/domain/entities/user.dart';

abstract class ProfileRepository {
  Future<User> updateProfilePicture(String filePath);
  Future<User> updateProfileName(String newName);
}
