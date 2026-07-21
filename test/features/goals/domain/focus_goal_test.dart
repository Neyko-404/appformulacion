import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal_failure.dart';

void main() {
  final createdAt = DateTime.utc(2026, 7, 20);

  FocusGoal goal({
    String ownerId = 'user-1',
    int? daily = 25,
    int? sessions = 3,
    int? days = 3,
    DateTime? updatedAt,
  }) => FocusGoal(
    ownerId: ownerId,
    dailyMinutesTarget: daily,
    weeklyCompletedSessionsTarget: sessions,
    weeklyActiveDaysTarget: days,
    createdAt: createdAt,
    updatedAt: updatedAt ?? createdAt,
  );

  test('accepts all disabled goals and exact boundaries', () {
    expect(
      goal(daily: null, sessions: null, days: null).hasEnabledGoals,
      isFalse,
    );
    expect(goal(daily: 5, sessions: 1, days: 1), isA<FocusGoal>());
    expect(goal(daily: 480, sessions: 35, days: 7), isA<FocusGoal>());
  });

  test('rejects empty owner, invalid dates and targets outside limits', () {
    expect(() => goal(ownerId: ' '), throwsA(isA<FocusGoalFailure>()));
    expect(
      () => goal(updatedAt: createdAt.subtract(const Duration(seconds: 1))),
      throwsA(isA<FocusGoalFailure>()),
    );
    expect(() => goal(daily: 4), throwsA(isA<FocusGoalFailure>()));
    expect(() => goal(sessions: 36), throwsA(isA<FocusGoalFailure>()));
    expect(() => goal(days: 8), throwsA(isA<FocusGoalFailure>()));
  });

  test('updates and disables without changing identity or creation date', () {
    final later = createdAt.add(const Duration(hours: 1));
    final updated = goal()
        .updateDailyMinutes(30, updatedAt: later)
        .updateWeeklySessions(4, updatedAt: later)
        .updateWeeklyActiveDays(5, updatedAt: later)
        .disableDailyMinutes(updatedAt: later);

    expect(updated.ownerId, 'user-1');
    expect(updated.createdAt, createdAt);
    expect(updated.updatedAt, later);
    expect(updated.dailyMinutesTarget, isNull);
    expect(updated.weeklyCompletedSessionsTarget, 4);
    expect(updated.weeklyActiveDaysTarget, 5);
  });

  test('supports value equality', () {
    expect(goal(), goal());
    expect(goal().hashCode, goal().hashCode);
  });
}
