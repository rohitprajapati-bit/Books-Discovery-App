part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class SearchBooksEvent extends HomeEvent {
  final String query;

  const SearchBooksEvent(this.query);

  @override
  List<Object> get props => [query];
}

class LoadSearchHistoryEvent extends HomeEvent {}

class ClearSearchHistoryEvent extends HomeEvent {}

class ToggleViewModeEvent extends HomeEvent {}
