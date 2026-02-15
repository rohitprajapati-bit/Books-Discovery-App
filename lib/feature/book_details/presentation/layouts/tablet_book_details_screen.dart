import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../feature/home/domain/entities/book.dart';
import '../widgets/book_details_components.dart';

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
          BookCoverImage(
            imageUrl: book.thumbnailUrl,
            heroTag: 'book-image-${book.id}',
            height: 220,
            width: 150,
          ),
          const SizedBox(width: 32),
          Expanded(
            child: BookHeaderDetails(
              title: book.title,
              authors: book.authors,
              categories: book.categories,
              titleStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              authorStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w500,
              ),
              chipFontSize: 12,
              chipPadding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAISection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AISummarySection(
        iconSize: 28,
        titleStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
          fontSize: 22,
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          height: 1.6,
          color: Colors.black87,
        ),
        loadingHeight: 120,
      ),
    );
  }

  Widget _buildMetadataSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PublisherInfoList(
            book: book,
            sectionTitleStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            iconSize: 20,
            labelStyle: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            valueStyle: const TextStyle(color: Colors.black87, fontSize: 16),
          ),
          const Divider(height: 48),
          BookDescriptionSection(
            description: book.description,
            sectionTitleStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorRecommendations(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AuthorRecommendationsList(
        height: 220,
        itemWidth: 120,
        imageHeight: 160,
        sectionTitleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        itemTitleStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPreviewButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: BookPreviewButton(
        previewLink: book.previewLink,
        height: 56,
        textStyle: const TextStyle(fontSize: 18),
        buttonStyle: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
