import 'package:focusly/features/analytics/domain/entities/study_analytics.dart';
import 'package:focusly/features/analytics/domain/entities/study_trends.dart';

final class TrendCalculator {
  const TrendCalculator();

  StudyTrendSummary calculate({
    required WeeklyStudyAnalytics currentWeek,
    required WeeklyStudyAnalytics previousWeek,
    required MonthlyStudyAnalytics currentMonth,
    required MonthlyStudyAnalytics previousMonth,
    required List<CourseStudyAnalytics> currentWeekCourses,
    required List<CourseStudyAnalytics> previousWeekCourses,
    required List<CourseStudyAnalytics> currentMonthCourses,
    required List<CourseStudyAnalytics> previousMonthCourses,
  }) => StudyTrendSummary(
    weekly: WeeklyTrend(
      focusedMinutes: compare(
        currentWeek.focusedDuration.inMinutes,
        previousWeek.focusedDuration.inMinutes,
      ),
      completedSessions: compare(
        currentWeek.completedSessions,
        previousWeek.completedSessions,
      ),
      averageSessionMinutes: compare(
        currentWeek.averageCompletedSessionDuration.inMinutes,
        previousWeek.averageCompletedSessionDuration.inMinutes,
      ),
      interruptions: compare(
        currentWeek.interruptionCount,
        previousWeek.interruptionCount,
      ),
      activeDays: compare(
        currentWeek.activeStudyDays,
        previousWeek.activeStudyDays,
      ),
      courseTrends: _courses(currentWeekCourses, previousWeekCourses),
      currentDominantCourse: currentWeek.mostStudiedCourse?.courseName,
      previousDominantCourse: previousWeek.mostStudiedCourse?.courseName,
    ),
    monthly: MonthlyTrend(
      focusedMinutes: compare(
        currentMonth.focusedDuration.inMinutes,
        previousMonth.focusedDuration.inMinutes,
      ),
      completedSessions: compare(
        currentMonth.completedSessions,
        previousMonth.completedSessions,
      ),
      averageSessionMinutes: compare(
        _averageMinutes(currentMonth),
        _averageMinutes(previousMonth),
      ),
      interruptions: compare(
        currentMonth.interruptionCount,
        previousMonth.interruptionCount,
      ),
      activeDays: compare(
        currentMonth.activeStudyDays,
        previousMonth.activeStudyDays,
      ),
      courseTrends: _courses(currentMonthCourses, previousMonthCourses),
      currentDominantCourse: currentMonth.mostStudiedCourse?.courseName,
      previousDominantCourse: previousMonth.mostStudiedCourse?.courseName,
    ),
  );

  TrendComparison compare(num current, num previous) {
    final currentValue = current.toDouble();
    final previousValue = previous.toDouble();
    final difference = currentValue - previousValue;
    return TrendComparison(
      currentValue: currentValue,
      previousValue: previousValue,
      signedDifference: difference,
      absoluteDifference: difference.abs(),
      percentageVariation: previousValue == 0
          ? null
          : difference / previousValue * 100,
      direction: difference > 0
          ? TrendDirection.up
          : difference < 0
          ? TrendDirection.down
          : TrendDirection.stable,
    );
  }

  int _averageMinutes(MonthlyStudyAnalytics value) =>
      value.completedSessions == 0
      ? 0
      : value.focusedDuration.inMinutes ~/ value.completedSessions;

  List<CourseTrend> _courses(
    List<CourseStudyAnalytics> current,
    List<CourseStudyAnalytics> previous,
  ) {
    final currentById = {for (final value in current) value.courseId: value};
    final previousById = {for (final value in previous) value.courseId: value};
    final ids = {...currentById.keys, ...previousById.keys};
    final trends = ids.map((id) {
      final currentValue = currentById[id];
      final previousValue = previousById[id];
      return CourseTrend(
        courseId: id,
        courseName:
            currentValue?.courseName ??
            previousValue?.courseName ??
            'Curso no disponible',
        focusedMinutes: compare(
          currentValue?.focusedDuration.inMinutes ?? 0,
          previousValue?.focusedDuration.inMinutes ?? 0,
        ),
      );
    }).toList();
    trends.sort((a, b) {
      final difference = b.focusedMinutes.signedDifference.compareTo(
        a.focusedMinutes.signedDifference,
      );
      if (difference != 0) return difference;
      final name = _sortName(a.courseName).compareTo(_sortName(b.courseName));
      return name != 0 ? name : a.courseId.compareTo(b.courseId);
    });
    return List.unmodifiable(trends);
  }

  String _sortName(String value) => value
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ü', 'u')
      .replaceAll('ñ', 'n');
}
