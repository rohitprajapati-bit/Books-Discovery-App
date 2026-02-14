import 'package:equatable/equatable.dart';

abstract class ContactsEvent extends Equatable {
  const ContactsEvent();

  @override
  List<Object?> get props => [];
}

class RequestContactsPermission extends ContactsEvent {}

class FetchContacts extends ContactsEvent {}
