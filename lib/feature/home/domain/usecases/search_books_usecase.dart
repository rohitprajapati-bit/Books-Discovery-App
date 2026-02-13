import '../entities/book.dart';
import '../repositories/book_repository.dart';

class SearchBooksUseCase {
  final BookRepository repository;

  SearchBooksUseCase({required this.repository});

  Future<List<Book>> execute(String query) async {
    return await repository.searchBooks(query);
  }
}
