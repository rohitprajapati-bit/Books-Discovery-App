import 'package:flutter/material.dart';
import 'package:books_discovery_app/feature/auth/domain/entities/user.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_section.dart';

class MobileProfileScreen extends StatelessWidget {
  final User user;
  final VoidCallback onPickImage;
  final Function(String) onEditName;
  final VoidCallback onLogout;
  final Animation<double> sizeAnimation;

  const MobileProfileScreen({
    super.key,
    required this.user,
    required this.onPickImage,
    required this.onEditName,
    required this.onLogout,
    required this.sizeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            ProfileHeader(
              user: user,
              onPickImage: onPickImage,
              onEditName: onEditName,
            ),
            const SizedBox(height: 40),
            SizeTransition(
              sizeFactor: sizeAnimation,
              axis: Axis.vertical,
              child: Column(
                children: [
                  ProfileInfoSection(user: user),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: onLogout,
                      icon: const Icon(Icons.logout, color: Colors.redAccent),
                      label: const Text(
                        'Sign Out',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(
                            color: Colors.redAccent,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
