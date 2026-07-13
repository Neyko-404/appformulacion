import 'package:focusly/features/analytics/domain/entities/study_analytics.dart';

final class AnalyticsState {
  const AnalyticsState({
    this.isInitial = true,
    this.isLoading = false,
    this.isRefreshing = false,
    this.summary,
    this.errorMessage,
    this.lastUpdatedAt,
  });

  final bool isInitial;
  final bool isLoading;
  final bool isRefreshing;
  final StudyAnalyticsSummary? summary;
  final String? errorMessage;
  final DateTime? lastUpdatedAt;

  AnalyticsState copyWith({
    bool? isInitial,
    bool? isLoading,
    bool? isRefreshing,
    StudyAnalyticsSummary? summary,
    String? errorMessage,
    bool clearError = false,
    DateTime? lastUpdatedAt,
  }) => AnalyticsState(
    isInitial: isInitial ?? this.isInitial,
    isLoading: isLoading ?? this.isLoading,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    summary: summary ?? this.summary,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
  );
}
