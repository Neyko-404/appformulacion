import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/analytics/domain/entities/study_insight.dart';
import 'package:focusly/features/analytics/domain/entities/study_trends.dart';
import 'package:focusly/features/companion/domain/entities/companion_state.dart';
import 'package:focusly/features/companion/domain/services/companion_state_engine.dart';

void main() {
  const engine = CompanionStateEngine();

  CompanionSnapshot derive({
    int minutes = 0,
    int sessions = 0,
    int interruptions = 0,
    int activeDays = 0,
    TrendDirection? trend,
    InsightCollection insights = const InsightCollection.empty(),
  }) => engine.derive(
    analyticsSummary: CompanionAnalyticsSummary(
      focusMinutesToday: minutes,
      completedSessionsToday: sessions,
      interruptionCountToday: interruptions,
      activeDaysThisWeek: activeDays,
    ),
    trendSummary: trend,
    studyInsights: insights,
  );

  test('no activity rests without a negative state', () {
    final value = derive();
    expect(value.mood, CompanionMood.resting);
    expect(value.expression, CompanionExpression.sleeping);
    expect(value.message, 'Estoy listo para acompañarte.');
  });

  test('one and several sessions derive encouraging and focused states', () {
    final one = derive(minutes: 25, sessions: 1);
    expect(one.mood, CompanionMood.encouraging);
    expect(one.expression, CompanionExpression.thinking);
    final several = derive(minutes: 50, sessions: 2);
    expect(several.mood, CompanionMood.focused);
    expect(several.expression, CompanionExpression.normal);
  });

  test('positive trend celebrates with happy or cheering expressions', () {
    expect(
      derive(minutes: 25, sessions: 1, trend: TrendDirection.up).expression,
      CompanionExpression.happy,
    );
    final value = derive(minutes: 50, sessions: 2, trend: TrendDirection.up);
    expect(value.mood, CompanionMood.celebrating);
    expect(value.expression, CompanionExpression.cheering);
  });

  test('interruptions prioritize neutral encouragement', () {
    final value = derive(minutes: 50, sessions: 2, interruptions: 3);
    expect(value.mood, CompanionMood.encouraging);
    expect(value.expression, CompanionExpression.thinking);
    expect(value.message, isNot(contains('triste')));
  });

  test(
    'partial activity supports the relaxed state and progress projection',
    () {
      final value = derive(
        minutes: 10,
        activeDays: 4,
        trend: TrendDirection.stable,
      );
      expect(value.mood, CompanionMood.relaxed);
      expect(value.expression, CompanionExpression.normal);
      expect(value.progress.focusMinutesToday, 10);
      expect(value.progress.activeDays, 4);
      expect(value.progress.weeklyTrend, TrendDirection.stable);
    },
  );

  test('all authorized moods and expressions remain reachable', () {
    final values = [
      derive(),
      derive(minutes: 10),
      derive(minutes: 25, sessions: 1),
      derive(minutes: 50, sessions: 2),
      derive(minutes: 25, sessions: 1, trend: TrendDirection.up),
      derive(minutes: 50, sessions: 2, trend: TrendDirection.up),
    ];
    expect(
      values.map((value) => value.mood).toSet(),
      CompanionMood.values.toSet(),
    );
    expect(
      values.map((value) => value.expression).toSet(),
      CompanionExpression.values.toSet(),
    );
  });
}
