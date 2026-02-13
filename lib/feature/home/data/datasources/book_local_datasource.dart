import 'package:shared_preferences/shared_preferences.dart';

abstract class BookLocalDataSource {
  Future<List<String>> getSearchHistory();
  Future<void> saveSearchQuery(String query);
  Future<void> clearSearchHistory();
}

class BookLocalDataSourceImpl implements BookLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _historyKey = 'book_search_history';

  BookLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<String>> getSearchHistory() async {
    final history = sharedPreferences.getStringList(_historyKey);
    return history ?? [];
  }

  @override
  Future<void> saveSearchQuery(String query) async {
    if (query.trim().isEmpty) return;

    final history = await getSearchHistory();
    final updatedHistory = history.where((q) => q != query).toList();
    updatedHistory.insert(0, query);

    // Limit to 10 items
    if (updatedHistory.length > 10) {
      updatedHistory.removeRange(10, updatedHistory.length);
    }

    await sharedPreferences.setStringList(_historyKey, updatedHistory);
  }

  @override
  Future<void> clearSearchHistory() async {
    await sharedPreferences.remove(_historyKey);
  }
}
