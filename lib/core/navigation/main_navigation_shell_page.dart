import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../router/routes.gr.dart';
import 'widgets/bottom_nav_bar.dart';

@RoutePage()
class MainNavigationShellPage extends StatelessWidget {
  const MainNavigationShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HomeTabRoute(),
        AnalyticsTabRoute(),
        ContactsTabRoute(),
        ProfileTabRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
          ),
        );
      },
    );
  }
}
