import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:books_discovery_app/core/router/routes.gr.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:books_discovery_app/feature/home/presentation/bloc/home_bloc.dart';
import 'package:books_discovery_app/feature/home/presentation/widgets/search_bar_widget.dart';
import 'package:books_discovery_app/feature/home/presentation/widgets/search_history_widget.dart';
import 'package:books_discovery_app/feature/home/presentation/widgets/book_list_widget.dart';
import 'package:books_discovery_app/feature/home/presentation/widgets/book_grid_widget.dart';
import '../widgets/home_empty_state_widget.dart';

class MobileHomeScreen extends StatelessWidget {
  const MobileHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Discovery')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SearchBarWidget(),
            const SearchHistoryWidget(),
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, homeState) {
                  Widget content;
                  if (homeState is HomeLoading) {
                    content = const Center(
                      key: ValueKey('loading'),
                      child: CircularProgressIndicator(),
                    );
                  } else if (homeState is HomeSuccess) {
                    content = homeState.viewMode == HomeViewMode.grid
                        ? BookListWidget(
                            key: const ValueKey('list'),
                            books: homeState.books,
                          )
                        : BookGridWidget(
                            key: const ValueKey('grid'),
                            books: homeState.books,
                          );
                  } else if (homeState is HomeFailure) {
                    content = Center(
                      key: const ValueKey('error'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${homeState.message}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              log('click retry');
                              context.read<HomeBloc>().add(RetryHomeEvent());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    content = const HomeEmptyStateWidget(
                      key: ValueKey('empty'),
                    );
                  }

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    child: content,
                  );
                },
              ),
            ),
          ],
        ),
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
