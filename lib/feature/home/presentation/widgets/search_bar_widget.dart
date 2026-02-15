import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:books_discovery_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:image_picker/image_picker.dart';
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

  void _onSearch(String userId) {
    if (_controller.text.isNotEmpty) {
      context.read<HomeBloc>().add(SearchBooksEvent(_controller.text, userId));
    } else {}
  }

  Future<void> _onPickImage(String userId) async {
    final picker = ImagePicker();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        context.read<HomeBloc>().add(
          OCRSearchRequestedEvent(image.path, userId),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final userId = authState is Authenticated ? authState.user.id : '';

        return Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search books, authors...',
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
                        icon: const Icon(
                          Icons.photo_camera,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () => _onPickImage(userId),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () => _onSearch(userId),
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
                  setState(() {});
                },
                onSubmitted: (_) => _onSearch(userId),
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
        );
      },
    );
  }
}
