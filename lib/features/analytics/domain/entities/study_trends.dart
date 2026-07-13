enum TrendDirection { up, down, stable }

final class TrendComparison {
  const TrendComparison({
    required this.currentValue,
    required this.previousValue,
    required this.signedDifference,
    required this.absoluteDifference,
    required this.percentageVariation,
    required this.direction,
  });

  final double currentValue;
  final double previousValue;
  final double signedDifference;
  final double absoluteDifference;

  /// Null means the previous value was zero, so a percentage has no honest
  /// mathematical meaning. Direction still communicates new activity.
  final double? percentageVariation;
  final TrendDirection direction;
}

final class CourseTrend {
  const CourseTrend({
    required this.courseId,
    required this.courseName,
    required this.focusedMinutes,
  });

  final String courseId;
  final String courseName;
  final TrendComparison focusedMinutes;
}

final class WeeklyTrend {
  const WeeklyTrend({
    required this.focusedMinutes,
    required this.completedSessions,
    required this.averageSessionMinutes,
    required this.interruptions,
    required this.activeDays,
    required this.courseTrends,
    this.currentDominantCourse,
    this.previousDominantCourse,
  });

  final TrendComparison focusedMinutes;
  final TrendComparison completedSessions;
  final TrendComparison averageSessionMinutes;
  final TrendComparison interruptions;
  final TrendComparison activeDays;
  final List<CourseTrend> courseTrends;
  final String? currentDominantCourse;
  final String? previousDominantCourse;
}

final class MonthlyTrend {
  const MonthlyTrend({
    required this.focusedMinutes,
    required this.completedSessions,
    required this.averageSessionMinutes,
    required this.interruptions,
    required this.activeDays,
    required this.courseTrends,
    this.currentDominantCourse,
    this.previousDominantCourse,
  });

  final TrendComparison focusedMinutes;
  final TrendComparison completedSessions;
  final TrendComparison averageSessionMinutes;
  final TrendComparison interruptions;
  final TrendComparison activeDays;
  final List<CourseTrend> courseTrends;
  final String? currentDominantCourse;
  final String? previousDominantCourse;
}

final class StudyTrendSummary {
  const StudyTrendSummary({required this.weekly, required this.monthly});

  final WeeklyTrend weekly;
  final MonthlyTrend monthly;
}
