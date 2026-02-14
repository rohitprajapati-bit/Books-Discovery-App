import 'package:bloc/bloc.dart';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/search_books_usecase.dart';
import '../../domain/usecases/get_search_history_usecase.dart';
import '../../domain/usecases/save_search_history_usecase.dart';
import '../../domain/usecases/clear_search_history_usecase.dart';
import '../../domain/usecases/search_books_by_isbn_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SearchBooksUseCase searchBooksUseCase;
  final SearchBooksByISBNUseCase searchBooksByISBNUseCase;
  final GetSearchHistoryUseCase getSearchHistoryUseCase;
  final SaveSearchHistoryUseCase saveSearchHistoryUseCase;
  final ClearSearchHistoryUseCase clearSearchHistoryUseCase;

  HomeBloc({
    required this.searchBooksUseCase,
    required this.searchBooksByISBNUseCase,
    required this.getSearchHistoryUseCase,
    required this.saveSearchHistoryUseCase,
    required this.clearSearchHistoryUseCase,
  }) : super(const HomeInitial()) {
    on<LoadSearchHistoryEvent>(_onLoadSearchHistory);
    on<SearchBooksEvent>(_onSearchBooks);
    on<ClearSearchHistoryEvent>(_onClearSearchHistory);
    on<ToggleViewModeEvent>(_onToggleViewMode);
    on<QRCodeScannedEvent>(_onQRCodeScanned);
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
}
