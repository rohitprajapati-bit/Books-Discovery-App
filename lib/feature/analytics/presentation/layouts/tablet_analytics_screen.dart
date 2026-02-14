import 'package:flutter/material.dart';
import '../widgets/genre_distribution_chart.dart';
import '../widgets/publishing_trends_chart.dart';
import '../widgets/trending_books_section.dart';
import '../widgets/analytics_summary_cards.dart';
import '../bloc/analytics_state.dart';

class TabletAnalyticsScreen extends StatelessWidget {
  final AnalyticsLoaded state;

  const TabletAnalyticsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Charts side by side
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GenreDistributionChart(
                  distribution: state.genreDistribution,
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: PublishingTrendsChart(trends: state.publishingTrends),
              ),
            ],
          ),
          const SizedBox(height: 32),
          AnalyticsSummaryCards(state: state),
          const SizedBox(height: 32),
          TrendingBooksSection(trending: state.trendingBooks),
        ],
      ),
    );
  }
}
