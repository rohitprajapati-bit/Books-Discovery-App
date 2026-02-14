import 'dart:io';
import 'dart:developer' as dev;
import 'package:auto_route/auto_route.dart';
import 'package:books_discovery_app/feature/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:books_discovery_app/core/di/injection_container.dart';
import 'package:books_discovery_app/feature/auth/presentation/bloc/auth_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late final ProfileBloc _profileBloc;
  final ImagePicker _picker = ImagePicker();

  // Animation controllers
  late final AnimationController _sizeController;
  late final Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _profileBloc = sl<ProfileBloc>();

    _sizeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _sizeAnimation = CurvedAnimation(
      parent: _sizeController,
      curve: Curves.easeInOut,
    );

    _sizeController.forward();
  }

  @override
  void dispose() {
    _sizeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    dev.log('Initiating image picker...', name: 'ProfilePage');
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      dev.log('Image picked: ${image.path}', name: 'ProfilePage');
      _profileBloc.add(UpdateProfilePictureRequested(image.path));
    } else {
      dev.log('No image picked', name: 'ProfilePage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _profileBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _showLogoutDialog(context),
            ),
          ],
        ),
        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            dev.log('ProfileBloc state changed: $state', name: 'ProfilePage');
            if (state is ProfileLoading) {
              dev.log('Show loading state...', name: 'ProfilePage');
            }
            if (state is ProfileUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully!')),
              );
              // Directly update the AuthBloc with the new user object to force a UI refresh
              // This ensures the updated name/image is reflected everywhere.
              context.read<AuthBloc>().add(AuthUserChanged(state.user));

              // If it's a name update, we might want to restart the animation
              _sizeController.reset();
              _sizeController.forward();
            } else if (state is ProfileFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Update failed: ${state.message}')),
              );
            }
          },
          child: SingleChildScrollView(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  final user = state.user;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        _buildProfileHeader(user),
                        const SizedBox(height: 40),
                        SizeTransition(
                          sizeFactor: _sizeAnimation,
                          axis: Axis.vertical,
                          child: Column(
                            children: [
                              _buildInfoSection(user),
                              const SizedBox(height: 40),
                              _buildLogoutButton(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Column(
      children: [
        Stack(
          children: [
            Hero(
              tag: 'user_avatar',
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.grey.withValues(alpha: 0.1),
                  backgroundImage: user.photoUrl != null
                      ? (user.photoUrl!.startsWith('http')
                            ? NetworkImage(
                                user.photoUrl!.contains('googleusercontent.com')
                                    ? user.photoUrl!
                                    : '${user.photoUrl}${user.photoUrl!.contains('?') ? '&' : '?'}t=${DateTime.now().millisecondsSinceEpoch}',
                              )
                            : FileImage(File(user.photoUrl!)) as ImageProvider)
                      : null,
                  child: user.photoUrl == null
                      ? Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : null,
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.edit, size: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _showEditNameDialog(context, user.name),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  void _showEditNameDialog(BuildContext context, String currentName) {
    final TextEditingController nameController = TextEditingController(
      text: currentName,
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            hintText: 'Enter your name',
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty && newName != currentName) {
                _profileBloc.add(UpdateProfileNameRequested(newName));
              }
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(dynamic user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'ACCOUNT INFORMATION',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 1.1,
                ),
              ),
              const Spacer(),
              const Icon(Icons.verified_user, size: 16, color: Colors.green),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoRow(Icons.person_outline, 'Name', user.name),
          const Divider(height: 32),
          _buildInfoRow(Icons.email_outlined, 'Email', user.email),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 22, color: Colors.grey.shade400),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () => _showLogoutDialog(context),
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
            side: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to sign out safely?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Me In'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
