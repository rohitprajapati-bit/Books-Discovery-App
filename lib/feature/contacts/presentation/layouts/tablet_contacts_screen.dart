import 'package:flutter/material.dart';
import '../../domain/entities/contact_entity.dart';
import '../widgets/contact_card.dart';
import '../widgets/my_profile_tile.dart';
import '../widgets/no_contacts_view.dart';
import '../widgets/contact_detail_bottom_sheet.dart';

class TabletContactsScreen extends StatelessWidget {
  final List<ContactEntity> contacts;

  const TabletContactsScreen({super.key, required this.contacts});

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            MyProfileTile(),
            Expanded(child: NoContactsView()),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          sliver: SliverToBoxAdapter(child: MyProfileTile()),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ContactDetailBottomSheet(contact: contact),
    );
  }
}
