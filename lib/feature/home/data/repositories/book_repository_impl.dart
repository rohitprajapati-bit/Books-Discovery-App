import '../../../../core/error/exceptions.dart';
import '../models/book_model.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_local_datasource.dart';
import '../datasources/book_remote_datasource.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remoteDataSource;
  final BookLocalDataSource localDataSource;

  BookRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Book>> searchBooks(String query, {required String userId}) async {
    try {
      final books = await remoteDataSource.searchBooks(query);
      if (books.isNotEmpty) {
        await cacheBooks(userId, books);
      }
      return books;
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to search books');
    }
  }

  @override
  Future<List<Book>> searchBooksByISBN(
    String isbn, {
    required String userId,
  }) async {
    try {
      final books = await remoteDataSource.searchBooksByISBN(isbn);
      if (books.isNotEmpty) {
        await cacheBooks(userId, books);
      }
      return books;
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to search books by ISBN');
    }
  }

  @override
  Future<List<Book>> searchBooksByAuthor(
    String author, {
    required String userId,
  }) async {
    try {
      final books = await remoteDataSource.searchBooksByAuthor(author);
      if (books.isNotEmpty) {
        await cacheBooks(userId, books);
      }
      return books;
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to search books by Author');
    }
  }

  @override
  Future<List<String>> getSearchHistory(String userId) async {
    return await localDataSource.getSearchHistory(userId);
  }

  @override
  Future<void> saveSearchQuery(String userId, String query) async {
    await localDataSource.saveSearchQuery(userId, query);
  }

  @override
  Future<void> clearSearchHistory(String userId) async {
    await localDataSource.clearSearchHistory(userId);
  }

  @override
  Future<void> cacheBooks(String userId, List<Book> books) async {
    final models = books.map((e) => BookModel.fromEntity(e)).toList();
    await localDataSource.cacheBooks(userId, models);
  }

  @override
  Future<List<Book>> getCachedBooks(String userId) async {
    return await localDataSource.getCachedBooks(userId);
  }

  @override
  Future<void> clearAllData(String userId) async {
    await localDataSource.clearSearchHistory(userId);
  }
}
