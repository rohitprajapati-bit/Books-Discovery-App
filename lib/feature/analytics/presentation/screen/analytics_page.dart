import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/responsive_layout.dart';
import '../bloc/analytics_bloc.dart';
import '../bloc/analytics_state.dart';
import '../layouts/mobile_analytics_screen.dart';
import '../layouts/tablet_analytics_screen.dart';
import '../layouts/desktop_analytics_screen.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Insights')),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          if (state is AnalyticsLoading) {
            return Center(
              child: Lottie.network(
                'https://assets2.lottiefiles.com/packages/lf20_a2chheio.json',
                height: 200,
                errorBuilder: (context, e, s) =>
                    const CircularProgressIndicator(),
              ),
            );
          }

          if (state is AnalyticsLoaded) {
            if (state.totalBooks == 0) {
              return _buildEmptyState();
            }
            return ResponsiveLayout(
              mobileBody: MobileAnalyticsScreen(state: state),
              tabletBody: TabletAnalyticsScreen(state: state),
              desktopBody: DesktopAnalyticsScreen(state: state),
            );
          }

          if (state is AnalyticsError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
            'https://lottie.host/5e263074-6725-4c03-88ee-14c1d7373f13/2p2sswCqwY.json', // Updated working Lottie URL
            height: 250,
            repeat: false,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.search_off, size: 80, color: Colors.grey);
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'No search data yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start searching for books to see your insights!',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
