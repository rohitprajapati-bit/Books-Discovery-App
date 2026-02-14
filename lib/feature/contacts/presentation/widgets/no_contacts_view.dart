import 'package:flutter/material.dart';

class NoContactsView extends StatelessWidget {
  const NoContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_search_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No contacts found',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Try adding contacts to your device.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
