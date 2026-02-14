import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetBooksByAuthorUseCase {
  final BookRepository repository;

  GetBooksByAuthorUseCase(this.repository);

  Future<List<Book>> execute(String author, String userId) async {
    return await repository.searchBooksByAuthor(author, userId: userId);
  }
}
