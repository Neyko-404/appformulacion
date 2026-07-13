import 'package:focusly/features/analytics/domain/entities/study_insight.dart';
import 'package:focusly/features/analytics/domain/entities/study_trends.dart';
import 'package:focusly/features/companion/domain/entities/companion_state.dart';

final class CompanionStateEngine {
  const CompanionStateEngine();

  CompanionSnapshot derive({
    required CompanionAnalyticsSummary analyticsSummary,
    required TrendDirection? trendSummary,
    required InsightCollection studyInsights,
  }) {
    final progress = CompanionProgress(
      focusMinutesToday: analyticsSummary.focusMinutesToday,
      completedSessionsToday: analyticsSummary.completedSessionsToday,
      activeDays: analyticsSummary.activeDaysThisWeek,
      weeklyTrend: trendSummary,
    );
    if (analyticsSummary.focusMinutesToday == 0 &&
        analyticsSummary.completedSessionsToday == 0) {
      return CompanionSnapshot(
        mood: CompanionMood.resting,
        expression: CompanionExpression.sleeping,
        progress: progress,
        message: 'Estoy listo para acompañarte.',
      );
    }
    if (analyticsSummary.interruptionCountToday >= 3 ||
        studyInsights.values.any(
          (value) => value.category == InsightCategory.interruption,
        )) {
      return CompanionSnapshot(
        mood: CompanionMood.encouraging,
        expression: CompanionExpression.thinking,
        progress: progress,
        message: 'Sigamos cuando quieras.',
      );
    }
    if (trendSummary == TrendDirection.up) {
      return CompanionSnapshot(
        mood: CompanionMood.celebrating,
        expression: analyticsSummary.completedSessionsToday >= 2
            ? CompanionExpression.cheering
            : CompanionExpression.happy,
        progress: progress,
        message: 'Buen trabajo.',
      );
    }
    if (analyticsSummary.completedSessionsToday >= 2) {
      return CompanionSnapshot(
        mood: CompanionMood.focused,
        expression: CompanionExpression.normal,
        progress: progress,
        message: 'Buen trabajo. Sigamos cuando quieras.',
      );
    }
    if (analyticsSummary.completedSessionsToday == 1) {
      return CompanionSnapshot(
        mood: CompanionMood.encouraging,
        expression: CompanionExpression.thinking,
        progress: progress,
        message: 'Buen trabajo.',
      );
    }
    return CompanionSnapshot(
      mood: CompanionMood.relaxed,
      expression: CompanionExpression.normal,
      progress: progress,
      message: 'Sigamos cuando quieras.',
    );
  }
}
