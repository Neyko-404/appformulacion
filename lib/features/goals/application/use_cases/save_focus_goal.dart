import 'package:focusly/features/goals/domain/entities/focus_goal.dart';
import 'package:focusly/features/goals/domain/repositories/focus_goal_repository.dart';

final class SaveFocusGoal {
  const SaveFocusGoal(this._repository);
  final FocusGoalRepository _repository;

  Future<void> call(FocusGoal goal) => _repository.save(goal);
}
