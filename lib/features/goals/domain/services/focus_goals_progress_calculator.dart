import 'package:focusly/features/analytics/focus_goals_analytics_projection.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal_progress.dart';

final class FocusGoalsProgressCalculator {
  const FocusGoalsProgressCalculator();

  FocusGoalsProgress calculate({
    required FocusGoal goal,
    required FocusGoalsAnalyticsProjection analytics,
  }) => FocusGoalsProgress(
    dailyMinutes: _progress(
      goal.dailyMinutesTarget,
      analytics.focusMinutesToday,
    ),
    weeklySessions: _progress(
      goal.weeklyCompletedSessionsTarget,
      analytics.completedSessionsThisWeek,
    ),
    weeklyActiveDays: _progress(
      goal.weeklyActiveDaysTarget,
      analytics.activeDaysThisWeek,
    ),
  );

  FocusGoalProgress _progress(int? target, int current) => target == null
      ? const FocusGoalProgress.disabled()
      : FocusGoalProgress.enabled(target: target, current: current);
}
