import 'package:equatable/equatable.dart';
import '../../domain/entities/book.dart';

abstract class BookDetailsState extends Equatable {
  const BookDetailsState();

  @override
  List<Object?> get props => [];
}

class BookDetailsInitial extends BookDetailsState {}

class BookDetailsLoading extends BookDetailsState {}

class BookDetailsLoaded extends BookDetailsState {
  final String aiSummary;
  final List<Book> authorBooks;
  final List<String> aiRecommendations;

  const BookDetailsLoaded({
    required this.aiSummary,
    required this.authorBooks,
    required this.aiRecommendations,
  });

  @override
  List<Object?> get props => [aiSummary, authorBooks, aiRecommendations];
}

class BookDetailsError extends BookDetailsState {
  final String message;
  const BookDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
