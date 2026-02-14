import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> updateProfilePicture(String filePath) async {
    return await remoteDataSource.updateProfilePicture(filePath);
  }

  @override
  Future<User> updateProfileName(String newName) async {
    return await remoteDataSource.updateProfileName(newName);
  }
}
