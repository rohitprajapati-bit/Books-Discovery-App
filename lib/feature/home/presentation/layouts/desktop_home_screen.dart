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

class DesktopHomeScreen extends StatelessWidget {
  const DesktopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Discovery - Desktop'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Scan QR Code'),
                  content: const Text(
                    'For the best experience, please use the mobile app to scan book QR codes. Desktop cameras are often difficult to position correctly.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.router.push(const QRScannerRoute());
                      },
                      child: const Text('Try Anyway'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan Book',
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar: Search History
          Container(
            width: 300,
            color: Colors.grey[50],
            child: const Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'History',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Expanded(child: SearchHistoryWidget()),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          // Main Content: Search Bar and Results
          Expanded(
            child: Column(
              children: [
                const SearchBarWidget(),
                Expanded(
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
                                crossAxisCount: 4,
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
        ],
      ),
    );
  }
}
