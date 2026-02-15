import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../shared/widgets/auth_title.dart';
import '../../shared/widgets/auth_subtitle.dart';
import '../widgets/login_form.dart';

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    const AuthTitle(title: 'Welcome Back'),
                    const SizedBox(height: 8),
                    const AuthSubtitle(
                      text: 'Discover your next favorite book.',
                    ),
                    const SizedBox(height: 32),
                    const LoginForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
