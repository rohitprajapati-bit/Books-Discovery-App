import 'package:flutter/material.dart';


class AuthSubtitle extends StatelessWidget {
  final String text;

  const AuthSubtitle({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.grey[600],
          ),
    );
  }
}
