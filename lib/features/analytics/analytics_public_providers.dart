import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/academic_tracker/course_public_providers.dart';
import 'package:focusly/features/analytics/application/providers/analytics_providers.dart';
import 'package:focusly/features/analytics/domain/entities/study_analytics.dart';
import 'package:focusly/features/analytics/domain/entities/study_insight.dart';
import 'package:focusly/features/analytics/domain/entities/study_trends.dart';
import 'package:focusly/features/analytics/domain/services/study_insight_engine.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/study_engine/study_analytics_read_api.dart';
import 'package:focusly/features/study_engine/study_engine_public_providers.dart';

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
    this.insights = const InsightCollection.empty(),
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
  final InsightCollection insights;
}

final class DashboardTrendProjection {
  const DashboardTrendProjection({
    required this.message,
    required this.direction,
  });

  final String message;
  final TrendDirection direction;
}

final class CompanionAnalyticsProjection {
  const CompanionAnalyticsProjection({
    required this.focusMinutesToday,
    required this.completedSessionsToday,
    required this.interruptionCountToday,
    required this.activeDaysThisWeek,
    required this.weeklyTrend,
  });

  final int focusMinutesToday;
  final int completedSessionsToday;
  final int interruptionCountToday;
  final int activeDaysThisWeek;
  final TrendDirection? weeklyTrend;
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

final analyticsInsightsProvider = Provider<InsightCollection>((ref) {
  final summary = ref.watch(analyticsNotifierProvider).summary;
  if (summary == null) return const InsightCollection.empty();
  return _insights(
    summary,
    ref.watch(activeCoursesProvider),
    ref.watch(activeStudySummaryProvider),
  );
});

final companionAnalyticsProvider = Provider<CompanionAnalyticsProjection?>((
  ref,
) {
  final summary = ref.watch(analyticsNotifierProvider).summary;
  if (summary == null) return null;
  final weeklyFocus = summary.trends.weekly.focusedMinutes;
  return CompanionAnalyticsProjection(
    focusMinutesToday: summary.daily.focusedDuration.inMinutes,
    completedSessionsToday: summary.daily.completedSessions,
    interruptionCountToday: summary.daily.interruptionCount,
    activeDaysThisWeek: summary.weekly.activeStudyDays,
    weeklyTrend: weeklyFocus.currentValue == 0 && weeklyFocus.previousValue == 0
        ? null
        : weeklyFocus.direction,
  );
});

final dashboardTodayAnalyticsProvider =
    FutureProvider<TodayAnalyticsProjection>((ref) async {
      ref.watch(studyAnalyticsRevisionProvider);
      final ownerId = ref.watch(publicAuthSessionProvider).user?.id;
      final courses = ref.watch(activeCoursesProvider);
      final study = ref.watch(activeStudySummaryProvider);
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
        insights: _insights(summary, courses, study),
      );
    });

InsightCollection _insights(
  StudyAnalyticsSummary summary,
  ActiveCoursesSnapshot courses,
  ActiveStudySummary study,
) => const StudyInsightEngine().generate(
  analyticsSummary: summary,
  trendSummary: summary.trends,
  dashboardSummary: InsightDashboardSummary(
    hasActiveSession: study.session != null,
    hasCourses: courses.courses.isNotEmpty,
  ),
  profileProjection: const InsightProfileProjection(),
);

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
