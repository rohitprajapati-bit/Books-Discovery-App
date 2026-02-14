import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:books_discovery_app/feature/contacts/domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  const ContactModel({
    required super.displayName,
    super.phoneNumber,
    super.email,
    super.avatar,
  });

  factory ContactModel.fromFlutterContacts(Contact contact) {
    String? phone;
    if (contact.phones.isNotEmpty) {
      phone = contact.phones.first.number;
    }

    String? email;
    if (contact.emails.isNotEmpty) {
      email = contact.emails.first.address;
    }

    return ContactModel(
      displayName: contact.displayName.isNotEmpty
          ? contact.displayName
          : "No Name",
      phoneNumber: phone,
      email: email,
      avatar: null,
    );
  }
}
