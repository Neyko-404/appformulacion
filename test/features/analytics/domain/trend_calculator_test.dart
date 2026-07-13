import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/analytics/application/use_cases/get_analytics_summary.dart';
import 'package:focusly/features/analytics/domain/entities/study_analytics.dart';
import 'package:focusly/features/analytics/domain/entities/study_trends.dart';
import 'package:focusly/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:focusly/features/analytics/domain/services/analytics_date_ranges.dart';
import 'package:focusly/features/analytics/domain/services/trend_calculator.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/study_analytics_reader.dart';

void main() {
  const calculator = TrendCalculator();

  test('zero previous value avoids division by zero', () {
    final value = calculator.compare(30, 0);
    expect(value.direction, TrendDirection.up);
    expect(value.absoluteDifference, 30);
    expect(value.percentageVariation, isNull);

    final zero = calculator.compare(0, 0);
    expect(zero.direction, TrendDirection.stable);
    expect(zero.percentageVariation, isNull);
  });

  test('calculates improvement, decrease, stable and percentages', () {
    final improvement = calculator.compare(120, 100);
    expect(improvement.signedDifference, 20);
    expect(improvement.absoluteDifference, 20);
    expect(improvement.percentageVariation, 20);
    expect(improvement.direction, TrendDirection.up);

    final decrease = calculator.compare(50, 100);
    expect(decrease.signedDifference, -50);
    expect(decrease.absoluteDifference, 50);
    expect(decrease.percentageVariation, -50);
    expect(decrease.direction, TrendDirection.down);

    final stable = calculator.compare(80, 80);
    expect(stable.signedDifference, 0);
    expect(stable.absoluteDifference, 0);
    expect(stable.direction, TrendDirection.stable);
  });

  test('absolute difference is never negative', () {
    for (final values in [(120, 100), (50, 100), (80, 80), (0, 10)]) {
      expect(
        calculator.compare(values.$1, values.$2).absoluteDifference,
        greaterThanOrEqualTo(0),
      );
    }
  });

  test('builds weekly and monthly comparisons', () {
    final summary = calculator.calculate(
      currentWeek: weekly(minutes: 120, sessions: 3, interruptions: 1, days: 3),
      previousWeek: weekly(minutes: 60, sessions: 2, interruptions: 3, days: 2),
      currentMonth: monthly(
        minutes: 300,
        sessions: 6,
        interruptions: 4,
        days: 8,
      ),
      previousMonth: monthly(
        minutes: 200,
        sessions: 5,
        interruptions: 6,
        days: 6,
      ),
      currentWeekCourses: const [],
      previousWeekCourses: const [],
      currentMonthCourses: const [],
      previousMonthCourses: const [],
    );

    expect(summary.weekly.focusedMinutes.percentageVariation, 100);
    expect(summary.weekly.interruptions.direction, TrendDirection.down);
    expect(summary.weekly.activeDays.absoluteDifference, 1);
    expect(summary.monthly.averageSessionMinutes.currentValue, 50);
    expect(summary.monthly.averageSessionMinutes.previousValue, 40);
  });

  test('course growth uses deterministic difference and name tie-break', () {
    final summary = calculator.calculate(
      currentWeek: weekly(),
      previousWeek: weekly(),
      currentMonth: monthly(),
      previousMonth: monthly(),
      currentWeekCourses: [
        course('b', 'Biología', 30),
        course('a', 'Álgebra', 30),
      ],
      previousWeekCourses: const [],
      currentMonthCourses: const [],
      previousMonthCourses: const [],
    );

    expect(summary.weekly.courseTrends.map((value) => value.courseId), [
      'a',
      'b',
    ]);
  });

  test('course growth orders signed gains before declines', () {
    final summary = calculator.calculate(
      currentWeek: weekly(),
      previousWeek: weekly(),
      currentMonth: monthly(),
      previousMonth: monthly(),
      currentWeekCourses: [
        course('growth', 'Cálculo', 40),
        course('decline', 'Física', 10),
      ],
      previousWeekCourses: [
        course('growth', 'Cálculo', 20),
        course('decline', 'Física', 80),
      ],
      currentMonthCourses: const [],
      previousMonthCourses: const [],
    );

    expect(summary.weekly.courseTrends.first.courseId, 'growth');
    expect(
      summary.weekly.courseTrends.first.focusedMinutes.signedDifference,
      20,
    );
    expect(
      summary.weekly.courseTrends.last.focusedMinutes.signedDifference,
      -70,
    );
  });

  test('previous week keeps civil boundaries across month and year', () async {
    for (final scenario in [
      (now: DateTime(2026, 1, 1), previousActivity: DateTime(2025, 12, 28)),
      (now: DateTime(2026, 3, 2), previousActivity: DateTime(2026, 2, 28)),
    ]) {
      final session = _completedSession(scenario.previousActivity);
      final value = await GetAnalyticsSummary(
        repository: _TrendRepository([
          StudyAnalyticsRecord(session: session, interruptions: const []),
        ]),
        clock: _TrendClock(scenario.now),
      )('user-1');

      expect(value.trends.weekly.focusedMinutes.currentValue, 0);
      expect(value.trends.weekly.focusedMinutes.previousValue, 20);
    }
  });
}

StudySession _completedSession(DateTime completedAt) => StudySession(
  id: completedAt.toIso8601String(),
  ownerId: 'user-1',
  mode: StudyMode.focus,
  status: StudySessionStatus.completed,
  plannedDuration: const Duration(minutes: 20),
  accumulatedFocusDuration: const Duration(minutes: 20),
  startedAt: completedAt.subtract(const Duration(minutes: 20)),
  completedAt: completedAt,
  createdAt: completedAt.subtract(const Duration(minutes: 20)),
  updatedAt: completedAt,
);

final class _TrendClock implements AnalyticsClock {
  const _TrendClock(this.value);
  final DateTime value;
  @override
  DateTime now() => value;
}

final class _TrendRepository implements AnalyticsRepository {
  const _TrendRepository(this.records);
  final List<StudyAnalyticsRecord> records;
  @override
  Future<AnalyticsSourceSnapshot> read(String ownerId) async =>
      AnalyticsSourceSnapshot(records: records, courses: const []);
}

WeeklyStudyAnalytics weekly({
  int minutes = 0,
  int sessions = 0,
  int interruptions = 0,
  int days = 0,
}) => WeeklyStudyAnalytics(
  weekStart: DateTime(2026, 7, 6),
  weekEndExclusive: DateTime(2026, 7, 13),
  focusedDuration: Duration(minutes: minutes),
  completedSessions: sessions,
  cancelledSessions: 0,
  interruptionCount: interruptions,
  interruptionDuration: Duration.zero,
  averageCompletedSessionDuration: sessions == 0
      ? Duration.zero
      : Duration(minutes: minutes ~/ sessions),
  activeStudyDays: days,
);

MonthlyStudyAnalytics monthly({
  int minutes = 0,
  int sessions = 0,
  int interruptions = 0,
  int days = 0,
}) => MonthlyStudyAnalytics(
  monthStart: DateTime(2026, 7),
  monthEndExclusive: DateTime(2026, 8),
  focusedDuration: Duration(minutes: minutes),
  completedSessions: sessions,
  cancelledSessions: 0,
  interruptionCount: interruptions,
  interruptionDuration: Duration.zero,
  activeStudyDays: days,
);

CourseStudyAnalytics course(String id, String name, int minutes) =>
    CourseStudyAnalytics(
      courseId: id,
      courseName: name,
      focusedDuration: Duration(minutes: minutes),
      completedSessions: 1,
      cancelledSessions: 0,
      interruptionCount: 0,
    );
