import 'package:flutter/material.dart';
import '../widgets/genre_distribution_chart.dart';
import '../widgets/publishing_trends_chart.dart';
import '../widgets/trending_books_section.dart';
import '../widgets/analytics_summary_cards.dart';
import '../bloc/analytics_state.dart';

class DesktopAnalyticsScreen extends StatelessWidget {
  final AnalyticsLoaded state;

  const DesktopAnalyticsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Charts
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    GenreDistributionChart(
                      distribution: state.genreDistribution,
                    ),
                    const SizedBox(height: 32),
                    PublishingTrendsChart(trends: state.publishingTrends),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              // Right Column: Stats and Trending
              Expanded(
                child: Column(
                  children: [
                    AnalyticsSummaryCards(state: state),
                    const SizedBox(height: 32),
                    TrendingBooksSection(trending: state.trendingBooks),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
