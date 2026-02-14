import 'package:equatable/equatable.dart';

import '../../data/services/trending_socket_service.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final Map<String, int> genreDistribution;
  final Map<String, int> publishingTrends;
  final List<TrendingBook> trendingBooks;
  final int totalBooks;
  final Map<String, int> topSearchTerms;

  const AnalyticsLoaded({
    required this.genreDistribution,
    required this.publishingTrends,
    required this.trendingBooks,
    required this.totalBooks,
    required this.topSearchTerms,
  });

  @override
  List<Object?> get props => [
    genreDistribution,
    publishingTrends,
    trendingBooks,
    totalBooks,
    topSearchTerms,
  ];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}
