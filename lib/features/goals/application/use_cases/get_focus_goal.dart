import 'package:focusly/features/goals/domain/entities/focus_goal.dart';
import 'package:focusly/features/goals/domain/repositories/focus_goal_repository.dart';

final class GetFocusGoal {
  const GetFocusGoal(this._repository);
  final FocusGoalRepository _repository;

  Future<FocusGoal?> call(String ownerId) => _repository.getByOwnerId(ownerId);
}
