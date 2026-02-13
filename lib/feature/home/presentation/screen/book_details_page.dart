import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/book.dart';

@RoutePage()
class BookDetailsPage extends StatelessWidget {
  final Book book;

  const BookDetailsPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book.thumbnailUrl != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    book.thumbnailUrl!.replaceFirst('http://', 'https://'),
                    height: 250,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.book, size: 100),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Text(
              book.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'By ${book.authors.join(', ')}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            if (book.publisher != null)
              Text(
                'Publisher: ${book.publisher}',
                style: const TextStyle(color: Colors.grey),
              ),
            if (book.publishedDate != null)
              Text(
                'Published: ${book.publishedDate}',
                style: const TextStyle(color: Colors.grey),
              ),
            if (book.pageCount != null)
              Text(
                'Page Count: ${book.pageCount}',
                style: const TextStyle(color: Colors.grey),
              ),
            const Divider(height: 32),
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              book.description ?? 'No description available.',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            if (book.previewLink != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Open preview link
                  },
                  child: const Text('View Preview'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
