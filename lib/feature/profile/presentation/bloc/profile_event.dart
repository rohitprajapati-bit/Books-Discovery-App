import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfilePictureRequested extends ProfileEvent {
  final String filePath;

  const UpdateProfilePictureRequested(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class UpdateProfileNameRequested extends ProfileEvent {
  final String newName;

  const UpdateProfileNameRequested(this.newName);

  @override
  List<Object?> get props => [newName];
}
