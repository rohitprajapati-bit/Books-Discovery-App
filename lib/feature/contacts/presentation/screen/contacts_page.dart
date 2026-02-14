import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:books_discovery_app/core/di/injection_container.dart';
import 'package:books_discovery_app/feature/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:books_discovery_app/feature/contacts/presentation/bloc/contacts_event.dart';
import 'package:books_discovery_app/feature/contacts/presentation/bloc/contacts_state.dart';
import 'package:books_discovery_app/feature/contacts/presentation/widgets/contact_detail_bottom_sheet.dart';

import '../../../../core/router/routes.gr.dart';

@RoutePage()
class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late final ContactsBloc _contactsBloc;

  @override
  void initState() {
    super.initState();
    _contactsBloc = sl<ContactsBloc>();
    _contactsBloc.add(RequestContactsPermission());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _contactsBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),
        body: BlocBuilder<ContactsBloc, ContactsState>(
          builder: (context, state) {
            if (state is ContactsLoading || state is ContactsInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ContactsLoaded) {
              if (state.contacts.isEmpty) {
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildMyProfileTile(context),
                    const SizedBox(height: 100),
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_search_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No contacts found',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Try adding contacts to your device.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.contacts.length + 1, // +1 for the profile tile
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildMyProfileTile(context);
                  }
                  final contact = state.contacts[index - 1];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.1),
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent.withValues(
                          alpha: 0.1,
                        ),
                        child: Text(
                          contact.displayName.isNotEmpty
                              ? contact.displayName[0].toUpperCase()
                              : "?",
                          style: const TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                      title: Text(contact.displayName),
                      subtitle: Text(
                        contact.phoneNumber ?? contact.email ?? "No details",
                      ),
                      onTap: () => _showContactDetails(context, contact),
                    ),
                  );
                },
              );
            } else if (state is ContactsPermissionDenied) {
              return _buildPermissionError(
                'Permission Denied',
                'We need contact permissions to show your list.',
                onRetry: () => _contactsBloc.add(RequestContactsPermission()),
              );
            } else if (state is ContactsPermissionPermanentlyDenied) {
              return _buildPermissionError(
                'Permission Permanently Denied',
                'Please enable contacts permission in system settings.',
                isSystemSettings: true,
              );
            } else if (state is ContactsError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildMyProfileTile(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          tileColor: Colors.blueAccent.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          leading: const CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: const Text(
            'My Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('View and edit your profile'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Navigate to profile tab
            context.navigateTo(const ProfileTabRoute());
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'ALL CONTACTS',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Expanded(child: Divider()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionError(
    String title,
    String message, {
    VoidCallback? onRetry,
    bool isSystemSettings = false,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.contact_phone_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed:
                  onRetry, // In real app, system settings link would be here if isSystemSettings is true
              child: Text(
                isSystemSettings ? 'Open Settings' : 'Request Permission',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactDetails(BuildContext context, contact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ContactDetailBottomSheet(contact: contact),
    );
  }
}
