import '../../../home/domain/entities/book.dart';
import '../../../home/domain/repositories/book_repository.dart';

class GetCachedBooksUseCase {
  final BookRepository repository;

  GetCachedBooksUseCase(this.repository);

  Future<List<Book>> execute(String userId) async {
    return await repository.getCachedBooks(userId);
  }
}
