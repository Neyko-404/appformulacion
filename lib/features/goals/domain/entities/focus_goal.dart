import 'package:focusly/features/goals/domain/entities/focus_goal_failure.dart';

final class FocusGoal {
  FocusGoal({
    required String ownerId,
    required this.createdAt,
    required this.updatedAt,
    this.dailyMinutesTarget,
    this.weeklyCompletedSessionsTarget,
    this.weeklyActiveDaysTarget,
  }) : ownerId = ownerId.trim() {
    _validate();
  }

  final String ownerId;
  final int? dailyMinutesTarget;
  final int? weeklyCompletedSessionsTarget;
  final int? weeklyActiveDaysTarget;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get hasEnabledGoals =>
      dailyMinutesTarget != null ||
      weeklyCompletedSessionsTarget != null ||
      weeklyActiveDaysTarget != null;

  FocusGoal updateDailyMinutes(int value, {required DateTime updatedAt}) =>
      _copy(dailyMinutesTarget: value, updatedAt: updatedAt);

  FocusGoal updateWeeklySessions(int value, {required DateTime updatedAt}) =>
      _copy(weeklyCompletedSessionsTarget: value, updatedAt: updatedAt);

  FocusGoal updateWeeklyActiveDays(int value, {required DateTime updatedAt}) =>
      _copy(weeklyActiveDaysTarget: value, updatedAt: updatedAt);

  FocusGoal disableDailyMinutes({required DateTime updatedAt}) => _copy(
    dailyMinutesTarget: null,
    clearDailyMinutes: true,
    updatedAt: updatedAt,
  );

  FocusGoal disableWeeklySessions({required DateTime updatedAt}) => _copy(
    weeklyCompletedSessionsTarget: null,
    clearWeeklySessions: true,
    updatedAt: updatedAt,
  );

  FocusGoal disableWeeklyActiveDays({required DateTime updatedAt}) => _copy(
    weeklyActiveDaysTarget: null,
    clearWeeklyActiveDays: true,
    updatedAt: updatedAt,
  );

  FocusGoal _copy({
    int? dailyMinutesTarget,
    int? weeklyCompletedSessionsTarget,
    int? weeklyActiveDaysTarget,
    bool clearDailyMinutes = false,
    bool clearWeeklySessions = false,
    bool clearWeeklyActiveDays = false,
    required DateTime updatedAt,
  }) => FocusGoal(
    ownerId: ownerId,
    dailyMinutesTarget: clearDailyMinutes
        ? null
        : dailyMinutesTarget ?? this.dailyMinutesTarget,
    weeklyCompletedSessionsTarget: clearWeeklySessions
        ? null
        : weeklyCompletedSessionsTarget ?? this.weeklyCompletedSessionsTarget,
    weeklyActiveDaysTarget: clearWeeklyActiveDays
        ? null
        : weeklyActiveDaysTarget ?? this.weeklyActiveDaysTarget,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  void _validate() {
    if (ownerId.isEmpty || updatedAt.isBefore(createdAt)) {
      throw FocusGoalFailure.invalidData();
    }
    if (!_inside(dailyMinutesTarget, 5, 480) ||
        !_inside(weeklyCompletedSessionsTarget, 1, 35) ||
        !_inside(weeklyActiveDaysTarget, 1, 7)) {
      throw FocusGoalFailure.invalidData();
    }
  }

  static bool _inside(int? value, int minimum, int maximum) =>
      value == null || (value >= minimum && value <= maximum);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FocusGoal &&
          ownerId == other.ownerId &&
          dailyMinutesTarget == other.dailyMinutesTarget &&
          weeklyCompletedSessionsTarget ==
              other.weeklyCompletedSessionsTarget &&
          weeklyActiveDaysTarget == other.weeklyActiveDaysTarget &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(
    ownerId,
    dailyMinutesTarget,
    weeklyCompletedSessionsTarget,
    weeklyActiveDaysTarget,
    createdAt,
    updatedAt,
  );
}
