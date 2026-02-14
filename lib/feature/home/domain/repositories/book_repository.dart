import '../entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> searchBooks(String query);
  Future<List<Book>> searchBooksByISBN(String isbn);
  Future<List<Book>> searchBooksByAuthor(String author);
  Future<List<String>> getSearchHistory();
  Future<void> saveSearchQuery(String query);
  Future<void> clearSearchHistory();
}
