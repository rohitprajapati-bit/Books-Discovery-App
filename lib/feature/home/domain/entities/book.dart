import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final List<String> authors;
  final String? description;
  final String? publisher;
  final String? publishedDate;
  final int? pageCount;
  final List<String>? categories;
  final String? thumbnailUrl;
  final String? previewLink;

  const Book({
    required this.id,
    required this.title,
    required this.authors,
    this.description,
    this.publisher,
    this.publishedDate,
    this.pageCount,
    this.categories,
    this.thumbnailUrl,
    this.previewLink,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    authors,
    description,
    publisher,
    publishedDate,
    pageCount,
    categories,
    thumbnailUrl,
    previewLink,
  ];
}
