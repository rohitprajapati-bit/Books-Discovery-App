import 'package:flutter/material.dart';
import '../widgets/genre_distribution_chart.dart';
import '../widgets/publishing_trends_chart.dart';
import '../widgets/trending_books_section.dart';
import '../widgets/analytics_summary_cards.dart';
import '../bloc/analytics_state.dart';

class MobileAnalyticsScreen extends StatelessWidget {
  final AnalyticsLoaded state;

  const MobileAnalyticsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenreDistributionChart(distribution: state.genreDistribution),
          const SizedBox(height: 32),
          PublishingTrendsChart(trends: state.publishingTrends),
          const SizedBox(height: 32),
          TrendingBooksSection(trending: state.trendingBooks),
          const SizedBox(height: 32),
          AnalyticsSummaryCards(state: state),
        ],
      ),
    );
  }
}
