import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
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
        queryParameters: {'q': query, 'key': ApiConstants.googleBooksApiKey},
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
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw ServerException(
          message:
              'Daily quota exceeded for Google Books API. Please try again tomorrow or use a different API key.',
          code: 'quota_exceeded',
        );
      }
      throw ServerException(
        message:
            e.response?.statusMessage ??
            'Failed to search books. Please check your connection.',
        code: e.response?.statusCode?.toString() ?? 'unknown',
      );
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
