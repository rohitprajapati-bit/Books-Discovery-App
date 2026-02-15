import 'package:flutter/material.dart';
import '../../domain/entities/contact_entity.dart';
import '../widgets/contact_detail_bottom_sheet.dart';

/// Shows the contact details using either a Dialog (for desktop) or BottomSheet (for mobile/tablet).
void showContactDetails(
  BuildContext context,
  ContactEntity contact, {
  bool useDialog = false,
}) {
  if (useDialog) {
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
  } else {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ContactDetailBottomSheet(contact: contact),
    );
  }
}
