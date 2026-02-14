import '../../../../core/network/dio_client.dart';
import '../../../../core/error/exceptions.dart';

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
    try {
      final response = await dioClient.get(
        'volumes',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final items = data['items'] as List<dynamic>?;

        if (items == null) return [];

        return items.map((json) => BookModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to load books. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Failed to search books. Please check your connection.',
        code: e.toString(),
      );
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
