import 'dart:developer' as dev;
import 'package:bloc/bloc.dart';
import '../../domain/usecases/update_profile_picture_usecase.dart';
import '../../domain/usecases/update_profile_name_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateProfilePictureUseCase updateProfilePictureUseCase;
  final UpdateProfileNameUseCase updateProfileNameUseCase;

  ProfileBloc({
    required this.updateProfilePictureUseCase,
    required this.updateProfileNameUseCase,
  }) : super(ProfileInitial()) {
    on<UpdateProfilePictureRequested>(_onUpdateProfilePicture);
    on<UpdateProfileNameRequested>(_onUpdateProfileName);
  }

  Future<void> _onUpdateProfilePicture(
    UpdateProfilePictureRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    dev.log(
      'Starting profile picture update for path: ${event.filePath}',
      name: 'ProfileBloc',
    );
    try {
      final user = await updateProfilePictureUseCase.execute(event.filePath);
      dev.log(
        'Update success. New photoUrl: ${user.photoUrl}',
        name: 'ProfileBloc',
      );
      emit(ProfileUpdateSuccess(user));
    } catch (e, stack) {
      dev.log(
        'Update failed',
        name: 'ProfileBloc',
        error: e,
        stackTrace: stack,
      );
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onUpdateProfileName(
    UpdateProfileNameRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    dev.log(
      'Starting profile name update to: ${event.newName}',
      name: 'ProfileBloc',
    );
    try {
      final user = await updateProfileNameUseCase.execute(event.newName);
      dev.log('Update success. New name: ${user.name}', name: 'ProfileBloc');
      emit(ProfileUpdateSuccess(user));
    } catch (e, stack) {
      dev.log(
        'Update failed',
        name: 'ProfileBloc',
        error: e,
        stackTrace: stack,
      );
      emit(ProfileFailure(e.toString()));
    }
  }
}
