import 'package:books_discovery_app/feature/contacts/domain/entities/contact_entity.dart';

abstract class ContactsRepository {
  Future<List<ContactEntity>> getContacts();
}
