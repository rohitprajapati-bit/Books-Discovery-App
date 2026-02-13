import 'package:flutter/material.dart';
import '../../../../utils/responsive_layout.dart';
import '../layouts/desktop_login_screen.dart';
import '../layouts/mobile_login_screen.dart';
import '../layouts/tablet_login_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: MobileLoginScreen(),
      tabletBody: TabletLoginScreen(),
      desktopBody: DesktopLoginScreen(),
    );
  }
}
