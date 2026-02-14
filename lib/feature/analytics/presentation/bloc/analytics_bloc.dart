import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/trending_socket_service.dart';
import '../../domain/usecases/get_cached_books_usecase.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetCachedBooksUseCase getCachedBooksUseCase;
  final TrendingSocketService trendingSocketService;
  StreamSubscription? _trendingSubscription;

  AnalyticsBloc({
    required this.getCachedBooksUseCase,
    required this.trendingSocketService,
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

      if (books.isEmpty) {
        emit(
          const AnalyticsLoaded(
            genreDistribution: {},
            publishingTrends: {},
            trendingBooks: [],
            totalBooks: 0,
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
        ),
      );
    } else if (state is AnalyticsInitial || state is AnalyticsError) {
      emit(
        AnalyticsLoaded(
          genreDistribution: const {},
          publishingTrends: const {},
          trendingBooks: event.trendingBooks,
          totalBooks: 0,
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
