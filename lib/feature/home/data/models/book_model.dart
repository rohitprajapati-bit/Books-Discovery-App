import '../../domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.authors,
    super.description,
    super.publisher,
    super.publishedDate,
    super.pageCount,
    super.categories,
    super.thumbnailUrl,
    super.previewLink,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] as Map<String, dynamic>;
    final imageLinks = volumeInfo['imageLinks'] as Map<String, dynamic>?;

    return BookModel(
      id: json['id'] as String,
      title: volumeInfo['title'] as String,
      authors:
          (volumeInfo['authors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          ['Unknown Author'],
      description: volumeInfo['description'] as String?,
      publisher: volumeInfo['publisher'] as String?,
      publishedDate: volumeInfo['publishedDate'] as String?,
      pageCount: volumeInfo['pageCount'] as int?,
      categories: (volumeInfo['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      thumbnailUrl: imageLinks?['thumbnail'] as String?,
      previewLink: volumeInfo['previewLink'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'volumeInfo': {
        'title': title,
        'authors': authors,
        'description': description,
        'publisher': publisher,
        'publishedDate': publishedDate,
        'pageCount': pageCount,
        'categories': categories,
        'imageLinks': {'thumbnail': thumbnailUrl},
        'previewLink': previewLink,
      },
    };
  }

  factory BookModel.fromEntity(Book book) {
    return BookModel(
      id: book.id,
      title: book.title,
      authors: book.authors,
      description: book.description,
      publisher: book.publisher,
      publishedDate: book.publishedDate,
      pageCount: book.pageCount,
      categories: book.categories,
      thumbnailUrl: book.thumbnailUrl,
      previewLink: book.previewLink,
    );
  }
}
