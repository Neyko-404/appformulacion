import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/goals/data/mappers/focus_goal_local_mapper.dart';
import 'package:focusly/features/goals/data/models/focus_goal_local_model.dart';
import 'package:focusly/features/goals/data/repositories/in_memory_focus_goal_repository.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal_failure.dart';

void main() {
  final now = DateTime.utc(2026, 7, 20);
  final goal = FocusGoal(
    ownerId: 'user-1',
    dailyMinutesTarget: 25,
    weeklyCompletedSessionsTarget: 3,
    weeklyActiveDaysTarget: 3,
    createdAt: now,
    updatedAt: now,
  );

  test('mapper round trip ignores the internal Isar identity', () {
    const mapper = FocusGoalLocalMapper();
    final local = mapper.toLocal(goal)..id = 999;
    expect(mapper.toDomain(local), goal);
    expect(mapper.toLocal(mapper.toDomain(local)).id, isNot(999));
  });

  test('mapper converts corrupt persisted targets into a safe failure', () {
    final local = FocusGoalLocalModel()
      ..ownerId = 'user-1'
      ..dailyMinutesTarget = 2
      ..createdAt = now
      ..updatedAt = now;
    expect(
      () => const FocusGoalLocalMapper().toDomain(local),
      throwsA(
        isA<FocusGoalFailure>().having(
          (failure) => failure.type,
          'type',
          FocusGoalFailureType.corruptedData,
        ),
      ),
    );
  });

  test('in-memory repository upserts one configuration per owner', () async {
    final repository = InMemoryFocusGoalRepository();
    expect(await repository.getByOwnerId('user-1'), isNull);
    await repository.save(goal);
    await repository.save(
      goal.updateDailyMinutes(40, updatedAt: now.add(const Duration(days: 1))),
    );
    expect((await repository.getByOwnerId('user-1'))?.dailyMinutesTarget, 40);
    expect(repository.saveCount, 2);
  });

  test('in-memory repository isolates owners', () async {
    final repository = InMemoryFocusGoalRepository(seedGoals: [goal]);
    expect(await repository.getByOwnerId('user-2'), isNull);
    expect(await repository.getByOwnerId('user-1'), goal);
  });
}
