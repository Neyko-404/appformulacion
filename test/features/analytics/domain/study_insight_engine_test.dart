import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/analytics/domain/entities/study_analytics.dart';
import 'package:focusly/features/analytics/domain/entities/study_insight.dart';
import 'package:focusly/features/analytics/domain/entities/study_trends.dart';
import 'package:focusly/features/analytics/domain/services/study_insight_engine.dart';
import 'package:focusly/features/analytics/domain/services/study_insight_rule.dart';

void main() {
  const engine = StudyInsightEngine();

  InsightCollection generate({
    int completedToday = 1,
    int interruptionsToday = 0,
    int activeDays = 1,
    bool hasCourses = true,
    bool hasActiveSession = false,
    double currentWeek = 60,
    double previousWeek = 60,
    String? currentCourse,
    String? previousCourse,
  }) {
    final trends = _trends(
      currentWeek: currentWeek,
      previousWeek: previousWeek,
      currentCourse: currentCourse,
      previousCourse: previousCourse,
    );
    return engine.generate(
      analyticsSummary: _summary(
        completedToday: completedToday,
        interruptionsToday: interruptionsToday,
        activeDays: activeDays,
        trends: trends,
      ),
      trendSummary: trends,
      dashboardSummary: InsightDashboardSummary(
        hasActiveSession: hasActiveSession,
        hasCourses: hasCourses,
      ),
      profileProjection: const InsightProfileProjection(
        preferredFocusMinutes: 25,
      ),
    );
  }

  test('creates the no-activity and no-courses rules', () {
    final values = generate(completedToday: 0, hasCourses: false).values;
    expect(values.map((value) => value.createdFromRule), [
      'no_courses',
      'no_activity_today',
    ]);
    expect(values.first.action, InsightAction.openCourses);
  });

  test('active session suppresses the no-activity suggestion', () {
    final values = generate(completedToday: 0, hasActiveSession: true).values;
    expect(values, isEmpty);
  });

  test('creates neutral interruption and weekly progress rules', () {
    final values = generate(
      interruptionsToday: 4,
      currentWeek: 120,
      previousWeek: 60,
    ).values;
    expect(values.first.createdFromRule, 'many_interruptions_today');
    expect(values.last.createdFromRule, 'weekly_focus_increased');
    expect(values.first.message, isNot(contains('fallando')));
  });

  test('weekly decrease uses neutral copy', () {
    final value = generate(currentWeek: 30, previousWeek: 60).values.single;
    expect(value.createdFromRule, 'weekly_focus_decreased');
    expect(value.message, 'Esta semana estudiaste un poco menos.');
  });

  test('creates dominant course and consistency rules', () {
    final values = generate(
      activeDays: 5,
      currentCourse: 'Bases de Datos',
      previousCourse: 'Cálculo',
    ).values;
    expect(values.map((value) => value.createdFromRule), [
      'dominant_course_changed',
      'five_active_days',
    ]);
    expect(values.first.message, contains('Bases de Datos'));
  });

  test(
    'orders by priority, removes category duplicates and returns at most 3',
    () {
      final values = generate(
        completedToday: 0,
        interruptionsToday: 5,
        activeDays: 6,
        hasCourses: false,
        currentWeek: 120,
        previousWeek: 60,
        currentCourse: 'Bases de Datos',
        previousCourse: 'Cálculo',
      ).values;
      expect(values, hasLength(3));
      expect(values.map((value) => value.priority), [
        InsightPriority.high,
        InsightPriority.high,
        InsightPriority.medium,
      ]);
      expect(values.map((value) => value.id).toSet(), hasLength(3));
      expect(values.map((value) => value.category).toSet(), hasLength(3));
    },
  );

  test('engine remains pure and non-persistent', () {
    final source = File(
      'lib/features/analytics/domain/services/study_insight_engine.dart',
    ).readAsStringSync();
    for (final forbidden in [
      'flutter',
      'riverpod',
      'firebase',
      'isar',
      'Random',
      'DateTime.now',
      'Repository',
      '.save(',
      '.write(',
    ]) {
      expect(source.toLowerCase(), isNot(contains(forbidden.toLowerCase())));
    }
    expect(source, isNot(contains('StudyInsight(')));
    expect(source, isNot(contains('createdFromRule:')));
  });

  test('engine executes only its injected rules', () {
    const customEngine = StudyInsightEngine(
      rules: [
        _FixedRule(
          StudyInsight(
            id: 'custom',
            category: InsightCategory.general,
            priority: InsightPriority.low,
            title: 'Personalizado',
            message: 'Regla inyectada.',
            action: InsightAction.none,
            createdFromRule: 'custom_rule',
          ),
        ),
      ],
    );
    final trends = _trends(currentWeek: 60, previousWeek: 60);
    final values = customEngine
        .generate(
          analyticsSummary: _summary(
            completedToday: 0,
            interruptionsToday: 10,
            activeDays: 7,
            trends: trends,
          ),
          trendSummary: trends,
          dashboardSummary: const InsightDashboardSummary(
            hasActiveSession: false,
            hasCourses: false,
          ),
          profileProjection: const InsightProfileProjection(),
        )
        .values;
    expect(values.map((value) => value.id), ['custom']);
  });
}

final class _FixedRule implements StudyInsightRule {
  const _FixedRule(this.value);
  final StudyInsight value;

  @override
  StudyInsight? evaluate({
    required StudyAnalyticsSummary analyticsSummary,
    required StudyTrendSummary trendSummary,
    required InsightDashboardSummary dashboardSummary,
    required InsightProfileProjection profileProjection,
  }) => value;
}

StudyAnalyticsSummary _summary({
  required int completedToday,
  required int interruptionsToday,
  required int activeDays,
  required StudyTrendSummary trends,
}) => StudyAnalyticsSummary(
  daily: DailyStudyAnalytics(
    date: DateTime(2026, 7, 12),
    focusedDuration: Duration(minutes: completedToday * 25),
    completedSessions: completedToday,
    cancelledSessions: 0,
    activeSessions: 0,
    interruptionCount: interruptionsToday,
    interruptionDuration: Duration.zero,
  ),
  weekly: WeeklyStudyAnalytics(
    weekStart: DateTime(2026, 7, 6),
    weekEndExclusive: DateTime(2026, 7, 13),
    focusedDuration: const Duration(minutes: 60),
    completedSessions: 2,
    cancelledSessions: 0,
    interruptionCount: interruptionsToday,
    interruptionDuration: Duration.zero,
    averageCompletedSessionDuration: const Duration(minutes: 30),
    activeStudyDays: activeDays,
  ),
  monthly: MonthlyStudyAnalytics(
    monthStart: DateTime(2026, 7),
    monthEndExclusive: DateTime(2026, 8),
    focusedDuration: const Duration(minutes: 60),
    completedSessions: 2,
    cancelledSessions: 0,
    interruptionCount: interruptionsToday,
    interruptionDuration: Duration.zero,
    activeStudyDays: activeDays,
  ),
  courses: const [],
  trends: trends,
);

StudyTrendSummary _trends({
  required double currentWeek,
  required double previousWeek,
  String? currentCourse,
  String? previousCourse,
}) {
  final focused = _comparison(currentWeek, previousWeek);
  final stable = _comparison(1, 1);
  return StudyTrendSummary(
    weekly: WeeklyTrend(
      focusedMinutes: focused,
      completedSessions: stable,
      averageSessionMinutes: stable,
      interruptions: stable,
      activeDays: stable,
      courseTrends: const [],
      currentDominantCourse: currentCourse,
      previousDominantCourse: previousCourse,
    ),
    monthly: MonthlyTrend(
      focusedMinutes: stable,
      completedSessions: stable,
      averageSessionMinutes: stable,
      interruptions: stable,
      activeDays: stable,
      courseTrends: const [],
    ),
  );
}

TrendComparison _comparison(double current, double previous) {
  final difference = current - previous;
  return TrendComparison(
    currentValue: current,
    previousValue: previous,
    signedDifference: difference,
    absoluteDifference: difference.abs(),
    percentageVariation: previous == 0 ? null : difference / previous * 100,
    direction: difference > 0
        ? TrendDirection.up
        : difference < 0
        ? TrendDirection.down
        : TrendDirection.stable,
  );
}
