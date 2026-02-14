import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:books_discovery_app/core/router/routes.gr.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:books_discovery_app/feature/home/presentation/bloc/home_bloc.dart';
import 'package:books_discovery_app/feature/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:books_discovery_app/feature/analytics/presentation/bloc/analytics_state.dart';
import 'package:books_discovery_app/feature/home/presentation/widgets/search_bar_widget.dart';
import 'package:books_discovery_app/feature/home/presentation/widgets/search_history_widget.dart';
import 'package:books_discovery_app/feature/home/presentation/widgets/book_list_widget.dart';
import 'package:books_discovery_app/feature/home/presentation/widgets/book_grid_widget.dart';
import 'package:books_discovery_app/feature/analytics/presentation/widgets/trending_books_section.dart';

class MobileHomeScreen extends StatelessWidget {
  const MobileHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Discovery')),
      body: Column(
        children: [
          const SearchBarWidget(),
          const SearchHistoryWidget(),
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, homeState) {
                if (homeState is HomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (homeState is HomeSuccess) {
                  return homeState.viewMode == HomeViewMode.list
                      ? BookListWidget(books: homeState.books)
                      : BookGridWidget(books: homeState.books);
                } else if (homeState is HomeFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${homeState.message}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Optionally retry last search or just clear
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // Empty State: Show Trending Books + Lottie Animation
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
                      const SizedBox(height: 40),
                      Lottie.network(
                        'https://assets5.lottiefiles.com/packages/lf20_tmsiddoc.json', // Reading/Books animation
                        height: 200,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.library_books,
                          size: 100,
                          color: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Search for your favorite books!',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.router.push(const QRScannerRoute());
        },
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan Book'),
      ),
    );
  }
}
