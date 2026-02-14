import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../feature/auth/presentation/bloc/auth_bloc.dart';
import '../../feature/analytics/presentation/bloc/analytics_bloc.dart';
import '../../feature/analytics/presentation/bloc/analytics_event.dart';
import '../../feature/home/presentation/bloc/home_bloc.dart';
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

        return MultiBlocListener(
          listeners: [
            // Refresh analytics whenever a search successfully completes
            BlocListener<HomeBloc, HomeState>(
              listenWhen: (previous, current) =>
                  current is HomeSuccess && previous is! HomeSuccess,
              listener: (context, state) {
                final authState = context.read<AuthBloc>().state;
                if (authState is Authenticated) {
                  context.read<AnalyticsBloc>().add(
                    LoadAnalyticsEvent(authState.user.id),
                  );
                }
              },
            ),
          ],
          child: Scaffold(
            body: child,
            bottomNavigationBar: BottomNavBar(
              currentIndex: tabsRouter.activeIndex,
              onTap: (index) {
                // Also trigger a refresh when switching to the Analytics tab
                if (index == 1) {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is Authenticated) {
                    context.read<AnalyticsBloc>().add(
                      LoadAnalyticsEvent(authState.user.id),
                    );
                  }
                }
                tabsRouter.setActiveIndex(index);
              },
            ),
          ),
        );
      },
    );
  }
}
