import 'package:flutter/material.dart';

class SignInLinkButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SignInLinkButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text("Already have an account?"),
        TextButton(onPressed: onPressed, child: const Text('Sign In')),
      ],
    );
  }
}
