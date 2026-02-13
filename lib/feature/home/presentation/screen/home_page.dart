import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import '../../../../utils/responsive_layout.dart';
import '../layouts/desktop_home_screen.dart';
import '../layouts/mobile_home_screen.dart';
import '../layouts/tablet_home_screen.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: MobileHomeScreen(),
      tabletBody: TabletHomeScreen(),
      desktopBody: DesktopHomeScreen(),
    );
  }
}
