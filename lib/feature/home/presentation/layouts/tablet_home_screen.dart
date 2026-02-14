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

class TabletHomeScreen extends StatelessWidget {
  const TabletHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Discovery - Tablet'),
        actions: [
          IconButton(
            onPressed: () {
              context.router.push(const QRScannerRoute());
            },
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan Book',
          ),
        ],
      ),
      body: Row(
        children: [
          // Left side: Search and History
          const Expanded(
            flex: 2,
            child: Column(
              children: [
                SearchBarWidget(),
                Expanded(child: SearchHistoryWidget()),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          // Right side: Results
          Expanded(
            flex: 3,
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                Widget content;
                if (state is HomeLoading) {
                  content = const Center(
                    key: ValueKey('loading'),
                    child: CircularProgressIndicator(),
                  );
                } else if (state is HomeSuccess) {
                  content = state.viewMode == HomeViewMode.list
                      ? BookListWidget(
                          key: const ValueKey('list'),
                          books: state.books,
                        )
                      : BookGridWidget(
                          key: const ValueKey('grid'),
                          books: state.books,
                          crossAxisCount: 3,
                        );
                } else if (state is HomeFailure) {
                  content = Center(
                    key: const ValueKey('error'),
                    child: Text('Error: ${state.message}'),
                  );
                } else {
                  content = const Center(
                    key: ValueKey('empty'),
                    child: HomeEmptyStateWidget(),
                  );
                }

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                  child: content,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
