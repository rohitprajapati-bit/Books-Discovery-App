import '../entities/book.dart';

abstract class AIService {
  Future<String> generateBookSummary(Book book);
  Future<List<String>> getPersonalizedRecommendations(Book book);
}
