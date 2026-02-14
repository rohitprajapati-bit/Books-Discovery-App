import 'package:flutter/material.dart';
import '../../domain/entities/contact_entity.dart';

class ContactCard extends StatelessWidget {
  final ContactEntity contact;
  final VoidCallback onTap;

  const ContactCard({super.key, required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
          child: Text(
            contact.displayName.isNotEmpty
                ? contact.displayName[0].toUpperCase()
                : "?",
            style: const TextStyle(color: Colors.blueAccent),
          ),
        ),
        title: Text(contact.displayName),
        subtitle: Text(contact.phoneNumber ?? contact.email ?? "No details"),
        onTap: onTap,
      ),
    );
  }
}
