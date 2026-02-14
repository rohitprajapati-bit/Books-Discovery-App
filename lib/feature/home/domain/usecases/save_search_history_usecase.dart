import '../repositories/book_repository.dart';

class SaveSearchHistoryUseCase {
  final BookRepository repository;

  SaveSearchHistoryUseCase({required this.repository});

  Future<void> execute(String userId, String query) async {
    await repository.saveSearchQuery(userId, query);
  }
}
