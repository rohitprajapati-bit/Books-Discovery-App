import 'package:equatable/equatable.dart';
import '../../data/services/trending_socket_service.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAnalyticsEvent extends AnalyticsEvent {
  final String userId;
  const LoadAnalyticsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ResetAnalyticsEvent extends AnalyticsEvent {}

class UpdateTrendingBooksEvent extends AnalyticsEvent {
  final List<TrendingBook> trendingBooks;
  const UpdateTrendingBooksEvent(this.trendingBooks);

  @override
  List<Object?> get props => [trendingBooks];
}
