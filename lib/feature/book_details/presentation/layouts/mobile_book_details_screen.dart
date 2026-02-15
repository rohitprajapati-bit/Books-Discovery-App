import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../feature/home/domain/entities/book.dart';
import '../widgets/book_details_components.dart';

class MobileBookDetailsScreen extends StatelessWidget {
  final Book book;

  const MobileBookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildAISection(context),
          const SizedBox(height: 24),
          _buildMetadataSection(context),
          const SizedBox(height: 24),
          _buildAuthorRecommendations(context),
          const SizedBox(height: 24),
          _buildPreviewButton(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookCoverImage(
            imageUrl: book.thumbnailUrl,
            heroTag: 'book-image-${book.id}',
            height: 180,
            width: 120,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: BookHeaderDetails(
              title: book.title,
              authors: book.authors,
              categories: book.categories,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAISection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const AISummarySection(),
    );
  }

  Widget _buildMetadataSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PublisherInfoList(book: book),
          const Divider(height: 32),
          BookDescriptionSection(description: book.description),
        ],
      ),
    );
  }

  Widget _buildAuthorRecommendations(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: AuthorRecommendationsList(
        height: 180,
        itemWidth: 100,
        imageHeight: 120,
      ),
    );
  }

  Widget _buildPreviewButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BookPreviewButton(previewLink: book.previewLink),
    );
  }
}
