import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/goals/application/goals_providers.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal_progress.dart';

export 'package:focusly/features/goals/domain/entities/focus_goal_progress.dart'
    show FocusGoalProgress, FocusGoalsProgress;
export 'package:focusly/features/goals/presentation/widgets/goal_progress_indicator.dart';

final class GoalsDashboardSummary {
  const GoalsDashboardSummary({
    required this.isLoading,
    this.progress,
    this.errorMessage,
    this.hasConfiguredGoals = false,
  });

  final bool isLoading;
  final FocusGoalsProgress? progress;
  final String? errorMessage;
  final bool hasConfiguredGoals;
}

final goalsDashboardSummaryProvider = Provider<GoalsDashboardSummary>((ref) {
  final state = ref.watch(focusGoalsNotifierProvider);
  return GoalsDashboardSummary(
    isLoading: state.isLoading,
    progress: state.progress,
    errorMessage: state.errorMessage,
    hasConfiguredGoals: state.goal?.hasEnabledGoals ?? false,
  );
});

final goalsRefreshProvider = Provider<Future<void> Function()>((ref) {
  return () => ref.read(focusGoalsNotifierProvider.notifier).refresh();
});
