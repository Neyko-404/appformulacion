import 'package:focusly/features/analytics/domain/entities/study_trends.dart';

final class MostStudiedCourse {
  const MostStudiedCourse({
    required this.courseId,
    required this.courseName,
    required this.focusedDuration,
    required this.completedSessions,
  });

  final String courseId;
  final String courseName;
  final Duration focusedDuration;
  final int completedSessions;
}

final class DailyStudyAnalytics {
  const DailyStudyAnalytics({
    required this.date,
    required this.focusedDuration,
    required this.completedSessions,
    required this.cancelledSessions,
    required this.activeSessions,
    required this.interruptionCount,
    required this.interruptionDuration,
    this.mostStudiedCourse,
  });

  final DateTime date;
  final Duration focusedDuration;
  final int completedSessions;
  final int cancelledSessions;
  final int activeSessions;
  final int interruptionCount;
  final Duration interruptionDuration;
  final MostStudiedCourse? mostStudiedCourse;
}

final class WeeklyStudyAnalytics {
  const WeeklyStudyAnalytics({
    required this.weekStart,
    required this.weekEndExclusive,
    required this.focusedDuration,
    required this.completedSessions,
    required this.cancelledSessions,
    required this.interruptionCount,
    required this.interruptionDuration,
    required this.averageCompletedSessionDuration,
    required this.activeStudyDays,
    this.mostStudiedCourse,
  });

  final DateTime weekStart;
  final DateTime weekEndExclusive;
  final Duration focusedDuration;
  final int completedSessions;
  final int cancelledSessions;
  final int interruptionCount;
  final Duration interruptionDuration;
  final Duration averageCompletedSessionDuration;
  final int activeStudyDays;
  final MostStudiedCourse? mostStudiedCourse;
}

final class MonthlyStudyAnalytics {
  const MonthlyStudyAnalytics({
    required this.monthStart,
    required this.monthEndExclusive,
    required this.focusedDuration,
    required this.completedSessions,
    required this.cancelledSessions,
    required this.interruptionCount,
    required this.interruptionDuration,
    required this.activeStudyDays,
    this.mostStudiedCourse,
  });

  final DateTime monthStart;
  final DateTime monthEndExclusive;
  final Duration focusedDuration;
  final int completedSessions;
  final int cancelledSessions;
  final int interruptionCount;
  final Duration interruptionDuration;
  final int activeStudyDays;
  final MostStudiedCourse? mostStudiedCourse;
}

final class CourseStudyAnalytics {
  const CourseStudyAnalytics({
    required this.courseId,
    required this.courseName,
    required this.focusedDuration,
    required this.completedSessions,
    required this.cancelledSessions,
    required this.interruptionCount,
    this.lastStudiedAt,
  });

  final String courseId;
  final String courseName;
  final Duration focusedDuration;
  final int completedSessions;
  final int cancelledSessions;
  final int interruptionCount;
  final DateTime? lastStudiedAt;
}

final class StudyAnalyticsSummary {
  const StudyAnalyticsSummary({
    required this.daily,
    required this.weekly,
    required this.monthly,
    required this.courses,
    required this.trends,
  });

  final DailyStudyAnalytics daily;
  final WeeklyStudyAnalytics weekly;
  final MonthlyStudyAnalytics monthly;
  final List<CourseStudyAnalytics> courses;
  final StudyTrendSummary trends;

  bool get isEmpty =>
      monthly.completedSessions == 0 &&
      monthly.cancelledSessions == 0 &&
      monthly.interruptionCount == 0 &&
      daily.activeSessions == 0 &&
      trends.weekly.focusedMinutes.previousValue == 0 &&
      trends.weekly.completedSessions.previousValue == 0 &&
      trends.weekly.interruptions.previousValue == 0 &&
      trends.monthly.focusedMinutes.previousValue == 0 &&
      trends.monthly.completedSessions.previousValue == 0 &&
      trends.monthly.interruptions.previousValue == 0;
}
