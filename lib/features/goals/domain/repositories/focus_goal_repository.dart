import 'package:focusly/features/goals/domain/entities/focus_goal.dart';

abstract interface class FocusGoalRepository {
  Future<FocusGoal?> getByOwnerId(String ownerId);
  Future<void> save(FocusGoal goal);
}
