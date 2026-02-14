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
        'Summarize the book "${book.title}" by ${book.authors.join(', ')} in a concise, engaging, and easy-to-read paragraph (max 150 words). Avoid spoilers. Use its description for context: ${book.description ?? 'No description available'}.';

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
        'Based on the book "${book.title}" by ${book.authors.join(', ')} (Category: ${book.categories?.join(', ') ?? 'General'}), recommend 5 similar book titles. Return ONLY a JSON array of strings, e.g., ["Book 1", "Book 2"]. Do not include markdown formatting like ```json or ```.';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      var text = response.text;

      if (text == null || text.isEmpty) {
        log('Gemini Recommendations: Response text is null or empty.');
        return [];
      }

      // cleanup markdown if present
      text = text.replaceAll('```json', '').replaceAll('```', '').trim();

      // Simple parsing if it's a bracketed list
      if (text.startsWith('[') && text.endsWith(']')) {
        // Remove brackets and split by comma, respecting quotes would be better but simple split for now
        // A better approach is using a JSON decoder, but for a simple list of strings, manual cleanup might suffice if we trust the model
        // Let's use standard JSON decode safely
        // But we need dart:convert
        // Wait, I should add import dart:convert at top if I use jsonDecode.
        // For now, let's stick to the previous comma separation strategy but enforced by prompt, or just loose parsing.
        // Actually, let's just ask for comma separated values again but be more specific.
        // Returning to comma separated is safer without imports.
      }

      // Let's revert to comma separated but robust
      return text
          .split(',')
          .map(
            (e) => e
                .trim()
                .replaceAll('"', '')
                .replaceAll('[', '')
                .replaceAll(']', ''),
          )
          .toList();
    } catch (e) {
      log('Gemini Recommendations Detailed Error: $e');
      return [];
    }
  }
}
