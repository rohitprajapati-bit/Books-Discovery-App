import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/router/routes.gr.dart';
import '../../../../feature/home/domain/entities/book.dart';
import '../bloc/book_details_bloc.dart';
import '../bloc/book_details_state.dart';

// 1. Book Cover Image
class BookCoverImage extends StatelessWidget {
  final String? imageUrl;
  final String heroTag;
  final double height;
  final double width;
  final BorderRadius? borderRadius;

  const BookCoverImage({
    super.key,
    required this.imageUrl,
    required this.heroTag,
    required this.height,
    required this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
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
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          child: Image.network(
            imageUrl?.replaceFirst('http://', 'https://') ?? '',
            height: height,
            width: width,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.book, size: width * 0.5),
          ),
        ),
      ),
    );
  }
}

// 2. Book Title, Author, Categories
class BookHeaderDetails extends StatelessWidget {
  final String title;
  final List<String> authors;
  final List<String>? categories;
  final TextStyle? titleStyle;
  final TextStyle? authorStyle;
  final double chipFontSize;
  final EdgeInsetsGeometry? chipPadding;

  const BookHeaderDetails({
    super.key,
    required this.title,
    required this.authors,
    this.categories,
    this.titleStyle,
    this.authorStyle,
    this.chipFontSize = 10,
    this.chipPadding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              titleStyle ??
              Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          'By ${authors.join(', ')}',
          style:
              authorStyle ??
              Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 12),
        if (categories != null)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories!
                .map(
                  (c) => Chip(
                    label: Text(c, style: TextStyle(fontSize: chipFontSize)),
                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    side: BorderSide.none,
                    padding: chipPadding,
                    visualDensity: VisualDensity.compact,
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

// 3. AI Summary Section
class AISummarySection extends StatelessWidget {
  final double iconSize;
  final TextStyle? titleStyle;
  final TextStyle? textStyle;
  final double loadingHeight;

  const AISummarySection({
    super.key,
    this.iconSize = 24,
    this.titleStyle,
    this.textStyle,
    this.loadingHeight = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      // margin handled by parent to be flexible
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
              Icon(
                Icons.auto_awesome,
                color: Colors.deepPurple,
                size: iconSize,
              ),
              const SizedBox(width: 12),
              Text(
                'AI Smart Summary',
                style:
                    titleStyle ??
                    Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                      fontSize: 18,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<BookDetailsBloc, BookDetailsState>(
            builder: (context, state) {
              if (state is BookDetailsLoading) {
                return Center(
                  child: Column(
                    children: [
                      Lottie.network(
                        'https://assets9.lottiefiles.com/packages/lf20_p1qiuawe.json',
                        height: loadingHeight,
                        errorBuilder: (context, error, stackTrace) =>
                            const CircularProgressIndicator(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Generating summary...',
                        style: TextStyle(
                          color: Colors.deepPurple.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is BookDetailsLoaded) {
                return Text(
                  state.aiSummary,
                  style:
                      textStyle ??
                      const TextStyle(
                        fontSize: 15,
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
}

// 4. Metadata Rows
class MetadataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final double iconSize;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const MetadataRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconSize = 16,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: iconSize, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style:
                labelStyle ??
                const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
          ),
          Expanded(
            child: Text(
              value,
              style: valueStyle ?? const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

// 5. Publisher Info List
class PublisherInfoList extends StatelessWidget {
  final Book book;
  final TextStyle? sectionTitleStyle;
  final double iconSize;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const PublisherInfoList({
    super.key,
    required this.book,
    this.sectionTitleStyle,
    this.iconSize = 16,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Publisher Details',
          style:
              sectionTitleStyle ??
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        MetadataRow(
          icon: Icons.business,
          label: 'Publisher',
          value: book.publisher ?? 'N/A',
          iconSize: iconSize,
          labelStyle: labelStyle,
          valueStyle: valueStyle,
        ),
        MetadataRow(
          icon: Icons.calendar_month,
          label: 'Published Date',
          value: book.publishedDate ?? 'N/A',
          iconSize: iconSize,
          labelStyle: labelStyle,
          valueStyle: valueStyle,
        ),
        MetadataRow(
          icon: Icons.auto_stories,
          label: 'Page Count',
          value: '${book.pageCount ?? 'N/A'}',
          iconSize: iconSize,
          labelStyle: labelStyle,
          valueStyle: valueStyle,
        ),
      ],
    );
  }
}

// 6. Description Section
class BookDescriptionSection extends StatelessWidget {
  final String? description;
  final TextStyle? sectionTitleStyle;
  final TextStyle? textStyle;

  const BookDescriptionSection({
    super.key,
    required this.description,
    this.sectionTitleStyle,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style:
              sectionTitleStyle ??
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          description ?? 'No official description available.',
          style:
              textStyle ??
              const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
        ),
      ],
    );
  }
}

// 7. Author Recommendations
class AuthorRecommendationsList extends StatelessWidget {
  final double height;
  final double itemWidth;
  final double imageHeight;
  final TextStyle? sectionTitleStyle;
  final TextStyle? itemTitleStyle;

  const AuthorRecommendationsList({
    super.key,
    this.height = 180,
    this.itemWidth = 100,
    this.imageHeight = 120,
    this.sectionTitleStyle,
    this.itemTitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookDetailsBloc, BookDetailsState>(
      builder: (context, state) {
        if (state is BookDetailsLoaded && state.authorBooks.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'More by this Author',
                style:
                    sectionTitleStyle ??
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: height,
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
                          width: itemWidth,
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BookCoverImage(
                                imageUrl: otherBook.thumbnailUrl,
                                heroTag: 'recommendation-${otherBook.id}',
                                height: imageHeight,
                                width: itemWidth,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                otherBook.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    itemTitleStyle ??
                                    const TextStyle(
                                      fontSize: 11,
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

// 8. Preview Button
class BookPreviewButton extends StatelessWidget {
  final String? previewLink;
  final double height;
  final TextStyle? textStyle;
  final ButtonStyle? buttonStyle;

  const BookPreviewButton({
    super.key,
    required this.previewLink,
    this.height = 50,
    this.textStyle,
    this.buttonStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (previewLink == null) return const SizedBox();

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton.icon(
        onPressed: () async {
          final uri = Uri.parse(previewLink!);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        icon: const Icon(Icons.open_in_new),
        label: Text('Read Preview', style: textStyle),
        style:
            buttonStyle ??
            ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
      ),
    );
  }
}
