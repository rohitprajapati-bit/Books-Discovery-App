import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../analytics/presentation/bloc/analytics_bloc.dart';
import '../../../analytics/presentation/bloc/analytics_state.dart';
import '../../../analytics/presentation/widgets/trending_books_section.dart';

class HomeEmptyStateWidget extends StatelessWidget {
  const HomeEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
              builder: (context, analyticsState) {
                if (analyticsState is AnalyticsLoaded &&
                    analyticsState.trendingBooks.isNotEmpty) {
                  return TrendingBooksSection(
                    trending: analyticsState.trendingBooks,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          const SizedBox(height: 10),
          Lottie.network(
            'https://assets5.lottiefiles.com/packages/lf20_tmsiddoc.json', // Reading/Books animation
            height: 200,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.library_books, size: 100, color: Colors.grey[300]),
          ),
          const SizedBox(height: 10),
          const Text(
            'Search for your favorite books!',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
