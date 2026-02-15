import 'package:flutter/material.dart';
import '../../shared/widgets/auth_subtitle.dart';
import '../widgets/login_form.dart';

class DesktopLoginScreen extends StatefulWidget {
  const DesktopLoginScreen({super.key});

  @override
  State<DesktopLoginScreen> createState() => _DesktopLoginScreenState();
}

class _DesktopLoginScreenState extends State<DesktopLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const NetworkImage(
                    'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.4),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.import_contacts_sharp,
                      size: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Explore a World of Knowledge',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your personal library, curated just for you.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Right Side: Login Form
          Expanded(
            flex: 1,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 64.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const AuthSubtitle(
                      text: 'Please enter your details to sign in.',
                    ),

                    const SizedBox(height: 48),

                    const LoginForm(),

                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Forgot Password?'),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
