import 'package:focusly/features/goals/domain/entities/focus_goal.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal_progress.dart';

final class FocusGoalsState {
  const FocusGoalsState({
    this.goal,
    this.progress,
    this.isLoading = true,
    this.isSaving = false,
    this.errorMessage,
    this.successMessage,
  });

  final FocusGoal? goal;
  final FocusGoalsProgress? progress;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final String? successMessage;

  FocusGoalsState copyWith({
    FocusGoal? goal,
    FocusGoalsProgress? progress,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    String? successMessage,
    bool clearGoal = false,
    bool clearProgress = false,
    bool clearError = false,
    bool clearSuccess = false,
  }) => FocusGoalsState(
    goal: clearGoal ? null : goal ?? this.goal,
    progress: clearProgress ? null : progress ?? this.progress,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    successMessage: clearSuccess ? null : successMessage ?? this.successMessage,
  );
}
