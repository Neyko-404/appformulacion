import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/analytics/focus_goals_analytics_projection.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal_progress.dart';
import 'package:focusly/features/goals/domain/services/focus_goals_progress_calculator.dart';

void main() {
  final now = DateTime.utc(2026, 7, 20);
  const calculator = FocusGoalsProgressCalculator();

  test('progress clamps ratio and remaining for exceeded targets', () {
    final halfway = FocusGoalProgress.enabled(target: 20, current: 10);
    final exceeded = FocusGoalProgress.enabled(target: 20, current: 35);

    expect(halfway.completionRatio, .5);
    expect(halfway.remaining, 10);
    expect(halfway.isCompleted, isFalse);
    expect(exceeded.completionRatio, 1);
    expect(exceeded.remaining, 0);
    expect(exceeded.isCompleted, isTrue);
  });

  test('disabled progress is not presented as completed', () {
    const progress = FocusGoalProgress.disabled();
    expect(progress.isEnabled, isFalse);
    expect(progress.isCompleted, isFalse);
    expect(progress.completionRatio, 0);
  });

  test('uses only the supplied analytics projection deterministically', () {
    final goal = FocusGoal(
      ownerId: 'user-1',
      dailyMinutesTarget: 25,
      weeklyCompletedSessionsTarget: 3,
      weeklyActiveDaysTarget: 3,
      createdAt: now,
      updatedAt: now,
    );
    const analytics = FocusGoalsAnalyticsProjection(
      focusMinutesToday: 30,
      completedSessionsThisWeek: 2,
      activeDaysThisWeek: 1,
    );

    final first = calculator.calculate(goal: goal, analytics: analytics);
    final second = calculator.calculate(goal: goal, analytics: analytics);
    expect(first.dailyMinutes.current, 30);
    expect(first.dailyMinutes.completionRatio, 1);
    expect(first.weeklySessions.remaining, 1);
    expect(first.weeklyActiveDays.current, 1);
    expect(second.dailyMinutes.current, first.dailyMinutes.current);
  });

  test('keeps disabled goals disabled even when analytics has activity', () {
    final goal = FocusGoal(ownerId: 'user-2', createdAt: now, updatedAt: now);
    final progress = calculator.calculate(
      goal: goal,
      analytics: const FocusGoalsAnalyticsProjection(
        focusMinutesToday: 100,
        completedSessionsThisWeek: 5,
        activeDaysThisWeek: 4,
      ),
    );
    expect(progress.hasEnabledGoals, isFalse);
  });
}
