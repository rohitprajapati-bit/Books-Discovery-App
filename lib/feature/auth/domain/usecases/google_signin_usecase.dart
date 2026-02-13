import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GoogleSignInUseCase {
  final AuthRepository repository;

  GoogleSignInUseCase(this.repository);

  Future<User> call() async {
    return await repository.signInWithGoogle();
  }
}
