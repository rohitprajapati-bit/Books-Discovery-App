import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:books_discovery_app/core/router/routes.gr.dart';
import 'package:books_discovery_app/feature/home/domain/entities/book.dart';
import '../bloc/book_details_bloc.dart';
import '../bloc/book_details_state.dart';
import 'package:lottie/lottie.dart';

class TabletBookDetailsScreen extends StatelessWidget {
  final Book book;

  const TabletBookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    // For tablet, we can just constrain the width to keep readability
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildAISection(context),
              const SizedBox(height: 32),
              _buildMetadataSection(context),
              const SizedBox(height: 32),
              _buildAuthorRecommendations(context),
              const SizedBox(height: 32),
              _buildPreviewButton(context),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'book-image-${book.id}',
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  book.thumbnailUrl?.replaceFirst('http://', 'https://') ?? '',
                  height: 220, // Larger image for tablet
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.book, size: 120),
                ),
              ),
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Text(
                  'By ${book.authors.join(', ')}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                if (book.categories != null)
                  Wrap(
                    spacing: 12,
                    children: book.categories!
                        .map(
                          (c) => Chip(
                            label: Text(
                              c,
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: Colors.blue.withValues(alpha: 0.1),
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAISection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade50, Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Colors.deepPurple,
                size: 28,
              ),
              const SizedBox(width: 16),
              Text(
                'AI Smart Summary',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          BlocBuilder<BookDetailsBloc, BookDetailsState>(
            builder: (context, state) {
              if (state is BookDetailsLoading) {
                return Center(
                  child: Column(
                    children: [
                      Lottie.network(
                        'https://assets9.lottiefiles.com/packages/lf20_p1qiuawe.json',
                        height: 120,
                        errorBuilder: (context, error, stackTrace) =>
                            const CircularProgressIndicator(),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Generating summary...',
                        style: TextStyle(
                          color: Colors.deepPurple.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is BookDetailsLoaded) {
                return Text(
                  state.aiSummary,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                );
              } else if (state is BookDetailsError) {
                return const Text('AI Summary unavailable right now.');
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Publisher Details',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 16),
          _metadataRow(Icons.business, 'Publisher', book.publisher ?? 'N/A'),
          _metadataRow(
            Icons.calendar_month,
            'Published Date',
            book.publishedDate ?? 'N/A',
          ),
          _metadataRow(
            Icons.auto_stories,
            'Page Count',
            '${book.pageCount ?? 'N/A'}',
          ),
          const Divider(height: 48),
          const Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 12),
          Text(
            book.description ?? 'No official description available.',
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metadataRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorRecommendations(BuildContext context) {
    return BlocBuilder<BookDetailsBloc, BookDetailsState>(
      builder: (context, state) {
        if (state is BookDetailsLoaded && state.authorBooks.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'More by this Author',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: state.authorBooks.length,
                  itemBuilder: (context, index) {
                    final otherBook = state.authorBooks[index];
                    return GestureDetector(
                      onTap: () {
                        context.router.push(BookDetailsRoute(book: otherBook));
                      },
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                otherBook.thumbnailUrl?.replaceFirst(
                                      'http://',
                                      'https://',
                                    ) ??
                                    '',
                                height: 160,
                                width: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.book, size: 80),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              otherBook.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildPreviewButton(BuildContext context) {
    if (book.previewLink == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: () async {
            final uri = Uri.parse(book.previewLink!);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          icon: const Icon(Icons.open_in_new),
          label: const Text('Read Preview', style: TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
