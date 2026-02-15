import 'package:bloc/bloc.dart';
import '../../domain/usecases/update_profile_picture_usecase.dart';
import '../../domain/usecases/update_profile_name_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

import 'package:books_discovery_app/feature/auth/presentation/bloc/auth_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateProfilePictureUseCase updateProfilePictureUseCase;
  final UpdateProfileNameUseCase updateProfileNameUseCase;
  final AuthBloc authBloc;

  ProfileBloc({
    required this.updateProfilePictureUseCase,
    required this.updateProfileNameUseCase,
    required this.authBloc,
  }) : super(ProfileInitial()) {
    on<UpdateProfilePictureRequested>(_onUpdateProfilePicture);
    on<UpdateProfileNameRequested>(_onUpdateProfileName);
  }

  Future<void> _onUpdateProfilePicture(
    UpdateProfilePictureRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final user = await updateProfilePictureUseCase.execute(event.filePath);
      authBloc.add(AuthUserChanged(user));
      emit(ProfileUpdateSuccess(user));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onUpdateProfileName(
    UpdateProfileNameRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final user = await updateProfileNameUseCase.execute(event.newName);
      authBloc.add(AuthUserChanged(user));
      emit(ProfileUpdateSuccess(user));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }
}
