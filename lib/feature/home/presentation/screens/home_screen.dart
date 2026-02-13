import 'package:flutter/material.dart';
import '../../../../utils/responsive_layout.dart';
import 'desktop_home_screen.dart';
import 'mobile_home_screen.dart';
import 'tablet_home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: MobileHomeScreen(),
      tabletBody: TabletHomeScreen(),
      desktopBody: DesktopHomeScreen(),
    );
  }
}
