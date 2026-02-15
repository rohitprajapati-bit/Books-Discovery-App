part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class SearchBooksEvent extends HomeEvent {
  final String query;
  final String userId;

  const SearchBooksEvent(this.query, this.userId);

  @override
  List<Object> get props => [query, userId];
}

class LoadSearchHistoryEvent extends HomeEvent {
  final String userId;
  const LoadSearchHistoryEvent(this.userId);
  @override
  List<Object> get props => [userId];
}

class ClearSearchHistoryEvent extends HomeEvent {
  final String userId;
  const ClearSearchHistoryEvent(this.userId);
  @override
  List<Object> get props => [userId];
}

class ToggleViewModeEvent extends HomeEvent {}

class ScanQRCodeEvent extends HomeEvent {}

class QRCodeScannedEvent extends HomeEvent {
  final String isbn;
  final String userId;
  const QRCodeScannedEvent(this.isbn, this.userId);
  @override
  List<Object> get props => [isbn, userId];
}

class OCRSearchRequestedEvent extends HomeEvent {
  final String imagePath;
  final String userId;
  const OCRSearchRequestedEvent(this.imagePath, this.userId);
  @override
  List<Object> get props => [imagePath, userId];
}

class RetryHomeEvent extends HomeEvent {}

class ResetHomeEvent extends HomeEvent {}
