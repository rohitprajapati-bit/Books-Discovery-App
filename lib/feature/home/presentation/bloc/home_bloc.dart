import 'package:bloc/bloc.dart';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/search_books_usecase.dart';
import '../../domain/usecases/get_search_history_usecase.dart';
import '../../domain/usecases/save_search_history_usecase.dart';
import '../../domain/usecases/clear_search_history_usecase.dart';
import '../../domain/usecases/search_books_by_isbn_usecase.dart';
import '../../domain/usecases/extract_text_usecase.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SearchBooksUseCase searchBooksUseCase;
  final SearchBooksByISBNUseCase searchBooksByISBNUseCase;
  final GetSearchHistoryUseCase getSearchHistoryUseCase;
  final SaveSearchHistoryUseCase saveSearchHistoryUseCase;
  final ClearSearchHistoryUseCase clearSearchHistoryUseCase;
  final ExtractTextUseCase extractTextUseCase;

  HomeBloc({
    required this.searchBooksUseCase,
    required this.searchBooksByISBNUseCase,
    required this.getSearchHistoryUseCase,
    required this.saveSearchHistoryUseCase,
    required this.clearSearchHistoryUseCase,
    required this.extractTextUseCase,
  }) : super(const HomeInitial()) {
    on<LoadSearchHistoryEvent>(_onLoadSearchHistory);
    on<SearchBooksEvent>(_onSearchBooks);
    on<ClearSearchHistoryEvent>(_onClearSearchHistory);
    on<ToggleViewModeEvent>(_onToggleViewMode);
    on<QRCodeScannedEvent>(_onQRCodeScanned);
    on<OCRSearchRequestedEvent>(_onOCRSearchRequested);
  }

  Future<void> _onLoadSearchHistory(
    LoadSearchHistoryEvent event,
    Emitter<HomeState> emit,
  ) async {
    final history = await getSearchHistoryUseCase.execute();
    emit(HomeInitial(viewMode: state.viewMode, searchHistory: history));
  }

  Future<void> _onSearchBooks(
    SearchBooksEvent event,
    Emitter<HomeState> emit,
  ) async {
    log('HomeBloc: SearchBooksEvent received with query: ${event.query}');
    if (event.query.trim().isEmpty) return;

    emit(
      HomeLoading(viewMode: state.viewMode, searchHistory: state.searchHistory),
    );

    try {
      log('HomeBloc: Saving search history...');
      await saveSearchHistoryUseCase.execute(event.query);
      final history = await getSearchHistoryUseCase.execute();

      log('HomeBloc: Calling searchBooksUseCase...');
      final books = await searchBooksUseCase.execute(event.query);

      log('HomeBloc: Search success, found ${books.length} books');
      emit(
        HomeSuccess(
          books: books,
          viewMode: state.viewMode,
          searchHistory: history,
        ),
      );
    } catch (e) {
      log('HomeBloc: Search error: $e');
      emit(
        HomeFailure(
          message: e.toString(),
          viewMode: state.viewMode,
          searchHistory: state.searchHistory,
        ),
      );
    }
  }

  Future<void> _onClearSearchHistory(
    ClearSearchHistoryEvent event,
    Emitter<HomeState> emit,
  ) async {
    await clearSearchHistoryUseCase.execute();
    final updatedState = _createStateWithHistory(state, []);
    emit(updatedState);
  }

  void _onToggleViewMode(ToggleViewModeEvent event, Emitter<HomeState> emit) {
    final nextMode = state.viewMode == HomeViewMode.list
        ? HomeViewMode.grid
        : HomeViewMode.list;

    if (state is HomeSuccess) {
      emit(
        HomeSuccess(
          books: (state as HomeSuccess).books,
          viewMode: nextMode,
          searchHistory: state.searchHistory,
        ),
      );
    } else if (state is HomeLoading) {
      emit(HomeLoading(viewMode: nextMode, searchHistory: state.searchHistory));
    } else if (state is HomeFailure) {
      emit(
        HomeFailure(
          message: (state as HomeFailure).message,
          viewMode: nextMode,
          searchHistory: state.searchHistory,
        ),
      );
    } else {
      emit(HomeInitial(viewMode: nextMode, searchHistory: state.searchHistory));
    }
  }

  HomeState _createStateWithHistory(HomeState state, List<String> history) {
    if (state is HomeSuccess) {
      return HomeSuccess(
        books: state.books,
        viewMode: state.viewMode,
        searchHistory: history,
      );
    } else if (state is HomeLoading) {
      return HomeLoading(viewMode: state.viewMode, searchHistory: history);
    } else if (state is HomeFailure) {
      return HomeFailure(
        message: state.message,
        viewMode: state.viewMode,
        searchHistory: history,
      );
    } else {
      return HomeInitial(viewMode: state.viewMode, searchHistory: history);
    }
  }

  Future<void> _onQRCodeScanned(
    QRCodeScannedEvent event,
    Emitter<HomeState> emit,
  ) async {
    final scannedValue = event.isbn.trim();
    log('HomeBloc: QRCodeScannedEvent received with: "$scannedValue"');

    emit(
      HomeLoading(viewMode: state.viewMode, searchHistory: state.searchHistory),
    );

    try {
      List<Book> books;
      // ISBN-10 or ISBN-13 check: Numeric and length 10 or 13
      final isIsbn =
          RegExp(r'^[0-9]+$').hasMatch(scannedValue) &&
          (scannedValue.length == 10 || scannedValue.length == 13);

      if (isIsbn) {
        log(
          'HomeBloc: Identified as ISBN. Searching using "isbn:" qualifier...',
        );
        books = await searchBooksByISBNUseCase.execute(scannedValue);
      } else {
        log('HomeBloc: Identified as Text. Searching as regular query...');
        books = await searchBooksUseCase.execute(scannedValue);
      }

      // Also save to history
      await saveSearchHistoryUseCase.execute('Scan: $scannedValue');
      final history = await getSearchHistoryUseCase.execute();

      log('HomeBloc: Search completed. Found ${books.length} books.');
      emit(
        HomeSuccess(
          books: books,
          viewMode: state.viewMode,
          searchHistory: history,
        ),
      );
    } catch (e) {
      log('HomeBloc: QR Search Error: $e');
      emit(
        HomeFailure(
          message: e.toString(),
          viewMode: state.viewMode,
          searchHistory: state.searchHistory,
        ),
      );
    }
  }

  Future<void> _onOCRSearchRequested(
    OCRSearchRequestedEvent event,
    Emitter<HomeState> emit,
  ) async {
    log(
      'HomeBloc: OCRSearchRequestedEvent received with path: ${event.imagePath}',
    );

    emit(
      HomeLoading(viewMode: state.viewMode, searchHistory: state.searchHistory),
    );

    try {
      final imageFile = File(event.imagePath);
      log('HomeBloc: Extracting detailed text from image...');
      final detailedResults = await extractTextUseCase.executeDetailed(
        imageFile,
      );

      if (detailedResults.isEmpty) {
        emit(
          HomeFailure(
            message:
                "No text found in the image. Please try again with a clearer picture of the book cover or title.",
            viewMode: state.viewMode,
            searchHistory: state.searchHistory,
          ),
        );
        return;
      }

      // Sort lines by prominence (height). Title is usually the largest text.
      detailedResults.sort(
        (a, b) => (b['height'] as double).compareTo(a['height'] as double),
      );

      // Filter out common "noise" phrases that might be large but aren't titles
      final noisePhrases = [
        'bestseller',
        'copies sold',
        'million copies',
        'new york times',
        'the international',
        'special edition',
        'foreword by',
        'copies sold',
      ];

      String? titleCandidate;
      for (var result in detailedResults) {
        final text = result['text'].toString().toLowerCase();
        bool isNoise = noisePhrases.any((phrase) => text.contains(phrase));
        if (!isNoise && result['text'].toString().trim().length > 2) {
          titleCandidate = result['text'];
          break;
        }
      }

      // Fallback to the largest line if everything was filtered
      titleCandidate ??= detailedResults.first['text'];

      log(
        'HomeBloc: Most prominent non-noise text (Title Candidate): "$titleCandidate"',
      );

      // Also grab the next prominent line (likely the author or subtitle) for context
      String query = titleCandidate!;
      if (detailedResults.length > 1) {
        // Find the second largest that isn't the title and isn't noise
        String? secondCandidate;
        for (var result in detailedResults) {
          if (result['text'] == titleCandidate) continue;
          final text = result['text'].toString().toLowerCase();
          bool isNoise = noisePhrases.any((phrase) => text.contains(phrase));
          if (!isNoise &&
              result['height'] > (detailedResults[0]['height'] * 0.4)) {
            secondCandidate = result['text'];
            break;
          }
        }

        if (secondCandidate != null) {
          query += " $secondCandidate";
        }
      }

      log('HomeBloc: Searching for: "$query"');
      final books = await searchBooksUseCase.execute(query);

      await saveSearchHistoryUseCase.execute('OCR: $query');
      final history = await getSearchHistoryUseCase.execute();

      log('HomeBloc: OCR Search success, found ${books.length} books');
      emit(
        HomeSuccess(
          books: books,
          viewMode: state.viewMode,
          searchHistory: history,
        ),
      );
    } catch (e) {
      log('HomeBloc: OCR Search error: $e');
      emit(
        HomeFailure(
          message: "OCR Error: ${e.toString()}",
          viewMode: state.viewMode,
          searchHistory: state.searchHistory,
        ),
      );
    }
  }
}
