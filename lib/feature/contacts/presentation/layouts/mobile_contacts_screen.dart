import 'package:flutter/material.dart';
import '../../domain/entities/contact_entity.dart';
import '../widgets/contact_card.dart';
import '../widgets/my_profile_tile.dart';
import '../widgets/no_contacts_view.dart';
import '../widgets/contact_detail_bottom_sheet.dart';

class MobileContactsScreen extends StatelessWidget {
  final List<ContactEntity> contacts;

  const MobileContactsScreen({super.key, required this.contacts});

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: const [
          MyProfileTile(),
          SizedBox(height: 100),
          NoContactsView(),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: contacts.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const MyProfileTile();
        }
        final contact = contacts[index - 1];
        return ContactCard(
          contact: contact,
          onTap: () => _showContactDetails(context, contact),
        );
      },
    );
  }

  void _showContactDetails(BuildContext context, ContactEntity contact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ContactDetailBottomSheet(contact: contact),
    );
  }
}
