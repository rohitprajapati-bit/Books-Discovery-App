import 'package:flutter/material.dart';

class ForgotButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ForgotButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text('Forgot Password?'),
    );
  }
}
