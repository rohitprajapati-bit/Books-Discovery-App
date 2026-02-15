import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:books_discovery_app/feature/book_details/domain/usecases/get_books_by_author_usecase.dart';
import 'package:books_discovery_app/feature/book_details/domain/usecases/generate_ai_summary_usecase.dart';
import 'package:books_discovery_app/feature/book_details/domain/usecases/get_ai_recommendations_usecase.dart';
import 'book_details_event.dart';
import 'book_details_state.dart';

class BookDetailsBloc extends Bloc<BookDetailsEvent, BookDetailsState> {
  final GetBooksByAuthorUseCase getBooksByAuthorUseCase;
  final GenerateAISummaryUseCase generateAISummaryUseCase;
  final GetAIRecommendationsUseCase getAIRecommendationsUseCase;

  BookDetailsBloc({
    required this.getBooksByAuthorUseCase,
    required this.generateAISummaryUseCase,
    required this.getAIRecommendationsUseCase,
  }) : super(BookDetailsInitial()) {
    on<LoadBookDetailsEvent>(_onLoadBookDetails);
    on<RefreshAISummaryEvent>(_onRefreshAISummary);
  }

  Future<void> _onLoadBookDetails(
    LoadBookDetailsEvent event,
    Emitter<BookDetailsState> emit,
  ) async {
    emit(BookDetailsLoading());

    try {
      final authorName = event.book.authors.isNotEmpty
          ? event.book.authors.first
          : 'Unknown';

      final results = await Future.wait([
        generateAISummaryUseCase.execute(event.book),
        getBooksByAuthorUseCase.execute(authorName, event.userId),
        getAIRecommendationsUseCase.execute(event.book),
      ]);

      final String summary = results[0] as String;
      final authorBooks = (results[1] as List)
          .cast<dynamic>()
          .where((b) => b.id != event.book.id)
          .toList();
      final List<String> recommendations = results[2] as List<String>;

      emit(
        BookDetailsLoaded(
          aiSummary: summary,
          authorBooks: authorBooks.cast(),
          aiRecommendations: recommendations,
        ),
      );
    } catch (e) {
      emit(BookDetailsError(e.toString()));
    }
  }

  Future<void> _onRefreshAISummary(
    RefreshAISummaryEvent event,
    Emitter<BookDetailsState> emit,
  ) async {
    if (state is BookDetailsLoaded) {
      final currentState = state as BookDetailsLoaded;
      try {
        final newSummary = await generateAISummaryUseCase.execute(event.book);
        emit(
          BookDetailsLoaded(
            aiSummary: newSummary,
            authorBooks: currentState.authorBooks,
            aiRecommendations: currentState.aiRecommendations,
          ),
        );
      } catch (e) {
        emit(BookDetailsError(e.toString()));
      }
    }
  }
}
