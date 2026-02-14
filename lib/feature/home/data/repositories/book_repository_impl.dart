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
  Future<List<Book>> searchBooks(String query) async {
    return await remoteDataSource.searchBooks(query);
  }

  @override
  Future<List<Book>> searchBooksByISBN(String isbn) async {
    return await remoteDataSource.searchBooksByISBN(isbn);
  }

  @override
  Future<List<String>> getSearchHistory() async {
    return await localDataSource.getSearchHistory();
  }

  @override
  Future<void> saveSearchQuery(String query) async {
    await localDataSource.saveSearchQuery(query);
  }

  @override
  Future<void> clearSearchHistory() async {
    await localDataSource.clearSearchHistory();
  }
}
