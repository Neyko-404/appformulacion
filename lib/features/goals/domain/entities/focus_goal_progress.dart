final class FocusGoalProgress {
  const FocusGoalProgress._({
    required this.target,
    required this.current,
    required this.remaining,
    required this.completionRatio,
    required this.isCompleted,
    required this.isEnabled,
  });

  factory FocusGoalProgress.enabled({
    required int target,
    required int current,
  }) {
    if (target <= 0 || current < 0) throw ArgumentError.value(current);
    final remaining = (target - current).clamp(0, target);
    return FocusGoalProgress._(
      target: target,
      current: current,
      remaining: remaining,
      completionRatio: (current / target).clamp(0, 1).toDouble(),
      isCompleted: current >= target,
      isEnabled: true,
    );
  }

  const factory FocusGoalProgress.disabled() = _DisabledFocusGoalProgress;

  final int target;
  final int current;
  final int remaining;
  final double completionRatio;
  final bool isCompleted;
  final bool isEnabled;
}

final class _DisabledFocusGoalProgress extends FocusGoalProgress {
  const _DisabledFocusGoalProgress()
    : super._(
        target: 0,
        current: 0,
        remaining: 0,
        completionRatio: 0,
        isCompleted: false,
        isEnabled: false,
      );
}

final class FocusGoalsProgress {
  const FocusGoalsProgress({
    required this.dailyMinutes,
    required this.weeklySessions,
    required this.weeklyActiveDays,
  });

  final FocusGoalProgress dailyMinutes;
  final FocusGoalProgress weeklySessions;
  final FocusGoalProgress weeklyActiveDays;

  bool get hasEnabledGoals =>
      dailyMinutes.isEnabled ||
      weeklySessions.isEnabled ||
      weeklyActiveDays.isEnabled;
}
