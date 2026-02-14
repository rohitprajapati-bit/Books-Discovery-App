import '../entities/book.dart';
import '../repositories/book_repository.dart';

class SearchBooksByISBNUseCase {
  final BookRepository repository;

  SearchBooksByISBNUseCase(this.repository);

  Future<List<Book>> execute(String isbn, String userId) {
    return repository.searchBooksByISBN(isbn, userId: userId);
  }
}
