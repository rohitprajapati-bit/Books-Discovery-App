import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/trending_socket_service.dart';
import '../../domain/usecases/get_cached_books_usecase.dart';
import '../../../home/domain/usecases/get_search_history_usecase.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetCachedBooksUseCase getCachedBooksUseCase;
  final TrendingSocketService trendingSocketService;
  final GetSearchHistoryUseCase getSearchHistoryUseCase;
  StreamSubscription? _trendingSubscription;

  AnalyticsBloc({
    required this.getCachedBooksUseCase,
    required this.trendingSocketService,
    required this.getSearchHistoryUseCase,
  }) : super(AnalyticsInitial()) {
    on<LoadAnalyticsEvent>(_onLoadAnalytics);
    on<UpdateTrendingBooksEvent>(_onUpdateTrendingBooks);
    on<ResetAnalyticsEvent>(_onResetAnalytics);

    _trendingSubscription = trendingSocketService.trendingStream.listen((
      books,
    ) {
      add(UpdateTrendingBooksEvent(books));
    });
  }

  Future<void> _onLoadAnalytics(
    LoadAnalyticsEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());

    try {
      final books = await getCachedBooksUseCase.execute(event.userId);
      final searchHistory = await getSearchHistoryUseCase.execute(event.userId);

      // Calculate Top Search Terms
      final Map<String, int> termCounts = {};
      for (final term in searchHistory) {
        final normalized = term.trim().toLowerCase();
        if (normalized.isNotEmpty) {
          termCounts[normalized] = (termCounts[normalized] ?? 0) + 1;
        }
      }

      // Sort and take top 5
      final topTerms = Map.fromEntries(
        termCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value))
          ..take(5),
      );

      if (books.isEmpty && topTerms.isEmpty) {
        emit(
          const AnalyticsLoaded(
            genreDistribution: {},
            publishingTrends: {},
            trendingBooks: [],
            totalBooks: 0,
            topSearchTerms: {},
          ),
        );
        return;
      }

      final Map<String, int> genreCounts = {};
      final Map<String, int> publishingCounts = {};

      for (var book in books) {
        // Genre Distribution
        final categories = book.categories;
        if (categories == null || categories.isEmpty) {
          genreCounts['Uncategorized'] =
              (genreCounts['Uncategorized'] ?? 0) + 1;
        } else {
          for (var category in categories) {
            genreCounts[category] = (genreCounts[category] ?? 0) + 1;
          }
        }

        // Publishing Trends
        final date = book.publishedDate;
        if (date != null && date.isNotEmpty) {
          final yearMatch = RegExp(r'\d{4}').firstMatch(date);
          if (yearMatch != null) {
            final year = int.parse(yearMatch.group(0)!);
            String range;
            if (year >= 2020) {
              range = '2020s';
            } else if (year >= 2010) {
              range = '2010s';
            } else if (year >= 2000) {
              range = '2000s';
            } else if (year >= 1990) {
              range = '1990s';
            } else {
              range = 'Classic';
            }

            publishingCounts[range] = (publishingCounts[range] ?? 0) + 1;
          }
        }
      }

      emit(
        AnalyticsLoaded(
          genreDistribution: genreCounts,
          publishingTrends: publishingCounts,
          trendingBooks: (state is AnalyticsLoaded)
              ? (state as AnalyticsLoaded).trendingBooks
              : [],
          totalBooks: books.length,
          topSearchTerms: topTerms,
        ),
      );
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  void _onUpdateTrendingBooks(
    UpdateTrendingBooksEvent event,
    Emitter<AnalyticsState> emit,
  ) {
    if (state is AnalyticsLoaded) {
      final currentState = state as AnalyticsLoaded;
      emit(
        AnalyticsLoaded(
          genreDistribution: currentState.genreDistribution,
          publishingTrends: currentState.publishingTrends,
          trendingBooks: event.trendingBooks,
          totalBooks: currentState.totalBooks,
          topSearchTerms: currentState.topSearchTerms,
        ),
      );
    } else if (state is AnalyticsInitial || state is AnalyticsError) {
      emit(
        AnalyticsLoaded(
          genreDistribution: const {},
          publishingTrends: const {},
          trendingBooks: event.trendingBooks,
          totalBooks: 0,
          topSearchTerms: const {},
        ),
      );
    }
  }

  void _onResetAnalytics(
    ResetAnalyticsEvent event,
    Emitter<AnalyticsState> emit,
  ) {
    emit(AnalyticsInitial());
  }

  @override
  Future<void> close() {
    _trendingSubscription?.cancel();
    return super.close();
  }
}
