import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/router/routes.gr.dart';
import '../bloc/book_details_bloc.dart';
import '../bloc/book_details_state.dart';
import '../../../../feature/home/domain/entities/book.dart';

import 'package:lottie/lottie.dart';

class DesktopBookDetailsScreen extends StatelessWidget {
  final Book book;

  const DesktopBookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          physics: const BouncingScrollPhysics(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Cover Image & Preview Button
              SizedBox(
                width: 300,
                child: Column(
                  children: [
                    Hero(
                      tag: 'book-image-${book.id}',
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            book.thumbnailUrl?.replaceFirst(
                                  'http://',
                                  'https://',
                                ) ??
                                '',
                            height: 450,
                            width: 300,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.book, size: 150),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (book.previewLink != null)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final uri = Uri.parse(book.previewLink!);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Read Preview'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 60),

              // Right Column: Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'By ${book.authors.join(', ')}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 24),
                    if (book.categories != null)
                      Wrap(
                        spacing: 12,
                        children: book.categories!
                            .map(
                              (c) => Chip(
                                label: Text(c),
                                backgroundColor: Colors.blue.withValues(
                                  alpha: 0.1,
                                ),
                                side: BorderSide.none,
                              ),
                            )
                            .toList(),
                      ),
                    const SizedBox(height: 40),
                    _buildAISection(context),
                    const SizedBox(height: 40),
                    _buildMetadataSection(context),
                    const SizedBox(height: 40),
                    _buildAuthorRecommendations(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAISection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade50, Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
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
                size: 32,
              ),
              const SizedBox(width: 16),
              Text(
                'AI Smart Summary',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          BlocBuilder<BookDetailsBloc, BookDetailsState>(
            builder: (context, state) {
              if (state is BookDetailsLoading) {
                return Center(
                  child: Column(
                    children: [
                      Lottie.network(
                        'https://assets9.lottiefiles.com/packages/lf20_p1qiuawe.json',
                        height: 150,
                        errorBuilder: (context, error, stackTrace) =>
                            const CircularProgressIndicator(),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Generating summary...',
                        style: TextStyle(
                          color: Colors.deepPurple.withValues(alpha: 0.6),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is BookDetailsLoaded) {
                return Text(
                  state.aiSummary,
                  style: const TextStyle(
                    fontSize: 18,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Publisher Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(height: 16),
                  _metadataRow(
                    Icons.business,
                    'Publisher',
                    book.publisher ?? 'N/A',
                  ),
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
                ],
              ),
            ),
            const SizedBox(width: 40),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(height: 16),
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _metadataRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.grey),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87, fontSize: 18),
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
              const Text(
                'More by this Author',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.authorBooks.length,
                  itemBuilder: (context, index) {
                    final otherBook = state.authorBooks[index];
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          context.router.push(
                            BookDetailsRoute(book: otherBook),
                          );
                        },
                        child: Container(
                          width: 150,
                          margin: const EdgeInsets.only(right: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  otherBook.thumbnailUrl?.replaceFirst(
                                        'http://',
                                        'https://',
                                      ) ??
                                      '',
                                  height: 200,
                                  width: 150,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.book, size: 100),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                otherBook.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
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
}
