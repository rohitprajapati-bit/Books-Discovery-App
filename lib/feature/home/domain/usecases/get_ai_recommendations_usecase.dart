import '../entities/book.dart';
import '../services/ai_service.dart';

class GetAIRecommendationsUseCase {
  final AIService aiService;

  GetAIRecommendationsUseCase(this.aiService);

  Future<List<String>> execute(Book book) async {
    return await aiService.getPersonalizedRecommendations(book);
  }
}
