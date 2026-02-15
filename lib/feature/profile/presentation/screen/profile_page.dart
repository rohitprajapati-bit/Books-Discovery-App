import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:books_discovery_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:books_discovery_app/utils/responsive_layout.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../layouts/mobile_profile_screen.dart';
import '../layouts/desktop_profile_screen.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();

  // Animation controllers
  late final AnimationController _sizeController;
  late final Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();

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
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (!mounted) return;
    if (image != null) {
      context.read<ProfileBloc>().add(
        UpdateProfilePictureRequested(image.path),
      );
    } else {}
  }

  void _onEditName(String newName) {
    context.read<ProfileBloc>().add(UpdateProfileNameRequested(newName));
  }

  void _onLogout() {
    context.read<AuthBloc>().add(const AuthLogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile'), centerTitle: true),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoading) {}
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully!')),
            );
            // Directly update the AuthBloc with the new user object to force a UI refresh
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
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              final user = state.user;
              return ResponsiveLayout(
                mobileBody: MobileProfileScreen(
                  user: user,
                  onPickImage: _pickImage,
                  onEditName: _onEditName,
                  onLogout: _onLogout,
                  sizeAnimation: _sizeAnimation,
                ),
                tabletBody: DesktopProfileScreen(
                  user: user,
                  onPickImage: _pickImage,
                  onEditName: _onEditName,
                  onLogout: _onLogout,
                  sizeAnimation: _sizeAnimation,
                ),
                desktopBody: DesktopProfileScreen(
                  user: user,
                  onPickImage: _pickImage,
                  onEditName: _onEditName,
                  onLogout: _onLogout,
                  sizeAnimation: _sizeAnimation,
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
    );
  }
}
