import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/analytics/application/providers/analytics_providers.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/study_engine/study_analytics_read_api.dart';

final class TodayAnalyticsProjection {
  const TodayAnalyticsProjection({
    required this.isLoading,
    required this.focusedDuration,
    required this.completedSessions,
    required this.interruptionCount,
    required this.interruptionDuration,
    this.hasData = true,
    this.mostStudiedCourseName,
    this.errorMessage,
  });

  final bool isLoading;
  final Duration focusedDuration;
  final int completedSessions;
  final int interruptionCount;
  final Duration interruptionDuration;
  final bool hasData;
  final String? mostStudiedCourseName;
  final String? errorMessage;
}

final todayAnalyticsProvider = Provider<TodayAnalyticsProjection>((ref) {
  final state = ref.watch(analyticsNotifierProvider);
  final daily = state.summary?.daily;
  return TodayAnalyticsProjection(
    isLoading: state.isLoading,
    hasData: daily != null,
    focusedDuration: daily?.focusedDuration ?? Duration.zero,
    completedSessions: daily?.completedSessions ?? 0,
    interruptionCount: daily?.interruptionCount ?? 0,
    interruptionDuration: daily?.interruptionDuration ?? Duration.zero,
    mostStudiedCourseName: daily?.mostStudiedCourse?.courseName,
    errorMessage: state.errorMessage,
  );
});

final dashboardTodayAnalyticsProvider =
    FutureProvider<TodayAnalyticsProjection>((ref) async {
      ref.watch(studyAnalyticsRevisionProvider);
      final ownerId = ref.watch(publicAuthSessionProvider).user?.id;
      final summary = await ref.watch(getAnalyticsSummaryProvider)(ownerId);
      final daily = summary.daily;
      return TodayAnalyticsProjection(
        isLoading: false,
        focusedDuration: daily.focusedDuration,
        completedSessions: daily.completedSessions,
        interruptionCount: daily.interruptionCount,
        interruptionDuration: daily.interruptionDuration,
        mostStudiedCourseName: daily.mostStudiedCourse?.courseName,
      );
    });
