import '../../../auth/domain/entities/user.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> updateProfilePicture(String filePath) async {
    try {
      return await remoteDataSource.updateProfilePicture(filePath);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to update profile picture');
    }
  }

  @override
  Future<User> updateProfileName(String newName) async {
    try {
      return await remoteDataSource.updateProfileName(newName);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to update profile name');
    }
  }
}
