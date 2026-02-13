import 'package:flutter/material.dart';
import '../../shared/widgets/auth_subtitle.dart';
import '../../shared/widgets/auth_title.dart';
import '../widgets/signup_form.dart';

class TabletSignupScreen extends StatelessWidget {
  const TabletSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person_add_alt_1_rounded,
                      size: 80,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 24),
                    const AuthTitle(title: 'Create Account'),
                    const SizedBox(height: 8),
                    const AuthSubtitle(
                      text: 'Sign up to start your collection on tablet.',
                    ),
                    const SizedBox(height: 40),

                    const SignupForm(),

                    const SizedBox(height: 16),
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
