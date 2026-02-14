import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:books_discovery_app/core/di/injection_container.dart';
import 'package:books_discovery_app/feature/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:books_discovery_app/feature/contacts/presentation/bloc/contacts_event.dart';
import 'package:books_discovery_app/feature/contacts/presentation/bloc/contacts_state.dart';
import 'package:books_discovery_app/utils/responsive_layout.dart';
import '../layouts/mobile_contacts_screen.dart';
import '../layouts/tablet_contacts_screen.dart';
import '../layouts/desktop_contacts_screen.dart';

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
              return ResponsiveLayout(
                mobileBody: MobileContactsScreen(contacts: state.contacts),
                tabletBody: TabletContactsScreen(contacts: state.contacts),
                desktopBody: DesktopContactsScreen(contacts: state.contacts),
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
              onPressed: onRetry,
              child: Text(
                isSystemSettings ? 'Open Settings' : 'Request Permission',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
