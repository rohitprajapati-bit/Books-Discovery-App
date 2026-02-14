import 'package:google_generative_ai/google_generative_ai.dart';
import '../../domain/entities/book.dart';
import '../../domain/services/ai_service.dart';
import 'dart:developer';

class GeminiServiceImpl implements AIService {
  final String apiKey;
  late final GenerativeModel _model;

  GeminiServiceImpl({required this.apiKey}) {
    _model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  }

  @override
  Future<String> generateBookSummary(Book book) async {
    log('Gemini: Generating summary for "${book.title}"');
    final prompt =
        'Summarize the book "${book.title}" by ${book.authors.join(', ')} in a concise and engaging paragraph (max 150 words). Use its description for context: ${book.description ?? 'No description available'}.';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null) {
        log(
          'Gemini: Response text is null. Finish reason: ${response.candidates.first.finishReason}',
        );
        return 'Summary could not be generated (it might have been blocked or empty).';
      }

      return response.text!;
    } catch (e) {
      log('Gemini Summary Detailed Error: $e');
      if (e.toString().contains('403') || e.toString().contains('permission')) {
        return 'AI Summary: Access denied. Please check your API key permissions/billing.';
      }
      return 'AI Summary currently unavailable. ($e)';
    }
  }

  @override
  Future<List<String>> getPersonalizedRecommendations(Book book) async {
    log('Gemini: Getting recommendations for "${book.title}"');
    final prompt =
        'Based on the book "${book.title}" by ${book.authors.join(', ')} (Category: ${book.categories?.join(', ') ?? 'General'}), recommend 5 similar book titles. Return ONLY the titles as a comma-separated list, no other text.';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final text = response.text;

      if (text == null || text.isEmpty) {
        log('Gemini Recommendations: Response text is null or empty.');
        return [];
      }

      return text.split(',').map((e) => e.trim()).toList();
    } catch (e) {
      log('Gemini Recommendations Detailed Error: $e');
      return [];
    }
  }
}
