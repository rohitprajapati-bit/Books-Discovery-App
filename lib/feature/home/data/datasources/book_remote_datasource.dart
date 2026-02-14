import '../../../../core/network/dio_client.dart';
import 'dart:developer';
import '../models/book_model.dart';

abstract class BookRemoteDataSource {
  Future<List<BookModel>> searchBooks(String query);
  Future<List<BookModel>> searchBooksByISBN(String isbn);
  Future<List<BookModel>> searchBooksByAuthor(String author);
}

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final DioClient dioClient;

  BookRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<BookModel>> searchBooks(String query) async {
    log('Searching for: $query');
    try {
      final response = await dioClient.get(
        'volumes',
        queryParameters: {'q': query},
      );

      log('API Response Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final items = data['items'] as List<dynamic>?;

        log('Items found: ${items?.length ?? 0}');

        if (items == null) return [];

        return items.map((json) => BookModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      log('Search Catch Error: $e');
      throw Exception('Failed to search books: ${e.toString()}');
    }
  }

  @override
  Future<List<BookModel>> searchBooksByISBN(String isbn) async {
    return searchBooks('isbn:$isbn');
  }

  @override
  Future<List<BookModel>> searchBooksByAuthor(String author) async {
    return searchBooks('inauthor:"$author"');
  }
}
