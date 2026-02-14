import 'package:flutter/material.dart';

class TopSearchTermsWidget extends StatelessWidget {
  final Map<String, int> terms;

  const TopSearchTermsWidget({super.key, required this.terms});

  @override
  Widget build(BuildContext context) {
    if (terms.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.search, color: Colors.blueAccent),
            const SizedBox(width: 8),
            const Text(
              'Top Search Terms',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: terms.entries.map((entry) {
            return Chip(
              label: Text('${entry.key} (${entry.value})'),
              backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
              side: BorderSide.none,
              labelStyle: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
