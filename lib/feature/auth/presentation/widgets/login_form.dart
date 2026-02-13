import 'dart:developer';

import 'package:flutter/material.dart';

import 'email_field.dart';
import 'login_button.dart';
import 'password_field.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EmailTextField(controller: emailController),

        const SizedBox(height: 16),

        PasswordTextField(controller: passwordController),

        const SizedBox(height: 24),

        LoginButton(
          onPressed: () {
            log('press button');
          },
        ),
      ],
    );
  }
}
