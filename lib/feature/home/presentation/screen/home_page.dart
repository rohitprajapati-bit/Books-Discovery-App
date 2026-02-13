import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:books_discovery_app/feature/home/presentation/bloc/home_bloc.dart';
import 'package:books_discovery_app/utils/responsive_layout.dart';
import 'package:books_discovery_app/feature/home/presentation/layouts/desktop_home_screen.dart';
import 'package:books_discovery_app/feature/home/presentation/layouts/mobile_home_screen.dart';
import 'package:books_discovery_app/feature/home/presentation/layouts/tablet_home_screen.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.instance<HomeBloc>()..add(LoadSearchHistoryEvent()),
      child: const ResponsiveLayout(
        mobileBody: MobileHomeScreen(),
        tabletBody: TabletHomeScreen(),
        desktopBody: DesktopHomeScreen(),
      ),
    );
  }
}
