import 'package:focusly/features/goals/domain/entities/focus_goal.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal_failure.dart';
import 'package:focusly/features/goals/domain/repositories/focus_goal_repository.dart';

final class InMemoryFocusGoalRepository implements FocusGoalRepository {
  InMemoryFocusGoalRepository({
    Iterable<FocusGoal> seedGoals = const [],
    this.readDelay = Duration.zero,
    this.writeDelay = Duration.zero,
    this.failReads = false,
    this.failWrites = false,
  }) : _goals = {for (final goal in seedGoals) goal.ownerId: goal};

  final Map<String, FocusGoal> _goals;
  final Duration readDelay;
  final Duration writeDelay;
  final bool failReads;
  final bool failWrites;

  int saveCount = 0;

  @override
  Future<FocusGoal?> getByOwnerId(String ownerId) async {
    if (ownerId.trim().isEmpty) throw FocusGoalFailure.invalidData();
    if (readDelay > Duration.zero) await Future<void>.delayed(readDelay);
    if (failReads) throw FocusGoalFailure.storage();
    return _goals[ownerId];
  }

  @override
  Future<void> save(FocusGoal goal) async {
    if (writeDelay > Duration.zero) await Future<void>.delayed(writeDelay);
    if (failWrites) throw FocusGoalFailure.storage();
    saveCount++;
    _goals[goal.ownerId] = goal;
  }
}
