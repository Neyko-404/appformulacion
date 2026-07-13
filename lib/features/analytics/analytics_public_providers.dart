import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/analytics/application/providers/analytics_providers.dart';

final class TodayAnalyticsProjection {
  const TodayAnalyticsProjection({
    required this.isLoading,
    required this.focusedDuration,
    required this.completedSessions,
    required this.interruptionCount,
    required this.interruptionDuration,
    this.mostStudiedCourseName,
    this.errorMessage,
  });

  final bool isLoading;
  final Duration focusedDuration;
  final int completedSessions;
  final int interruptionCount;
  final Duration interruptionDuration;
  final String? mostStudiedCourseName;
  final String? errorMessage;
}

final todayAnalyticsProvider = Provider<TodayAnalyticsProjection>((ref) {
  final state = ref.watch(analyticsNotifierProvider);
  final daily = state.summary?.daily;
  return TodayAnalyticsProjection(
    isLoading: state.isLoading,
    focusedDuration: daily?.focusedDuration ?? Duration.zero,
    completedSessions: daily?.completedSessions ?? 0,
    interruptionCount: daily?.interruptionCount ?? 0,
    interruptionDuration: daily?.interruptionDuration ?? Duration.zero,
    mostStudiedCourseName: daily?.mostStudiedCourse?.courseName,
    errorMessage: state.errorMessage,
  );
});
