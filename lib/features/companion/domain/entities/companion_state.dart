import 'package:focusly/features/analytics/domain/entities/study_trends.dart';

final class StudyCompanion {
  const StudyCompanion({required this.id, required this.name});

  final String id;
  final String name;
}

enum CompanionMood { relaxed, focused, encouraging, celebrating, resting }

enum CompanionExpression { normal, happy, thinking, cheering, sleeping }

final class CompanionAnalyticsSummary {
  const CompanionAnalyticsSummary({
    required this.focusMinutesToday,
    required this.completedSessionsToday,
    required this.interruptionCountToday,
    required this.activeDaysThisWeek,
  });

  final int focusMinutesToday;
  final int completedSessionsToday;
  final int interruptionCountToday;
  final int activeDaysThisWeek;
}

final class CompanionProgress {
  const CompanionProgress({
    required this.focusMinutesToday,
    required this.completedSessionsToday,
    required this.activeDays,
    required this.weeklyTrend,
  });

  final int focusMinutesToday;
  final int completedSessionsToday;
  final int activeDays;
  final TrendDirection? weeklyTrend;
}

final class CompanionSnapshot {
  const CompanionSnapshot({
    required this.mood,
    required this.expression,
    required this.progress,
    required this.message,
  });

  final CompanionMood mood;
  final CompanionExpression expression;
  final CompanionProgress progress;
  final String message;
}
