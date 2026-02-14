import 'package:equatable/equatable.dart';
import '../../domain/entities/book.dart';

abstract class BookDetailsEvent extends Equatable {
  const BookDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadBookDetailsEvent extends BookDetailsEvent {
  final Book book;
  const LoadBookDetailsEvent(this.book);

  @override
  List<Object?> get props => [book];
}

class RefreshAISummaryEvent extends BookDetailsEvent {
  final Book book;
  const RefreshAISummaryEvent(this.book);

  @override
  List<Object?> get props => [book];
}
