import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../feature/home/domain/entities/book.dart';
import '../widgets/book_details_components.dart';

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
                    BookCoverImage(
                      imageUrl: book.thumbnailUrl,
                      heroTag: 'book-image-${book.id}',
                      height: 450,
                      width: 300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    const SizedBox(height: 32),
                    BookPreviewButton(
                      previewLink: book.previewLink,
                      height: 50,
                      buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
                    BookHeaderDetails(
                      title: book.title,
                      authors: book.authors,
                      categories: book.categories,
                      titleStyle: Theme.of(context).textTheme.displaySmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                      authorStyle: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500,
                          ),
                      chipFontSize: 14, // Slightly larger for desktop
                      chipPadding: const EdgeInsets.symmetric(horizontal: 4),
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
    return AISummarySection(
      iconSize: 32,
      titleStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
        fontSize: 24,
      ),
      textStyle: const TextStyle(
        fontSize: 18,
        height: 1.6,
        color: Colors.black87,
      ),
      loadingHeight: 150,
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
              child: PublisherInfoList(
                book: book,
                sectionTitleStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                iconSize: 24,
                labelStyle: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
                valueStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 40),
            Expanded(
              child: BookDescriptionSection(
                description: book.description,
                sectionTitleStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAuthorRecommendations(BuildContext context) {
    return AuthorRecommendationsList(
      height: 250,
      itemWidth: 150,
      imageHeight: 200,
      sectionTitleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      itemTitleStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
