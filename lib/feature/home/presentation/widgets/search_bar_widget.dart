import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch() {
    log('SearchBarWidget: _onSearch called with value: ${_controller.text}');
    if (_controller.text.isNotEmpty) {
      context.read<HomeBloc>().add(SearchBooksEvent(_controller.text));
    } else {
      log('SearchBarWidget: Search query is empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search books, authors...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_controller.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _controller.clear();
                          });
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.blueAccent),
                      onPressed: _onSearch,
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                // To show/hide clear button
                setState(() {});
              },
              onSubmitted: (_) => _onSearch(),
            ),
          ),
          const SizedBox(width: 8),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.viewMode == HomeViewMode.list
                      ? Icons.grid_view
                      : Icons.view_list,
                ),
                onPressed: () {
                  context.read<HomeBloc>().add(ToggleViewModeEvent());
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
