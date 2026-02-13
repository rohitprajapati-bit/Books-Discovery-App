import 'package:flutter/material.dart';
import '../../shared/widgets/auth_title.dart';
import '../../shared/widgets/auth_subtitle.dart';
import '../widgets/signup_form.dart';

class MobileSignupScreen extends StatelessWidget {
  const MobileSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person_add_alt_1_rounded,
                      size: 64,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 16),
                    const AuthTitle(title: 'Create Account'),
                    const SizedBox(height: 8),
                    const AuthSubtitle(text: 'Join us and start your journey.'),

                    const SizedBox(height: 20),

                    const SignupForm(),
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
