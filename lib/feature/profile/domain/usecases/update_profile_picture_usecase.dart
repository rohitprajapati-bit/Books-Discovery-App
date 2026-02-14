import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

class UpdateProfilePictureUseCase {
  final ProfileRepository repository;

  UpdateProfilePictureUseCase(this.repository);

  Future<User> execute(String filePath) async {
    return await repository.updateProfilePicture(filePath);
  }
}
