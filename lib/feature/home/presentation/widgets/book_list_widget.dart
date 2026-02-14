import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/router/routes.gr.dart';
import '../../domain/entities/book.dart';

class BookListWidget extends StatelessWidget {
  final List<Book> books;

  const BookListWidget({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const Center(child: Text('No books found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: Hero(
              tag: 'book-image-${book.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: book.thumbnailUrl != null
                    ? Image.network(
                        book.thumbnailUrl!.replaceFirst('http://', 'https://'),
                        width: 50,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.book, size: 50),
                      )
                    : const Icon(Icons.book, size: 50),
              ),
            ),
            title: Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.authors.join(', '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (book.publisher != null)
                  Text(
                    book.publisher!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
            onTap: () {
              context.router.push(BookDetailsRoute(book: book));
            },
          ),
        );
      },
    );
  }
}
