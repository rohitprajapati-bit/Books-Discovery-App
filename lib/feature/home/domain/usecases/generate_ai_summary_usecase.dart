import '../entities/book.dart';
import '../services/ai_service.dart';

class GenerateAISummaryUseCase {
  final AIService aiService;

  GenerateAISummaryUseCase(this.aiService);

  Future<String> execute(Book book) async {
    return await aiService.generateBookSummary(book);
  }
}
