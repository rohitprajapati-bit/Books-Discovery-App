part of 'home_bloc.dart';

enum HomeViewMode { list, grid }

abstract class HomeState extends Equatable {
  final HomeViewMode viewMode;
  final List<String> searchHistory;

  const HomeState({required this.viewMode, required this.searchHistory});

  @override
  List<Object?> get props => [viewMode, searchHistory];
}

class HomeInitial extends HomeState {
  const HomeInitial({
    super.viewMode = HomeViewMode.grid,
    super.searchHistory = const [],
  });
}

class HomeLoading extends HomeState {
  const HomeLoading({required super.viewMode, required super.searchHistory});
}

class HomeSuccess extends HomeState {
  final List<Book> books;

  const HomeSuccess({
    required this.books,
    required super.viewMode,
    required super.searchHistory,
  });

  @override
  List<Object?> get props => [books, viewMode, searchHistory];
}

class HomeFailure extends HomeState {
  final String message;

  const HomeFailure({
    required this.message,
    required super.viewMode,
    required super.searchHistory,
  });

  @override
  List<Object?> get props => [message, viewMode, searchHistory];
}
