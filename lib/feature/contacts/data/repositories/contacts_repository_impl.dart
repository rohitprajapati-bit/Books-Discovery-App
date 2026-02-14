import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:books_discovery_app/feature/contacts/data/models/contact_model.dart';
import 'package:books_discovery_app/feature/contacts/domain/entities/contact_entity.dart';
import 'package:books_discovery_app/feature/contacts/domain/repositories/contacts_repository.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  @override
  Future<List<ContactEntity>> getContacts() async {
    // flutter_contacts handles its own fetching logic.
    // We assume permission is granted as handled in the BLoC.
    List<Contact> contacts = await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: false,
    );

    return contacts.map((c) => ContactModel.fromFlutterContacts(c)).toList();
  }
}
