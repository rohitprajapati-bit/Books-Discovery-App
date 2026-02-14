import '../entities/book.dart';
import '../repositories/book_repository.dart';

class SearchBooksByISBNUseCase {
  final BookRepository repository;

  SearchBooksByISBNUseCase(this.repository);

  Future<List<Book>> execute(String isbn) {
    return repository.searchBooksByISBN(isbn);
  }
}
