import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book_model.dart';

abstract class BookLocalDataSource {
  Future<List<String>> getSearchHistory(String userId);
  Future<void> saveSearchQuery(String userId, String query);
  Future<void> clearSearchHistory(String userId);

  // Analytics Cache
  Future<void> cacheBooks(String userId, List<BookModel> books);
  Future<List<BookModel>> getCachedBooks(String userId);
}

class BookLocalDataSourceImpl implements BookLocalDataSource {
  final SharedPreferences sharedPreferences;

  BookLocalDataSourceImpl({required this.sharedPreferences});

  String _getHistoryKey(String userId) => 'user_${userId}_search_history';
  String _getCachedBooksKey(String userId) => 'user_${userId}_cached_books';

  @override
  Future<List<String>> getSearchHistory(String userId) async {
    final history = sharedPreferences.getStringList(_getHistoryKey(userId));
    return history ?? [];
  }

  @override
  Future<void> saveSearchQuery(String userId, String query) async {
    if (query.trim().isEmpty) return;

    final history = await getSearchHistory(userId);
    final updatedHistory = history.where((q) => q != query).toList();
    updatedHistory.insert(0, query);

    // Limit to 10 items
    if (updatedHistory.length > 10) {
      updatedHistory.removeRange(10, updatedHistory.length);
    }

    await sharedPreferences.setStringList(
      _getHistoryKey(userId),
      updatedHistory,
    );
  }

  @override
  Future<void> clearSearchHistory(String userId) async {
    await sharedPreferences.remove(_getHistoryKey(userId));
    await sharedPreferences.remove(_getCachedBooksKey(userId));
  }

  @override
  Future<void> cacheBooks(String userId, List<BookModel> books) async {
    if (books.isEmpty) return;

    final existingJson =
        sharedPreferences.getStringList(_getCachedBooksKey(userId)) ?? [];
    final Map<String, String> bookMap = {};

    // Add existing to map (for deduplication)
    for (var jsonStr in existingJson) {
      try {
        final decoded = jsonDecode(jsonStr);
        bookMap[decoded['id']] = jsonStr;
      } catch (_) {}
    }

    // Add new books to map
    for (var book in books) {
      bookMap[book.id] = jsonEncode(book.toJson());
    }

    // Keep only last 50 books for analytics performance
    final updatedList = bookMap.values.toList();
    if (updatedList.length > 50) {
      updatedList.removeRange(0, updatedList.length - 50);
    }

    await sharedPreferences.setStringList(
      _getCachedBooksKey(userId),
      updatedList,
    );
  }

  @override
  Future<List<BookModel>> getCachedBooks(String userId) async {
    final list =
        sharedPreferences.getStringList(_getCachedBooksKey(userId)) ?? [];
    return list.map((e) => BookModel.fromJson(jsonDecode(e))).toList();
  }
}
