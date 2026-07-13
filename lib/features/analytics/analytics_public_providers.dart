import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/analytics/application/providers/analytics_providers.dart';
import 'package:focusly/features/analytics/domain/entities/study_trends.dart';
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
    this.weeklyTrend,
  });

  final bool isLoading;
  final Duration focusedDuration;
  final int completedSessions;
  final int interruptionCount;
  final Duration interruptionDuration;
  final bool hasData;
  final String? mostStudiedCourseName;
  final String? errorMessage;
  final DashboardTrendProjection? weeklyTrend;
}

final class DashboardTrendProjection {
  const DashboardTrendProjection({
    required this.message,
    required this.direction,
  });

  final String message;
  final TrendDirection direction;
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
    weeklyTrend: daily == null || state.summary == null
        ? null
        : projectDashboardWeeklyTrend(
            state.summary!.trends.weekly.focusedMinutes,
          ),
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
        weeklyTrend: projectDashboardWeeklyTrend(
          summary.trends.weekly.focusedMinutes,
        ),
      );
    });

DashboardTrendProjection? projectDashboardWeeklyTrend(TrendComparison value) {
  final percentage = value.percentageVariation;
  if (value.currentValue == 0 && value.previousValue == 0) return null;
  if (value.currentValue == 0 && value.previousValue > 0) {
    return const DashboardTrendProjection(
      message: 'Esta semana aún no registras tiempo de estudio.',
      direction: TrendDirection.down,
    );
  }
  if (value.direction == TrendDirection.stable) {
    return const DashboardTrendProjection(
      message: 'Mantienes un ritmo similar a la semana pasada.',
      direction: TrendDirection.stable,
    );
  }
  if (percentage == null) {
    return DashboardTrendProjection(
      message: 'Comenzaste a sumar tiempo de estudio esta semana.',
      direction: value.direction,
    );
  }
  final amount = percentage.abs().round();
  return DashboardTrendProjection(
    message: value.direction == TrendDirection.up
        ? '$amount % más tiempo que la semana pasada.'
        : '$amount % menos tiempo que la semana pasada.',
    direction: value.direction,
  );
}
