import 'package:books_discovery_app/feature/auth/presentation/widgets/auth_title.dart';
import 'package:flutter/material.dart';
import '../widgets/auth_subtitle.dart';
import '../widgets/login_form.dart';
import '../widgets/sign_with_google_button.dart';

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({super.key});

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.menu_book_rounded,
                      size: 64,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 16),

                    const AuthTitle(title: 'Welcome Back'),
                    const SizedBox(height: 8),
                    const AuthSubtitle(
                      text: 'Discover your next favorite book.',
                    ),

                    const SizedBox(height: 32),

                    LoginForm(
                      emailController: _emailController,
                      passwordController: _passwordController,
                    ),

                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password
                      },
                      child: const Text('Forgot Password?'),
                    ),

                    const SizedBox(height: 16),
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 50,
                    //   child: OutlinedButton.icon(
                    //     onPressed: () {},
                    //     icon: const Icon(Icons.g_mobiledata, size: 30),
                    //     label: const Text('Sign in with Google'),
                    //     style: OutlinedButton.styleFrom(
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12),
                    //       ),
                    //     ),
                    //   ),
                    // ),

   SignWithGoogleButton(),
                    const Divider(height: 32),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
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
