import 'package:focusly/features/analytics/focus_goals_analytics_projection.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal_progress.dart';
import 'package:focusly/features/goals/domain/repositories/focus_goal_repository.dart';
import 'package:focusly/features/goals/domain/services/focus_goals_progress_calculator.dart';

final class GetFocusGoalsProgress {
  const GetFocusGoalsProgress(
    this._repository, {
    this.calculator = const FocusGoalsProgressCalculator(),
  });

  final FocusGoalRepository _repository;
  final FocusGoalsProgressCalculator calculator;

  Future<({FocusGoal? goal, FocusGoalsProgress? progress})> call({
    required String ownerId,
    required FocusGoalsAnalyticsProjection analytics,
  }) async {
    final goal = await _repository.getByOwnerId(ownerId);
    if (goal == null) return (goal: null, progress: null);
    return (
      goal: goal,
      progress: calculator.calculate(goal: goal, analytics: analytics),
    );
  }
}
