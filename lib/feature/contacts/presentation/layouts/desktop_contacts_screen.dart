import 'package:flutter/material.dart';
import '../../domain/entities/contact_entity.dart';
import '../widgets/contact_card.dart';
import '../widgets/my_profile_tile.dart';
import '../widgets/no_contacts_view.dart';
import '../widgets/contact_detail_bottom_sheet.dart';

class DesktopContactsScreen extends StatelessWidget {
  final List<ContactEntity> contacts;

  const DesktopContactsScreen({super.key, required this.contacts});

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return const Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: MyProfileTile(),
          ),
          Expanded(child: NoContactsView()),
        ],
      );
    }

    return CustomScrollView(
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          sliver: SliverToBoxAdapter(child: MyProfileTile()),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              mainAxisExtent: 80,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final contact = contacts[index];
              return ContactCard(
                contact: contact,
                onTap: () => _showContactDetails(context, contact),
              );
            }, childCount: contacts.length),
          ),
        ),
      ],
    );
  }

  void _showContactDetails(BuildContext context, ContactEntity contact) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ContactDetailBottomSheet(contact: contact),
        ),
      ),
    );
  }
}
