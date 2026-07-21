import 'package:focusly/features/goals/data/models/focus_goal_local_model.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal_failure.dart';

final class FocusGoalLocalMapper {
  const FocusGoalLocalMapper();

  FocusGoalLocalModel toLocal(FocusGoal goal) => FocusGoalLocalModel()
    ..ownerId = goal.ownerId
    ..dailyMinutesTarget = goal.dailyMinutesTarget
    ..weeklyCompletedSessionsTarget = goal.weeklyCompletedSessionsTarget
    ..weeklyActiveDaysTarget = goal.weeklyActiveDaysTarget
    ..createdAt = goal.createdAt
    ..updatedAt = goal.updatedAt;

  FocusGoal toDomain(FocusGoalLocalModel model) {
    try {
      return FocusGoal(
        ownerId: model.ownerId,
        dailyMinutesTarget: model.dailyMinutesTarget,
        weeklyCompletedSessionsTarget: model.weeklyCompletedSessionsTarget,
        weeklyActiveDaysTarget: model.weeklyActiveDaysTarget,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
      );
    } on FocusGoalFailure {
      throw FocusGoalFailure.corruptedData();
    } on Object {
      throw FocusGoalFailure.corruptedData();
    }
  }
}
