import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetBooksByAuthorUseCase {
  final BookRepository repository;

  GetBooksByAuthorUseCase(this.repository);

  Future<List<Book>> execute(String author) async {
    return await repository.searchBooksByAuthor(author);
  }
}
