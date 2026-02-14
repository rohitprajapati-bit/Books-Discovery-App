import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:books_discovery_app/feature/home/presentation/bloc/home_bloc.dart';
import 'package:books_discovery_app/utils/responsive_layout.dart';
import 'package:books_discovery_app/feature/home/presentation/layouts/desktop_home_screen.dart';
import 'package:books_discovery_app/feature/home/presentation/layouts/mobile_home_screen.dart';
import 'package:books_discovery_app/feature/home/presentation/layouts/tablet_home_screen.dart';

import 'package:books_discovery_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:books_discovery_app/feature/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:books_discovery_app/feature/analytics/presentation/bloc/analytics_event.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          final userId = state.user.id;
          context.read<HomeBloc>().add(LoadSearchHistoryEvent(userId));
          context.read<AnalyticsBloc>().add(LoadAnalyticsEvent(userId));
        }
      },
      child: const ResponsiveLayout(
        mobileBody: MobileHomeScreen(),
        tabletBody: TabletHomeScreen(),
        desktopBody: DesktopHomeScreen(),
      ),
    );
  }
}
