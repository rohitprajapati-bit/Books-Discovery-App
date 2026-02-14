import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileNameUseCase {
  final ProfileRepository repository;

  UpdateProfileNameUseCase(this.repository);

  Future<User> execute(String newName) async {
    return await repository.updateProfileName(newName);
  }
}
