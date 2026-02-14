import 'package:books_discovery_app/feature/contacts/domain/entities/contact_entity.dart';
import 'package:books_discovery_app/feature/contacts/domain/repositories/contacts_repository.dart';

class GetContactsUseCase {
  final ContactsRepository repository;

  GetContactsUseCase(this.repository);

  Future<List<ContactEntity>> execute() async {
    return await repository.getContacts();
  }
}
