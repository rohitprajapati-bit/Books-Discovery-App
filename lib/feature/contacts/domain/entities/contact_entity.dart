import 'package:equatable/equatable.dart';

class ContactEntity extends Equatable {
  final String displayName;
  final String? phoneNumber;
  final String? email;
  final String? avatar; // Base64 or path to image if needed

  const ContactEntity({
    required this.displayName,
    this.phoneNumber,
    this.email,
    this.avatar,
  });

  @override
  List<Object?> get props => [displayName, phoneNumber, email, avatar];
}
