import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../utils/responsive_layout.dart';
import 'layouts/desktop_signup_screen.dart';
import 'layouts/mobile_signup_screen.dart';
import 'layouts/tablet_signup_screen.dart';

@RoutePage()
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    log('bild');
    return const ResponsiveLayout(
      mobileBody: MobileSignupScreen(),
      tabletBody: TabletSignupScreen(),
      desktopBody: DesktopSignupScreen(),
    );
  }
}
