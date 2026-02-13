import 'package:flutter/material.dart';

class DesktopHomeScreen extends StatelessWidget {
  const DesktopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desktop Home'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: const Center(child: Text('Side Menu')),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Desktop View'),
                  Icon(Icons.desktop_windows, size: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
