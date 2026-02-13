import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import '../../../../utils/responsive_layout.dart';
import '../layouts/desktop_home_screen.dart';
import '../layouts/mobile_home_screen.dart';
import '../layouts/tablet_home_screen.dart';

@RoutePage()
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
