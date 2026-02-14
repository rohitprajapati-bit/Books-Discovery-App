import '../repositories/book_repository.dart';

class GetSearchHistoryUseCase {
  final BookRepository repository;

  GetSearchHistoryUseCase({required this.repository});

  Future<List<String>> execute(String userId) async {
    return await repository.getSearchHistory(userId);
  }
}
