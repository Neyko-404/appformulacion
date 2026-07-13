import 'package:focusly/features/analytics/domain/entities/study_analytics.dart';
import 'package:focusly/features/analytics/domain/entities/study_insight.dart';
import 'package:focusly/features/analytics/domain/entities/study_trends.dart';

abstract interface class StudyInsightRule {
  StudyInsight? evaluate({
    required StudyAnalyticsSummary analyticsSummary,
    required StudyTrendSummary trendSummary,
    required InsightDashboardSummary dashboardSummary,
    required InsightProfileProjection profileProjection,
  });
}

final class NoCoursesRule implements StudyInsightRule {
  const NoCoursesRule();

  @override
  StudyInsight? evaluate({
    required StudyAnalyticsSummary analyticsSummary,
    required StudyTrendSummary trendSummary,
    required InsightDashboardSummary dashboardSummary,
    required InsightProfileProjection profileProjection,
  }) => dashboardSummary.hasCourses
      ? null
      : const StudyInsight(
          id: 'courses.missing',
          category: InsightCategory.course,
          priority: InsightPriority.high,
          title: 'Organiza tus materias',
          message: 'Agregar cursos facilitará organizar tu progreso.',
          action: InsightAction.openCourses,
          createdFromRule: 'no_courses',
        );
}

final class NoActivityRule implements StudyInsightRule {
  const NoActivityRule();

  @override
  StudyInsight? evaluate({
    required StudyAnalyticsSummary analyticsSummary,
    required StudyTrendSummary trendSummary,
    required InsightDashboardSummary dashboardSummary,
    required InsightProfileProjection profileProjection,
  }) =>
      analyticsSummary.daily.completedSessions != 0 ||
          dashboardSummary.hasActiveSession
      ? null
      : const StudyInsight(
          id: 'focus.no_activity_today',
          category: InsightCategory.focus,
          priority: InsightPriority.medium,
          title: 'Un paso a la vez',
          message: 'Puedes comenzar con una sesión corta.',
          action: InsightAction.startFocus,
          createdFromRule: 'no_activity_today',
        );
}

final class ManyInterruptionsRule implements StudyInsightRule {
  const ManyInterruptionsRule();

  @override
  StudyInsight? evaluate({
    required StudyAnalyticsSummary analyticsSummary,
    required StudyTrendSummary trendSummary,
    required InsightDashboardSummary dashboardSummary,
    required InsightProfileProjection profileProjection,
  }) => analyticsSummary.daily.interruptionCount < 3
      ? null
      : const StudyInsight(
          id: 'interruptions.many_today',
          category: InsightCategory.interruption,
          priority: InsightPriority.high,
          title: 'Retoma con calma',
          message: 'Hoy hubo varias pausas fuera de Focusly.',
          action: InsightAction.startFocus,
          createdFromRule: 'many_interruptions_today',
        );
}

final class WeeklyIncreaseRule implements StudyInsightRule {
  const WeeklyIncreaseRule();

  @override
  StudyInsight? evaluate({
    required StudyAnalyticsSummary analyticsSummary,
    required StudyTrendSummary trendSummary,
    required InsightDashboardSummary dashboardSummary,
    required InsightProfileProjection profileProjection,
  }) {
    final value = trendSummary.weekly.focusedMinutes;
    return value.currentValue > 0 &&
            value.previousValue > 0 &&
            value.direction == TrendDirection.up
        ? const StudyInsight(
            id: 'progress.weekly_increase',
            category: InsightCategory.progress,
            priority: InsightPriority.medium,
            title: 'Tu progreso aumentó',
            message: 'Has aumentado tu tiempo de estudio.',
            action: InsightAction.reviewProgress,
            createdFromRule: 'weekly_focus_increased',
          )
        : null;
  }
}

final class WeeklyDecreaseRule implements StudyInsightRule {
  const WeeklyDecreaseRule();

  @override
  StudyInsight? evaluate({
    required StudyAnalyticsSummary analyticsSummary,
    required StudyTrendSummary trendSummary,
    required InsightDashboardSummary dashboardSummary,
    required InsightProfileProjection profileProjection,
  }) {
    final value = trendSummary.weekly.focusedMinutes;
    return value.currentValue > 0 &&
            value.previousValue > 0 &&
            value.direction == TrendDirection.down
        ? const StudyInsight(
            id: 'progress.weekly_decrease',
            category: InsightCategory.progress,
            priority: InsightPriority.medium,
            title: 'Tu ritmo cambió',
            message: 'Esta semana estudiaste un poco menos.',
            action: InsightAction.reviewProgress,
            createdFromRule: 'weekly_focus_decreased',
          )
        : null;
  }
}

final class DominantCourseChangedRule implements StudyInsightRule {
  const DominantCourseChangedRule();

  @override
  StudyInsight? evaluate({
    required StudyAnalyticsSummary analyticsSummary,
    required StudyTrendSummary trendSummary,
    required InsightDashboardSummary dashboardSummary,
    required InsightProfileProjection profileProjection,
  }) {
    final current = trendSummary.weekly.currentDominantCourse;
    final previous = trendSummary.weekly.previousDominantCourse;
    return current == null || previous == null || current == previous
        ? null
        : StudyInsight(
            id: 'course.dominant_changed',
            category: InsightCategory.course,
            priority: InsightPriority.low,
            title: 'Tu atención cambió',
            message: 'Tu atención se concentró más en $current.',
            action: InsightAction.openAnalytics,
            createdFromRule: 'dominant_course_changed',
          );
  }
}

final class ConsistencyRule implements StudyInsightRule {
  const ConsistencyRule();

  @override
  StudyInsight? evaluate({
    required StudyAnalyticsSummary analyticsSummary,
    required StudyTrendSummary trendSummary,
    required InsightDashboardSummary dashboardSummary,
    required InsightProfileProjection profileProjection,
  }) => analyticsSummary.weekly.activeStudyDays < 5
      ? null
      : const StudyInsight(
          id: 'consistency.five_days',
          category: InsightCategory.consistency,
          priority: InsightPriority.low,
          title: 'Ritmo constante',
          message: 'Has mantenido una buena constancia.',
          action: InsightAction.openAnalytics,
          createdFromRule: 'five_active_days',
        );
}

const defaultStudyInsightRules = <StudyInsightRule>[
  NoCoursesRule(),
  ManyInterruptionsRule(),
  NoActivityRule(),
  WeeklyIncreaseRule(),
  WeeklyDecreaseRule(),
  DominantCourseChangedRule(),
  ConsistencyRule(),
];
