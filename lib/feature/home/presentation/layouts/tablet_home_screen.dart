import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:books_discovery_app/feature/home/presentation/bloc/home_bloc.dart';
import 'package:books_discovery_app/feature/home/presentation/widgets/search_bar_widget.dart';
import 'package:books_discovery_app/feature/home/presentation/widgets/search_history_widget.dart';
import 'package:books_discovery_app/feature/home/presentation/widgets/book_list_widget.dart';
import 'package:books_discovery_app/feature/home/presentation/widgets/book_grid_widget.dart';

class TabletHomeScreen extends StatelessWidget {
  const TabletHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Discovery - Tablet')),
      body: Row(
        children: [
          // Left side: Search and History
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const SearchBarWidget(),
                const Expanded(child: SearchHistoryWidget()),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          // Right side: Results
          Expanded(
            flex: 3,
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HomeSuccess) {
                  return state.viewMode == HomeViewMode.list
                      ? BookListWidget(books: state.books)
                      : BookGridWidget(books: state.books, crossAxisCount: 3);
                } else if (state is HomeFailure) {
                  return Center(child: Text('Error: ${state.message}'));
                }

                return const Center(
                  child: Text('Search for books to see results here.'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
