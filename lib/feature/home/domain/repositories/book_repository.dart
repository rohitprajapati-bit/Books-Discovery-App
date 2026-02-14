import '../entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> searchBooks(String query, {required String userId});
  Future<List<Book>> searchBooksByISBN(String isbn, {required String userId});
  Future<List<Book>> searchBooksByAuthor(
    String author, {
    required String userId,
  });
  Future<List<String>> getSearchHistory(String userId);
  Future<void> saveSearchQuery(String userId, String query);
  Future<void> clearSearchHistory(String userId);

  // Analytics
  Future<void> cacheBooks(String userId, List<Book> books);
  Future<List<Book>> getCachedBooks(String userId);
  Future<void> clearAllData(String userId);
}
