import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/goals/application/use_cases/get_focus_goal.dart';
import 'package:focusly/features/goals/application/use_cases/get_focus_goals_progress.dart';
import 'package:focusly/features/goals/application/use_cases/save_focus_goal.dart';
import 'package:focusly/features/goals/data/repositories/in_memory_focus_goal_repository.dart';
import 'package:focusly/features/goals/data/repositories/isar_focus_goal_repository.dart';
import 'package:focusly/features/goals/domain/repositories/focus_goal_repository.dart';
import 'package:focusly/features/goals/presentation/notifiers/focus_goals_notifier.dart';
import 'package:focusly/features/goals/presentation/state/focus_goals_state.dart';
import 'package:focusly/services/local_database/local_database_provider.dart';

final focusGoalRepositoryProvider = Provider<FocusGoalRepository>((ref) {
  final database = ref.watch(localDatabaseProvider);
  return database == null
      ? InMemoryFocusGoalRepository()
      : IsarFocusGoalRepository(database);
});

final getFocusGoalProvider = Provider<GetFocusGoal>(
  (ref) => GetFocusGoal(ref.watch(focusGoalRepositoryProvider)),
);

final saveFocusGoalProvider = Provider<SaveFocusGoal>(
  (ref) => SaveFocusGoal(ref.watch(focusGoalRepositoryProvider)),
);

final getFocusGoalsProgressProvider = Provider<GetFocusGoalsProgress>(
  (ref) => GetFocusGoalsProgress(ref.watch(focusGoalRepositoryProvider)),
);

final focusGoalsClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

final focusGoalsNotifierProvider =
    NotifierProvider<FocusGoalsNotifier, FocusGoalsState>(
      FocusGoalsNotifier.new,
    );
