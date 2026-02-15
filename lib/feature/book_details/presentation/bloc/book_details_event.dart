import 'package:equatable/equatable.dart';
import 'package:books_discovery_app/feature/home/domain/entities/book.dart';

abstract class BookDetailsEvent extends Equatable {
  const BookDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadBookDetailsEvent extends BookDetailsEvent {
  final Book book;
  final String userId;
  const LoadBookDetailsEvent(this.book, this.userId);

  @override
  List<Object?> get props => [book, userId];
}

class RefreshAISummaryEvent extends BookDetailsEvent {
  final Book book;
  final String userId;
  const RefreshAISummaryEvent(this.book, this.userId);

  @override
  List<Object?> get props => [book, userId];
}
