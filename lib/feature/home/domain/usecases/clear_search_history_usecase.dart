import '../repositories/book_repository.dart';

class ClearSearchHistoryUseCase {
  final BookRepository repository;

  ClearSearchHistoryUseCase({required this.repository});

  Future<void> execute(String userId) async {
    await repository.clearAllData(userId);
  }
}
